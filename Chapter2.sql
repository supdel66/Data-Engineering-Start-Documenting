select column_name, data_type from information_schema.columns
where table_catalog='data_jobs' and table_name='job_postings_fact'
;

---specific to duck db sabai ma hudiana 
describe job_postings_fact;

describe
select job_id, company_id from job_postings_fact limit 10;
┌─────────────────────────────┐
│      job_postings_fact      │
│                             │
│ job_id     integer not null │
│ company_id integer          │
└─────────────────────────────┘


SELECT 'Hello' || ' ' || 'World' AS result;
Hello World

select cast('12' as integer);

select cast(job_work_from_home as int) , cast(job_posted_date as date)
from job_postings_fact limit 10;

select job_title|| ' ' ||job_location , cast(job_work_from_home as int) , cast(job_posted_date as date)
from job_postings_fact limit 10;

select '12'::integer;

7 14 12

use data_jobs;
drop database if exists job_mart;
create database if not exists job_mart;


select * from information_schema.schemata;

create schema job_mart.staging; 

use job_mart;
create schema staging; -- no need specifying db name here  

--if schema not specified sidhai main schema ma janxa 
create table staging.prefered_roles (
    role_id int primary key,
    role_name varchar(20)
);

select * from information_schema.tables where table_catalog='job_mart';


insert into staging.prefered_roles values 
(1,'data engineer'),
(2,'never ml ai engineer')
;

describe
select * from staging.prefered_roles;

describe
SELECT
  constraint_name
FROM information_schema.table_constraints
WHERE table_catalog = 'job_mart'
ORDER BY table_name;


alter table staging.prefered_roles add column age int;
update staging.prefered_roles set age=20;

alter table staging.prefered_roles rename column age to stain_on_earth;

describe
select job_id, jpf.company_id,job_title from data_jobs.job_postings_fact as jpf 
left join data_jobs.company_dim as cd on jpf.company_id=cd.company_id limit 4;


create table staging.job_postings_flat as
select job_id, jpf.company_id,job_title from data_jobs.job_postings_fact as jpf 
left join data_jobs.company_dim as cd on jpf.company_id=cd.company_id limit 4;

select * from staging.job_postings_flat;




create temp table job_postings_flat as  --no need staging bcz doesnt go into schema
select job_id, jpf.company_id,job_title from data_jobs.job_postings_fact as jpf 
left join data_jobs.company_dim as cd on jpf.company_id=cd.company_id limit 4;


delete from staging.job_postings_flat where company_id>20000;

truncate removes all rows, keep columns 
truncate table staging.job_postings_flat

