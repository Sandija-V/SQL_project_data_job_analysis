SELECT 
    job_title_short,
    company_id,
    job_location
FROM    
    january_jobs

UNION ALL
    
SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL
    
SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs



SELECT
    jan.job_id,
    jan.job_title_short,
    jan.salary_year_avg,
    sd.skills AS skill_name,
    sd.type AS skill_type
FROM
    january_jobs AS jan
LEFT JOIN skills_job_dim AS sjd ON jan.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    jan.salary_year_avg > 70000
    
UNION ALL

SELECT
    feb.job_id,
    feb.job_title_short,
    feb.salary_year_avg,
    sd.skills AS skill_name,
    sd.type AS skill_type
FROM    
    february_jobs AS feb
LEFT JOIN skills_job_dim AS sjd ON feb.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    feb.salary_year_avg > 70000

UNION ALL

SELECT
    mar.job_id,
    mar.job_title_short,
    mar.salary_year_avg,
    sd.skills AS skill_name,
    sd.type AS skill_type
FROM 
    march_jobs AS mar
LEFT JOIN skills_job_dim AS sjd ON mar.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    mar.salary_year_avg > 70000


SELECT 
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM (
SELECT *
FROM january_jobs

UNION ALL

SELECT *
FROM february_jobs

UNION ALL

SELECT *
FROM march_jobs
) AS quarter1_job_postings
WHERE
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC



