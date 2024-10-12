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

# data quality issues ----------------------------------------------------------

## 1. invalid pharmacy_charge values -------------------------------------------

# summary stats for each column - pharmarcy_charage contains invalid values
summary(clean)

# determine min/max of pharmarcy_charge column
# max is 2.130293e+130
# min is 1.079388e+13
max(clean$pharmacy_charge, na.rm = T) 
min(clean$pharmacy_charge, na.rm = T) 

# [NOTE] The whole column looks wrong so will omit pharmarcy charges from analysis
# TODO: Analysis should be revisted after consulting with data owners on how this data is collected, unrealistic values captured and implementing data validation checks
clean <- clean[, pharmacy_charge := NULL]

## 2. missing value treatment --------------------------------------------------

# identify columns with missing values
colSums(is.na(clean))

# missing value treatment for numeric variables: 0 if na
clean <- clean[
  , `:=` (
    ccu_charges = fcoalesce(ccu_charges, 0)
    , icu_charge = fcoalesce(icu_charge, 0)
    , theatre_charge = fcoalesce(theatre_charge, 0)
    , prosthesis_charge = fcoalesce(prosthesis_charge, 0)
    , other_charges = fcoalesce(other_charges, 0)
    , bundled_charges = fcoalesce(bundled_charges, 0)
    , infant_weight = fcoalesce(infant_weight, 0)
    , hours_mech_ventilation = fcoalesce(hours_mech_ventilation, 0)
  )
]

# missing value treatment for character variables: data unavailable if na 
clean <- clean[
  , `:=` (
    unplanned_theatre_visit = fcoalesce(unplanned_theatre_visit, "Data unavailable")
    , readmission28days = fcoalesce(readmission28days, "Data unavailable")
    , palliative_care_status = fcoalesce(palliative_care_status, "Data unavailable")
  )
]

# check there are no more missing values in data 
colSums(is.na(clean))
clean[, .N, .(unplanned_theatre_visit)]


