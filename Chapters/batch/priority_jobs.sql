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


-- --update 
-- update main.priority_jobs_snapshot as tgt 
-- set priority_lvl=src.priority_lvl,
-- updated_at=src.updated_at 
-- from src_priority_jobs as src 
-- where tgt.job_id=src.job_id 
-- and 
-- tgt.priority_lvl is distinct from src.priority_lvl; 

-- --insert 
-- insert into main.priority_jobs_snapshot(
--     job_id,
--     job_title_short,
--     company_name,
--     job_posted_date,
--     salary_year_avg,
--     priority_lvl,
--     updated_at
-- ) select src.job_id, src.job_title_short, 
-- src.name, src.job_posted_date, src.salary_year_avg, src.priority_lvl,
-- src.updated_at from src_priority_jobs as src
-- where not exists (
--     select 1 from main.priority_jobs_snapshot as tgt 
--     where tgt.job_id = src.job_id 
-- );

--  --delete
--  delete from main.priority_jobs_snapshot as tgt 
--  where not exists (
--     select 1 
--     from src_priority_jobs as src where src.job_id= tgt.job_id 
--  ); 

--using merge statement 
-- merge into target table as tgt 
-- using sourcetable as src 
-- on tgt.column=src.column 

-- when matched then 
-- update set 
-- tgt.column1=src.column2 , etc 

-- when not matched then 
-- insert () values (src.column, etc)




merge into main.priority_jobs_snapshot as tgt using 
src_priority_jobs as src 
on tgt.job_id= src.job_id 
when matched and tgt.priority_lvl is distinct from src.priority_lvl then 
update set priority_lvl=src.priority_lvl, updated_at=src.updated_at 
when not matched by target then 
insert (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
) values ( src.job_id, src.job_title_short, 
src.name, src.job_posted_date, src.salary_year_avg, src.priority_lvl,
src.updated_at)
when not matched by source then delete; 










select job_title_short, count(*) as job_count , 
min(priority_lvl), min(updated_at) from priority_jobs_snapshot
group by job_title_short order by job_count desc;
