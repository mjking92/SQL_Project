-- Returns top 5 skills most frequently mentioned in job adverts 

SELECT
    skill_id,
    skills
FROM 
    skills_dim
WHERE 
    skill_id IN (
        SELECT 
            skill_id
        FROM 
            skills_job_dim
        GROUP BY
            skill_id
        ORDER BY
            COUNT(skill_id) DESC
        LIMIT 
            5
);

-- Returns the top 5 skills most frequently mentioned along with their names 

SELECT
    sd.skill_id,
    sd.skills,
    sjd.num_in_jobs
FROM 
    skills_dim AS sd
JOIN (
    SELECT
        skill_id,
        COUNT(skill_id) AS num_in_jobs
    FROM
        skills_job_dim
    GROUP BY   
        skill_id
    ORDER BY
        num_in_jobs DESC    
    LIMIT   
        5
) AS sjd ON sd.skill_id = sjd.skill_id
    ORDER BY
        sjd.num_in_jobs DESC


--- The same as above but using a CTE (clearer)

WITH top_skills AS (
    SELECT
        skill_id,
        COUNT(skill_id) AS num_of_mentions
    FROM
        skills_job_dim
    GROUP BY
        skill_id
    ORDER BY
        num_of_mentions DESC
    LIMIT 
        5
)

SELECT
    -- sd.skill_id,
    sd.skills,
    ts.num_of_mentions
FROM 
    top_skills AS ts
JOIN
    skills_dim AS sd ON sd.skill_id = ts.skill_id 
ORDER BY
    num_of_mentions DESC

-- Returns the companies that most frequently post job offerings along with a status column which states how actively they post. 

WITH top_posters AS (
    SELECT
        company_id,
        COUNT(company_id) AS num_of_postings
    FROM
        job_postings_fact
    GROUP BY
        company_id
    ORDER BY
        num_of_postings DESC 
    LIMIT
        750
)

SELECT 
    cd.company_id,
    cd.name AS company_name,
    tp.num_of_postings,
    CASE 
        WHEN tp.num_of_postings < 100 THEN 'infrequent'
        WHEN tp.num_of_postings BETWEEN 100 AND 500 THEN 'regular'
        ELSE 'frequent' 
    END AS posting_status
FROM 
    top_posters AS tp 
JOIN 
    company_dim AS cd ON cd.company_id = tp.company_id
ORDER BY 
    num_of_postings DESC;

-- Display the count of the number of job postings for data analysts per skill, wherein all postings are remote, along with the skill ID and skill name 

WITH top_skills AS (
    SELECT
        sjd.skill_id,
        COUNT(skill_id) AS num_of_mentions
    FROM
        job_postings_fact AS jpf
    INNER JOIN
        skills_job_dim AS sjd ON jpf.job_id = sjd.job_id 
    WHERE 
        job_work_from_home = true AND 
        job_title_short = 'Data Analyst'
    GROUP BY
        sjd.skill_id
    ORDER BY
        num_of_mentions DESC
)

SELECT 
    ts.skill_id,
    sd.skills AS skill,
    ts.num_of_mentions
FROM
    top_skills AS ts
INNER JOIN
     skills_dim AS sd ON sd.skill_id = ts.skill_id
ORDER BY
    ts.num_of_mentions DESC
LIMIT
    5;

-- The same again but in a single query 

SELECT
    sjd.skill_id,
    sd.skills,
    COUNT(sjd.skill_id) AS num_of_mentions
FROM
    job_postings_fact jpf
JOIN
    skills_job_dim sjd ON jpf.job_id = sjd.job_id
JOIN
    skills_dim sd ON sd.skill_id = sjd.skill_id
WHERE
    job_work_from_home = true AND
    job_title_short = 'Data Analyst'
GROUP BY
    sjd.skill_id, sd.skills
ORDER BY
    num_of_mentions DESC
LIMIT 5;