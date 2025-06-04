SELECT * FROM proju.project;

-- 1. Identifying globally in-demand job titles and comparing their average salaries by location.

SELECT 
    job_title,
    company_location,
    COUNT(*) AS Total_Jobs,
    ROUND(AVG(salary_usd), 2) AS Average_Salary
FROM Project
GROUP BY 1,2
ORDER BY 3 DESC;


-- 2. Identify the AI job titles that offer the highest average salaries globally helping to highlight top-tier roles in terms of compensation.

WITH Salary_Ranking AS (
    SELECT 
        job_title,
        ROUND(COALESCE(AVG(salary_usd), 0), 2) AS Average_Salary,
        DENSE_RANK() OVER (
            ORDER BY ROUND(COALESCE(AVG(salary_usd), 0), 2) DESC
        ) AS Salary_Rank
    FROM Project
    GROUP BY job_title
)

SELECT * FROM Salary_Ranking
WHERE Salary_Rank <= 5;

-- 3. Track monthly trends in the number of job postings and analyze how average salaries fluctuate over time.

SELECT 
    DATE_FORMAT(posting_date, '%Y-%m') AS posting_month,
    COUNT(*) AS Total_Postings,
    round(coalesce(avg(salary_usd),0),2) as Average_Salary
FROM Project
GROUP BY posting_month
order by 1;

-- 4. Examine how remote work influences salaries across experience levels and job titles.

SELECT 
    job_title,
    years_experience AS Experience_Level,
    experience_level,
    ROUND(COALESCE(AVG(salary_usd), 0), 2) AS Average_Salary,
    ROUND(COALESCE(AVG(remote_ratio), 0), 2) AS Average_Remote_Ratio,
    COUNT(*) AS Total_Postings
FROM
    project
GROUP BY 1 , 2 , 3
ORDER BY 2 DESC , 4 DESC;

-- 5. Compare average salaries and remote work flexibility across different countries.

SELECT 
    company_location AS Country,
    ROUND(COALESCE(AVG(salary_usd), 0), 2) AS Average_Salary,
    ROUND(COALESCE(AVG(remote_ratio), 0), 2) AS Average_Remote_Ratio
FROM
    project
GROUP BY 1
ORDER BY 2 DESC;

-- 6. Analyze how average salaries vary by both experience level and industry.

SELECT 
    experience_level,
    industry,
    ROUND(coalesce(AVG(salary_usd),0), 2) AS Average_Salary
FROM Project
GROUP BY experience_level, industry
ORDER BY 1,3 DESC;

-- Average salary by experience level and how does it differ across industries? 

SELECT 
    experience_level,
    industry,
    ROUND(COALESCE(AVG(salary_usd), 0), 2) AS Average_Salary
FROM
    project
GROUP BY 1 , 2
ORDER BY 3 DESC;

-- How does the required education level (Bachelor, Master, PhD) affect average salary and job description length?

WITH GlobalAvg AS (
    SELECT 
        AVG(salary_usd) AS global_salary,
        AVG(job_description_length) AS global_desc
    FROM Project
)

SELECT 
    education_required,
    ROUND(AVG(salary_usd), 2) AS avg_salary,
    ROUND(AVG(job_description_length), 2) AS avg_desc_length,
    ROUND(AVG(salary_usd) - (SELECT global_salary FROM GlobalAvg), 2) AS salary_diff,
    ROUND(AVG(job_description_length) - (SELECT global_desc FROM GlobalAvg), 2) AS desc_diff
FROM Project
GROUP BY education_required
ORDER BY avg_salary DESC;




