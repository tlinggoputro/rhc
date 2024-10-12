# setup ------------------------------------------------------------------------

# run 01 script to get clean data with features created
source("C:/Users/linGG/OneDrive/Documents/rhc/01_data_exploration_and_preparation.R")

# data analysis ----------------------------------------------------------------

# sum total charges, days of stay by DRG
base <- feature[
  , .(
    total_charges_ex_pharm = sum(total_charges_ex_pharm),
    accommodation_charge = sum(accommodation_charge),
    ccu_charges = sum(ccu_charges),
    icu_charge = sum(icu_charge),
    theatre_charge = sum(theatre_charge),
    prosthesis_charge = sum(prosthesis_charge),
    other_charges = sum(other_charges),
    bundled_charges = sum(bundled_charges),
    days_of_stay = sum(days_of_stay)
  )
  , .(ar_drg, mode_of_separation, care_type, urgency_of_admission, unplanned_theatre_visit, readmission28days, palliative_care_status, episode_patient_age_group, business_hours_flag)
] %>% arrange(desc(total_charges_ex_pharm))
