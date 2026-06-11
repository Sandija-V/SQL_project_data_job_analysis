SELECT     
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date 
FROM
    job_postings_fact;


SELECT     
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM
    job_postings_fact
LIMIT 5;


SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month 
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    job_posted_count DESC;


SELECT 
    job_schedule_type,
    AVG(salary_year_avg),
    AVG(salary_hour_avg)
FROM 
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type;


SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_york') AS date_month,
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS date_year,
    COUNT(job_id) AS job_count
FROM
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = 2023
GROUP BY
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_york'),
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York')
ORDER BY
    date_month;


SELECT
    j.company_id,
    c.name AS company
FROM 
    job_postings_fact AS j
INNER JOIN
    company_dim AS c ON j.company_id = c.company_id
WHERE
    j.job_health_insurance = true AND
    EXTRACT(YEAR FROM j.job_posted_date) = 2023 AND
    EXTRACT(QUARTER FROM j.job_posted_date) = 2
GROUP BY
    c.name,
    j.company_id
ORDER BY
    company;


CREATE TABLE january_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE  EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE  EXTRACT(MONTH FROM job_posted_date) = 2;


CREATE TABLE march_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE  EXTRACT(MONTH FROM job_posted_date) = 3;



SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;


SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN salary_year_avg < 90000 THEN 'low'
        WHEN salary_year_avg > 90000 AND salary_year_avg < 100000 THEN 'standard'
        ELSE 'high'
    END AS salary
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY 
    CASE
        WHEN salary_year_avg < 90000 THEN 'low'
        WHEN salary_year_avg > 90000 AND salary_year_avg < 100000 THEN 'standard'
        ELSE 'high'
    END
ORDER BY
    number_of_jobs ASC;

