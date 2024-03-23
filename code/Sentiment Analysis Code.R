library(tidytext)
library(dplyr)
library(stringr)
library(SnowballC)
library(tidyr)
library(textdata)
library(readr)
library(textstem)
library(ggplot2)
library(wordcloud)
library(reshape2)

setwd('~/DATA 332/Sentiment Analysis/DATA')
df_consumer_complaint <- read_csv('~/DATA 332/Sentiment Analysis/DATA/Consumer_Complaints.csv')

# Remove empty spaces in the complaints column
df_consumer_complaints <- df_consumer_complaint %>%
  filter(`Consumer complaint narrative` != "")

#selecting the company, product and the consumer complaints
company_consumer_complaints <- df_consumer_complaints%>%
  dplyr::select(Company, Product, `Consumer complaint narrative`)

company_consumer_complaints$`Consumer complaint narrative` <- tolower(company_consumer_complaints$`Consumer complaint narrative`)  # Convert to lowercase
company_consumer_complaints$`Consumer complaint narrative` <- str_replace_all(company_consumer_complaints$`Consumer complaint narrative`, "\\b\\w{1,2}\\b", "")  # Remove short words 

# Define the stop words list
stopwords_list <- c("and", "the", "so", "etc.", "uspmo", "xxxx", "@")

# Remove common stop words
for (stopword in stopwords_list) {
  company_consumer_complaints$`Consumer complaint narrative` <- str_replace_all(company_consumer_complaints$`Consumer complaint narrative`, paste0("\\b", stopword, "\\b"), "")
}

# Remove punctuation
company_consumer_complaints$`Consumer complaint narrative` <- str_replace_all(company_consumer_complaints$`Consumer complaint narrative`, "[[:punct:]]", "")

# Remove numbers
company_consumer_complaints$`Consumer complaint narrative` <- str_remove_all(company_consumer_complaints$`Consumer complaint narrative`, "\\d+")

# Remove extra spaces
company_consumer_complaints$`Consumer complaint narrative` <- str_squish(company_consumer_complaints$`Consumer complaint narrative`)

get_sentiments("afinn")
get_sentiments("nrc")
get_sentiments("bing")

tidy_words_by_row <- company_consumer_complaints%>%
  group_by(Product) %>%
  mutate(linenumber = row_number())%>%
  ungroup() %>%
  unnest_tokens(word, `Consumer complaint narrative`)

nrc_joy <- get_sentiments("nrc") %>%
  filter(sentiment == "joy")

tidy_words_by_row %>%
  filter(Product == "Credit card") %>%
  inner_join(nrc_joy) %>%
  count(word, sort = TRUE)

#Positive and Negative values for each product
product_sentiment <- tidy_words_by_row %>%
  inner_join(get_sentiments("bing")) %>%
  count(Product,index = linenumber %/% 80, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>%
  mutate(sentiment = positive - negative)

ggplot(product_sentiment, aes(index, sentiment, fill = Product)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~Product, ncol = 2, scales = "free_x")

#Comparing the 3 dictionaries
afinn <- tidy_words_by_row %>%
  inner_join(get_sentiments("afinn")) %>%
  group_by(index = linenumber %/% 80) %>%
  summarise(sentiment = sum(value)) %>%
  mutate(method = "AFINN")

bing_and_nrc <- bind_rows(
  tidy_words_by_row %>%
    inner_join(get_sentiments("bing")) %>%
    mutate(method = "Bing et al."),
  tidy_words_by_row %>%
    inner_join(get_sentiments("nrc") %>%
                 filter(sentiment %in% c("positive", 
                                         "negative"))
    ) %>%
    mutate(method = "NRC")) %>%
  count(method, index = linenumber %/% 80, sentiment) %>%
  pivot_wider(names_from = sentiment,
              values_from = n,
              values_fill = 0) %>%
  mutate(sentiment = positive - negative)

bind_rows(afinn,
          bing_and_nrc) %>%
  ggplot(aes(index, sentiment, fill = method)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~method, ncol = 1, scales = "free_y")

#Common positive and negative words
bing_word_counts <- tidy_words_by_row %>%
  inner_join(get_sentiments("bing"))  %>%
  count(word, sentiment, sort =TRUE) %>%
  ungroup()

bing_word_counts %>%
  group_by(sentiment) %>%
  slice_max(n, n = 10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(x = "Contribution to sentiment",
       y = NULL)

#Wordclouds
tidy_words_by_row %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red4", "blue3"),
                   max.words = 200)

