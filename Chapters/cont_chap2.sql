----SUBQUERIES AND CTES

--subbquery 
select * from (
    SELECT * from job_postings_fact where salary_hour_avg is not null
) as valid_salaries
limit 5;

--CTE 
with valid_salaries as (
        SELECT * from job_postings_fact where salary_hour_avg is not null

)
select * from valid_salaries limit 10;

--scneario on subquery in select 
--show job salary next to market median 

describe 
select * from job_postings_fact;

select job_title_short,salary_year_avg,
(select median(salary_year_avg) from job_postings_fact where salary_year_avg is not null) from job_postings_fact where salary_year_avg is not null limit 4;


--stage jobs only remote before aggregatings  to determine remote salary median
select job_title_short,salary_year_avg,
(select median(salary_year_avg) 
    from job_postings_fact where salary_year_avg is not null and job_work_from_home=True) 
from 
(select * from job_postings_fact where job_work_from_home=True and salary_year_avg is not null) 
limit 4;

--subquery in having college keep job title whose median salary is above overall median 
explain analyze
select
    job_title_short, (select median(salary_year_avg) 
    from job_postings_fact where salary_year_avg is not null and job_work_from_home=True) as median_salary 
    from 
    (select * from job_postings_fact where job_work_from_home=True and salary_year_avg is not null) as j  
    group by job_title_short
    having median(salary_year_avg)> (select median(salary_year_avg) 
    from job_postings_fact where salary_year_avg is not null and job_work_from_home=True )
    limit 5 ;

┌────────────────────────────────────────────────┐
│┌──────────────────────────────────────────────┐│
││              Total Time: 0.291s              ││
│└──────────────────────────────────────────────┘│
└────────────────────────────────────────────────┘

--- using cte for performace

-- inside a CTE, the CTE name median_salary represents a relation (a table-like result). When you select median_salary in your final query, DuckDB is interpreting it as the whole row/struct, not the m column inside it.
-- That's why you get:
-- {'m': 130000.0}


with remote_jobs as(
    select job_title_short, salary_year_avg
    from job_postings_fact 
    where salary_year_avg is not null 
    and job_work_from_home=True
),
median_salary as(
    select median(salary_year_avg) as m from remote_jobs
)

SELECT job_title_short, median_salary , salary_year_avg from remote_jobs cross join median_salary limit 4;

┌──────────────────┬──────────────────┬─────────────────┐
│ job_title_short  │  median_salary   │ salary_year_avg │
│     varchar      │ struct(m double) │     double      │
├──────────────────┼──────────────────┼─────────────────┤
│ Business Analyst │ {'m': 130000.0}  │         90000.0 │
│ Data Scientist   │ {'m': 130000.0}  │        202500.0 │
│ Data Scientist   │ {'m': 130000.0}  │        113000.0 │
│ Data Engineer    │ {'m': 130000.0}  │     137320.3125 │


with remote_jobs as(
    select job_title_short, salary_year_avg
    from job_postings_fact 
    where salary_year_avg is not null 
    and job_work_from_home=True
),
median_salary as(
    select median(salary_year_avg) as m from remote_jobs
)

SELECT job_title_short, median_salary.m , salary_year_avg from remote_jobs cross join median_salary limit 4;
┌──────────────────┬──────────┬─────────────────┐
│ job_title_short  │    m     │ salary_year_avg │
│     varchar      │  double  │     double      │
├──────────────────┼──────────┼─────────────────┤
│ Business Analyst │ 130000.0 │         90000.0 │
│ Data Scientist   │ 130000.0 │        202500.0 │
│ Data Scientist   │ 130000.0 │        113000.0 │
│ Data Engineer    │ 130000.0 │     137320.3125 │



explain analyze
with remote_jobs as(
    select job_title_short, salary_year_avg
    from job_postings_fact 
    where salary_year_avg is not null 
    and job_work_from_home=True
),
median_salary as(
    select median(salary_year_avg) as m from remote_jobs
)

SELECT job_title_short, median(salary_year_avg),median_salary.m from remote_jobs cross join median_salary 
group by job_title_short, median_salary.m
having median(salary_year_avg )> median_salary.m
limit 4;

0.272 seconds 

with title_median

select job_title_short, median(salary_year_avg), job_work_from_home
from job_postings_fact group by job_title_short, job_work_from_home;




with remote_jobs as (
    select job_title_short, salary_year_avg
    from job_postings_fact 
    where salary_year_avg is not null 
    and job_work_from_home=True
),
onsite_jobs as (
    select job_title_short, salary_year_avg
    from job_postings_fact 
    where salary_year_avg is not null 
    and job_work_from_home=False
)
select r.job_title_short , median(r.salary_year_avg), median(o.salary_year_avg)
from remote_jobs as r inner join onsite_jobs as o on r.job_title_short=o.job_title_short
group by r.job_title_short
;
┌───────────────────────────┬───────────────────────────┬───────────────────────────┐
│      job_title_short      │ median(r.salary_year_avg) │ median(o.salary_year_avg) │
│          varchar          │          double           │          double           │
├───────────────────────────┼───────────────────────────┼───────────────────────────┤
│ Cloud Engineer            │                  132000.0 │                  117625.0 │
│ Senior Data Analyst       │                  105000.0 │                  110432.5 │
│ Machine Learning Engineer │                  138433.5 │                  135000.0 │
│ Senior Data Engineer      │                  145000.0 │                  147500.0 │
│ Senior Data Scientist     │                  160000.0 │                  155000.0 │
│ Data Engineer             │                  135000.0 │                  130000.0 │
│ Software Engineer         │                  180000.0 │                  130000.0 │
│ Data Analyst              │                   87500.0 │                   90000.0 │
│ Data Scientist            │                  132500.0 │                  125000.0 │
│ Business Analyst          │                   90000.0 │                   92500.0 │
└───────────────────────────┴───────────────────────────┴───────────────────────────┘


select range(10);
┌────────────────────────────────┐
│          "range"(10)           │
│            int64[]             │
├────────────────────────────────┤
│ [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] │



select * from range(10) as src(key) 
where exists (
select 1 from range(3) as target(key)
where target.key=src.key
);


select * from job_postings_fact as src
where not exists (
    select 1 from skills_job_dim as target 
    where src.job_id=target.job_id
)order by job_id limit 10; 