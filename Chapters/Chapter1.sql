-- Select * from information_schema.tables 
-- where table_catalog='data_jobs'; 

use data_jobs;
  select job_via from job_postings_fact where job_country is not null order by salary_rate asc
  limit 2;

use data_jobs;
select job_title 
rom job_postings_fact 
GROUP BY job_title, salary_hour_avg
having salary_hour_avg >100;

Select * from information_schema.table_constraints
where table_catalog='data_jobs' and table_name='job_postings_fact'; 


use data_jobs;
select 
    j.*
from job_postings_fact as j left join company_dim as c 
on j.company_id = c.company_id limit 10;


day 1 5:06:30 

explain ---just estimates doesnt execute them 
select 
  cd.name , count(jpf.*) from job_postings_fact as jpf left join company_dim as cd 
  on jpf.company_id=cd.company_id group by cd.name;


explain analyze---executes them 
select 
  cd.name , count(jpf.*) from job_postings_fact as jpf left join company_dim as cd 
  on jpf.company_id=cd.company_id group by cd.name;


--- DATA TYPES 
