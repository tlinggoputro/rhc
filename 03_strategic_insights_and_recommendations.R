# setup ------------------------------------------------------------------------

# run 01 script to get clean data with features created
source("C:/Users/linGG/OneDrive/Documents/rhc/01_data_exploration_and_preparation.R")

# charge per day analysis ------------------------------------------------------
# determine the distribution of charge per day of each admission provider ID for the top 3 DRGs this year

# establish base table
cpd_base <- copy(feature)[# sum total charges and days of stay by DRG and admission provider for the last 12 months
  admission_year_flag == 'TY' & ar_drg %in% c('DRG001', 'DRG002', 'DRG003')
  , .(
    total_charges_ex_pharm = sum(total_charges_ex_pharm)
    , days_of_stay = sum(days_of_stay)
  )
  , .(ar_drg, admission_provider_id)
][# calculate charge per day for each DRG and admission provider
  , `:=` (
    charge_per_day = total_charges_ex_pharm/days_of_stay
  )
] %>% arrange(ar_drg)

# output for visualisation
write.csv(cpd_base, file = 'cpd_data.csv')

# days of stay analysis ------------------------------------------------------
# determine the distribution of days of stay for each admission for the top 3 DRG this year

# establish base table
dos_base <- copy(feature)[# get total charges and days of stay for each admission in the last 12 months (keep DRG and source of referral)
  admission_year_flag == 'TY' & ar_drg %in% c('DRG001', 'DRG002', 'DRG003')
  , .(
    ar_drg
    , care_type
    , source_of_referral
    , total_charges_ex_pharm
    , days_of_stay
  )
] %>% arrange(ar_drg, care_type, source_of_referral)

# output for visualisations
write.csv(dos_base, file = 'dos_data.csv')
