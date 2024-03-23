# Consumer Complaint Sentiment Analysis
## Feven Ferede

## Introduction
This project involved sentiment analysis of consumer complaints for bank products and services.
<div align = "center">
<img src = "Images/Sentimen Analysis Pic.jpg" width = "450")>
</div>

## Dictionary📔
The columns that were primarily used are: 
1. Company: the company (bank) names.
2. Product: the product/service they provided that consumer's issued a complaint against.
3. Consumer complaint narrative: the complaint consumer's addressed towards the company.

## Data Cleaning
1. Consumer complaint narrative:
   i. Removing empty spaces:
     - Within the Consumer complaint narrative, it only showed 'NA' because of the empty spaces that made it             unreadable. So, I removed the empty spaces so the complaints were readable.
       ```
        df_consumer_complaints <- df_consumer_complaint %>%
        filter(`Consumer complaint narrative` != "")
       ```
   ii. Making a new table:
     -  The original csv file had 19 columns and all of that is not needed for the analysis. So I created a new           table with only 3: Company, Product, and Consumer complaint narrative.
        ```
        company_consumer_complaints <- df_consumer_complaints%>%
        dplyr::select(Company, Product, `Consumer complaint narrative`)
        ```
   iii. Conversion and removal of words:
     - To make the sentiment analysis smoother and more efficient as well as accurate, I removed all
       punctuations, stopwords (unnecessary words that aren't needed for sentiment analysis), short words,
       numbers, and extra spaces. I also turned all the words into lowercase.
        ```
        # Convert to lowercase
        company_consumer_complaints$`Consumer complaint narrative` <-
        tolower(company_consumer_complaints$`Consumer complaint narrative`)
         # Remove short words 
        company_consumer_complaints$`Consumer complaint narrative` <-
        str_replace_all(company_consumer_complaints$`Consumer complaint narrative`, "\\b\\w{1,2}\\b", "")
        # Define the stop words list
        stopwords_list <- c("and", "the", "so", "etc.", "uspmo", "xxxx", "@")

        # Remove common stop words
        for (stopword in stopwords_list) {
       company_consumer_complaints$`Consumer complaint narrative` <-
        str_replace_all(company_consumer_complaints$`Consumer complaint narrative`, paste0("\\b", stopword,
        "\\b"), "")
        }

        # Remove punctuation
        company_consumer_complaints$`Consumer complaint narrative` <-
        str_replace_all(company_consumer_complaints$`Consumer complaint narrative`, "[[:punct:]]", "")

        # Remove numbers
        company_consumer_complaints$`Consumer complaint narrative` <-
        str_remove_all(company_consumer_complaints$`Consumer complaint narrative`, "\\d+")

        # Remove extra spaces
        company_consumer_complaints$`Consumer complaint narrative` <-
        str_squish(company_consumer_complaints$`Consumer complaint narrative`)
         ```
