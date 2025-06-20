SELECT
    job_schedule_type AS job_type,
    COUNT(job_schedule_type) AS num_of_jobs, 
    ROUND(AVG(salary_year_avg), 2) AS average_salary,
    ROUND(AVG(salary_hour_avg), 2) AS average_rate
FROM    
    job_postings_fact
WHERE 
    job_posted_date >= '2023-06-02' AND
    (salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL) AND
    job_schedule_type IS NOT NULL
GROUP BY
    job_schedule_type
ORDER BY 
    average_salary


SELECT 
    COUNT(job_id) AS num_of_jobs_2023,
    EXTRACT(MONTH FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST')) AS month_est
FROM 
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST')) = 2023
GROUP BY
    EXTRACT(MONTH FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'))
ORDER BY
    num_of_jobs_2023 DESC


SELECT 
    cd.company_id,
    cd.name AS company_name,
    COUNT(jpf.job_id) AS num_of_jobs_2023_q2,
    EXTRACT(MONTH FROM jpf.job_posted_date) AS month
FROM 
    job_postings_fact AS jpf
JOIN
    company_dim AS cd ON jpf.company_id = cd.company_id
WHERE 
    jpf.job_health_insurance::INT = 1 AND
    (EXTRACT(MONTH FROM jpf.job_posted_date) BETWEEN 4 AND 6)
GROUP BY
    cd.company_id, cd.name, month
ORDER BY
    month, num_of_jobs_2023_q2 DESC

