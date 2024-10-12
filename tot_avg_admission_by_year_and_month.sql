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

