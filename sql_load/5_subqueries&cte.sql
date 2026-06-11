SELECT *
    FROM (
        SELECT *
        FROM job_postings_fact
        WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ) AS january_jobs;
    

-- Common Table Expressions (CTEs)
WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT *
FROM january_jobs;


SELECT 
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE company_id IN (
    SELECT  
        company_id
    FROM 
        job_postings_fact
    WHERE 
        job_no_degree_mention = true
    ORDER BY
        company_id
)



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
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC;


-- Answer to the 1st task using CTE
WITH skill_count AS (
    SELECT 
        skill_id,
        COUNT(*) as total_skills
    FROM
        skills_job_dim
    GROUP BY
        skill_id
)

SELECT  
    skills_dim.skills AS skill_name,
    skill_count.total_skills
FROM 
    skills_dim
INNER JOIN skill_count ON skill_count.skill_id = skills_dim.skill_id
ORDER BY
    total_skills DESC
LIMIT 5;


-- Answer to the task using subquery
SELECT
    s.skills AS skill_name,
    top_skills.total_skills
FROM    
    skills_dim AS s
INNER JOIN (
    SELECT
        skill_id,
        COUNT(*) AS total_skills
    FROM 
        skills_job_dim
    GROUP BY 
        skill_id
    ORDER BY
        total_skills DESC
    LIMIT 5
) AS top_skills ON top_skills.skill_id = s.skill_id
ORDER BY
    top_skills.total_skills DESC;


SELECT
    c.name AS company_name,
    company_job_counts.total_jobs,
    CASE
        WHEN company_job_counts.total_jobs < 10 THEN 'Small'
        WHEN company_job_counts.total_jobs BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS company_size
FROM
    company_dim AS c 
INNER JOIN (
    SELECT
        company_id,
        COUNT(job_id) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY
        company_id
) AS company_job_counts ON c.company_id = company_job_counts.company_id
ORDER BY
    total_jobs DESC;



SELECT 
    jobs.job_country,
    AVG(salary_year_avg) AS country_avg_salary
FROM 
    job_postings_fact AS jobs
INNER JOIN (
    SELECT
        job_country,
        COUNT(job_id) AS total_postings
    FROM 
        job_postings_fact
    GROUP BY    
        job_country
    HAVING
        COUNT(job_id) > 100
) AS popular_countries
    ON jobs.job_country = popular_countries.job_country 
WHERE
    jobs.salary_year_avg IS NOT NULL
GROUP BY
    jobs.job_country  
ORDER BY
    country_avg_salary DESC;



WITH remote_job_skills AS (
    SELECT 
        skill_id,
        COUNT(*) AS skill_count
    FROM 
        skills_job_dim AS skills_to_job
    INNER JOIN 
        job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE 
        job_postings.job_work_from_home = true AND
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM
    remote_job_skills
INNER JOIN
    skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5



