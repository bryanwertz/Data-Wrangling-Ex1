library(dplyr)
library(tidyr)
install.packages("ragtop")
library(ragtop)

titanicdata <- read.csv(file = "C:/Users/bryan_000/Documents/Springboard-Capstone/Data Wrangling Ex/titanic3.csv")

View(titanicdata)

# Replace missing embarked vales, fill empty boat values with "None", add has cabin column

avg_age <- mean(titanicdata$age, na.rm = TRUE)

titanicdata <- titanicdata %>% 
  mutate( embarked = gsub("^$", "S", embarked)) %>%
  mutate( boat = gsub("^$", "None", boat)) %>%
  mutate( has_cabin_number = gsub("^$", "None", cabin)) %>% 
  mutate( has_cabin_number = ifelse(has_cabin_number == "None", 0, 1))

# Fill in missing age values with the mean of the existing values

titanicdata$age[is.na(titanicdata$age)] <- avg_age

View(titanicdata)

write.csv(titanicdata, "titanic_clean.csv")