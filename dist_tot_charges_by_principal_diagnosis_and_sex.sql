-- Purpose: Analyse the distribution of TotalCharges by PrincipalDiagnosis and Sex. Use percentiles to describe the distribution.
-- Approach:
-- 1. Determine the min, 25th, median, 75th and max for total_charges_ex_pharm by principal_diagnosis and sex:

SELECT 
    principal_diagnosis,
    sex,
    MIN(total_charges_ex_pharm) AS min_tot_charges,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_charges_ex_pharm) AS p25_tot_charges,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY total_charges_ex_pharm) AS median_tot_charges,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_charges_ex_pharm) AS p75_tot_charges,
    MAX(total_charges_ex_pharm) AS max_tot_charges
FROM 
    -- This table represents the cleaned up data from part 1 (performed in R)
    dt_rhc_admissions_clean
GROUP BY 1,2
ORDER BY 1,2
;
