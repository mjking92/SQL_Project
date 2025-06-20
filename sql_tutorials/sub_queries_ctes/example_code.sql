-- Return all jobs posted in january 
-- Subquery

SELECT *
FROM (
    SELECT *
    FROM
        job_postings_fact
    WHERE 
        EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs; 

-- CTE

WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT *
FROM january_jobs

---
-- Which companies are offering jobs that do not require a degree?

SELECT
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE 
    company_id IN (
    SELECT
        company_id
    FROM 
        job_postings_fact
    WHERE
        job_no_degree_mention = true
);

-- Companies with the most job offerings

WITH company_job_count AS (
SELECT
    company_id,
    COUNT(*) AS total_jobs
FROM
    job_postings_fact
GROUP BY
    company_id
)

SELECT 
    cd.name,
    cjc.total_jobs
FROM 
    company_dim AS cd
JOIN 
    company_job_count AS cjc ON cd.company_id = cjc.company_id
ORDER BY
    total_jobs DESC