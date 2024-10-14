-- Purpose: Calculate the total and average admissions for each month over the last two years. Include the month and year in the results. 
-- Approach:
-- 1. Determine total admission by year and month
-- 2. Calculate the average admission for the month across years e.g. Jan 2024 = 10 and Jan 2023 = 5, then the average admission for Jan is 7.5

WITH monthly_admissions AS (-- calculate total admissions by year and month
    SELECT 
        EXTRACT(YEAR FROM admission_date) AS admission_year,
        EXTRACT(MONTH FROM admission_date) AS admission_month,
        COUNT(*) AS tot_admissions
    FROM 
        -- This table represents the cleaned up data from part 1 (performed in R)
        dt_rhc_admissions_clean
    GROUP BY 1,2
)

-- calculate the average admission for each month across years
SELECT 
    admission_year,
    admission_month,
    tot_admissions,
    AVG(tot_admissions) OVER (PARTITION BY admission_month) AS avg_admissions_per_month
FROM 
    monthly_admissions
ORDER BY 1 desc, 2 desc
;

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
