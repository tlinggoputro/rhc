# setup ------------------------------------------------------------------------

# set working directory
setwd("C:\\Users\\linGG\\OneDrive\\Documents\\Tim's Personal Work\\2024\\ramsay_health")

# install.packages

# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("stringr")
# install.packages("lubridate")
# install.packages("ggplot2")
# install.packages("data.table")
# install.packages("openxlsx")
# install.packages("janitor")

# load libraries 

library("dplyr")
library("tidyr")
library("stringr")
library("lubridate")
library("ggplot2")
library("data.table")
library("openxlsx")
library("janitor")

# initial data prep ------------------------------------------------------------

# import and read data
filepath <- "C:\\Users\\linGG\\OneDrive\\Documents\\Tim's Personal Work\\2024\\ramsay_health\\Data Insights - Synthetic Dataset.xlsx"
raw <- read.xlsx(filepath, detectDates = T) %>% clean_names() %>% data.table()

# high level look at data
str(raw)
colSums(is.na(raw))

# basic data cleaning to be consistent with raw excel data
clean <- copy(raw)[# clean admission time and separation time so that it is POSIXct
  , `:=` (
    admission_time = as.POSIXct(admission_time * 24 * 3600, origin=admission_date, tz="UTC")
    , separation_time = as.POSIXct(separation_time * 24 * 3600, origin=separation_date, tz="UTC")
  )
][# make charges numeric
  , `:=` (
    accommodation_charge = as.numeric(accommodation_charge)
    , ccu_charges = as.numeric(ccu_charges)
    , icu_charge = as.numeric(icu_charge)
    , theatre_charge = as.numeric(theatre_charge)
    , pharmacy_charge = as.numeric(pharmacy_charge)
    , prosthesis_charge = as.numeric(prosthesis_charge)
    , other_charges = as.numeric(other_charges)
    , bundled_charges = as.numeric(bundled_charges)
  )
][# make id's and postcode character data type
  , `:=` (
    episode_id = as.character(episode_id)
    , postcode = as.character(postcode)
    , admission_provider_id = as.character(admission_provider_id)
  )
]

# determine the primary key
# [NOTE] primary key: insurer_id, episode_id, admission_provider_id, admission_date
clean[, .N, by = .(insurer_id, episode_id, admission_provider_id, admission_date)][N>1]


