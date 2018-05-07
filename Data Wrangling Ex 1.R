library(dplyr)
library(gdata)
library(tidyr)

datapull <- read.csv(file = "C:/Users/bryan_000/Documents/Springboard-Capstone/Data Wrangling Ex 1/refine_original.csv")

salesdata <- tbl_df(datapull)

print(salesdata, n=25)

# Fix misspelled company names, separate Product Codes and Numbers into 2 columns.
salesdata <- salesdata %>%
  mutate(company = gsub(".*ps.*","philips",company, ignore.case = TRUE)) %>%
  mutate(company = gsub(".*ak.*","akzo",company, ignore.case = TRUE)) %>%
  mutate(company = gsub(".*van.*","van houten",company, ignore.case = TRUE)) %>%
  mutate(company = gsub(".*uni.*","unilever",company, ignore.case = TRUE)) %>%
  mutate(product_code = substr(Product.code...number,1,1)) %>%
  mutate(product_number = substr(Product.code...number,3,4))

# Create product category mapping data frame
product_category <- c("Smartphone", "TV", "Laptop", "Tablet")
product_code <- c("p", "v", "x", "q")
prod_cat_df <- data.frame(product_code, product_category)

# Join product category map to main database
salesdata <- left_join(salesdata, prod_cat_df, by = "product_code")

# Create full address column
salesdata <- salesdata %>%
  mutate(full_address = paste(address, city, country, sep = ", "))

# Create binary company and product code columns
salesdata <- salesdata %>%
  mutate(one = 1) %>%
  spread(company, one, fill = 0, sep = "_") %>%
  mutate(one = 1) %>%
  spread(product_code, one, fill = 0, sep = "_")

View(salesdata)

write.csv(salesdata, "refine_clean.csv")