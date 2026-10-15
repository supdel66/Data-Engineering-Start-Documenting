create or replace temp table src_priority_jobs as 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP as updated_at 
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles AS r
    ON jpf.job_title_short = r.role_name;


--update 
update main.priority_jobs_snapshot as tgt 
set priority_lvl=src.priority_lvl,
updated_at=src.updated_at 
from src_priority_jobs as src 
where tgt.job_id=src.job_id 
and 
tgt.priority_lvl is distinct from src.priority_lvl; 


