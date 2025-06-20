
SELECT 
    quarter1_job_postings.job_title_short AS job_title,
    quarter1_job_postings.job_location AS location,
    quarter1_job_postings.job_via AS platform,
    quarter1_job_postings.salary_year_avg AS salary,
    quarter1_job_postings.job_posted_date::DATE AS posted_date
FROM (
    SELECT *
    FROM 
        january_jobs
    UNION ALL
    SELECT *
    FROM
        february_jobs
    UNION ALL
    SELECT *
    FROM
        march_jobs
) AS quarter1_job_postings 
WHERE 
    quarter1_job_postings.salary_year_avg > 70000 AND
    quarter1_job_postings.job_title = 'Data Analyst'
ORDER BY
    salary DESC