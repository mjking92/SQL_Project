SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;

SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN salary_year_avg <= 45000 THEN 'low'
        WHEN salary_year_avg > 45000 AND salary_year_avg <= 90000 THEN 'standard'
        ELSE 'high'
    END AS salary_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    salary_category
ORDER BY
    number_of_jobs DESC;

