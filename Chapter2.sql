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