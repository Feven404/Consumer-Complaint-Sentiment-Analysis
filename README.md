# Consumer Complaint Sentiment Analysis
## By: Feven Ferede

---
# Introduction
This project involved sentiment analysis of consumer complaints for bank products and services.
<div align = "center">
<img src = "Images/Sentimen Analysis Pic.jpg" width = "450")>
</div>

---
# Dictionary
The columns that were primarily used are: 
1. Company: the company (bank) names.
2. Product: the product/service they provided that consumer's issued a complaint against.
3. Consumer complaint narrative: the complaint consumer's addressed towards the company.

---
# Data Cleaning 
## 1. Consumer complaint narrative:
   i. Removing empty spaces:
     - Within the Consumer complaint narrative, it only showed 'NA' because of the empty spaces that made it             unreadable. So, I removed the empty spaces so the complaints were readable.
       ```
        df_consumer_complaints <- df_consumer_complaint %>%
        filter(`Consumer complaint narrative` != "")
       ```
   ii. Making a new table:
     -  The original csv file had 19 columns and all of that is not needed for the analysis. So I created a             new table with only 3: Company, Product, and Consumer complaint narrative.
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
        
---
# Data Summary
## Below is a preview of how the table will appear after the analysis (due to a large number of observations, only a selection is shown here. And the ellipses are only there becausse the complaints are very lengthy):
|Company|Product|Consumer complaint narrative|
|---|:-:|--:|
|Capital One|Credit card|received capital one charge card offer applied was accepted...|
|CCS Financial Services, Inc.|Debt collection|know how they got cell number told them would deal only...|
|Citizens Financial Group, Inc.|Credit card|longtime member charter one bankrbs citizens bank when...|
|Experian|Credit reporting|after looking credit report saw collection account that does...|
|Big Picture Loans, LLC|Debt collection|received call from from ext stating that owed $ but they want...|
|Oliphant Financial Corporation|Student loan|was not contacted years later about some private loan supp...|
|Collection Consultants of California|Debt collection|collection consultants reporting collection account all credit...|
|Collection Consultants of California|Debt collection|collection consultants reporting collection account all credit...|
|Experian|Credit reporting|had purse stolen they never found person responsible cancell...|
|Discover|Credit card|attempted apply for discover card online system did hard cr...|
|Stellar Recovery Inc.|Debt collection|continued attempts collect debt under name debt was clearly ...|
|Citibank|Student loan|this continuation previous issue with citibank that has reached...|
|Citibank|Debt collection|going through divorce were unable pay mortgage for few mo...|
|Ditech Financial LLC|Mortgage|assisted with mortgage through agency since this helps pay...|
|Ocwen|Mortgage|submitted payment for sons mortgage payment every month ...|
|Encore Capital Group|Debt collection|recieved notice from midland credit management inc mcm th...|

---
# Data Analysis
## 1. Positive and Negative values for each product
<div align = "center">
<img src = "Images/Product Sentiment Index Plot.png" width = "450")>
</div>

- This is a sentiment value analysis of the consumer complaints in regards to the product/service the consumer's were complaining under.

- There are a total of 12 products/services.

- The virtual currency segment appears to be stagnant at 0 due to the limited number of complaints received for this product. Because of the large number of complaints for the other products/services, I did the indexing to occur every 80 lines. However to accomodate for the sparse data for virtual currency, I reduced the index to 0.25 to provide a more detailed view. The resulting graph illustrates minimal movement from the baseline of 0, reflecting the scarcity of complaints in this category:

<div align = "center">
<img src = "Images/Part of a SAIP.png" width = "1000", height = "220")>
</div>


## 2. Comparison of the 3 Dictionaries
<div align = "center">
<img src = "Images/3 Dictionaries Comparison.png" width = "450")>
</div>

- A comparison of the 3 dictionaries (afinn, bing, and nrc) used to analyse the consumer complaint sentiments. 

## 3. Common Positive and Negative Words
<div align = "center">
<img src = "Images/Common Positive and Negative Words.png" width = "450")>
</div>

- A total sum of the common positive and negative words in the complaints.

- There are significantly large amounts of negative words, the most common one close to 60,000 occurences. While the most common positive word has only nearly 20,000 occurences.

## 4. Wordcloud
<div align = "center">
<img src = "Images/Positive Negative Wordcloud.png" width = "450")>
</div>

---
# Conclusion
From the sentiment analysis, it can be concluded that the consumer's faced a lot of troubles and expressed dissatisfaction. 
