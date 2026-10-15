create or replace table main.priority_jobs_snapshot(
    job_id int primary key,
    job_title_short varchar,
    company_name varchar,
    job_posted_date timestamp,
    salary_year_avg double,
    priority_lvl int,
    updated_at timestamp
);

INSERT INTO main.priority_jobs_snapshot (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles AS r
    ON jpf.job_title_short = r.role_name;


select job_title_short, count(*) as job_count , 
min(priority_lvl), min(updated_at) from priority_jobs_snapshot
group by job_title_short order by job_count desc;
