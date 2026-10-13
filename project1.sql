--- TOP SKILLS IN DEMAND FOR DATA ENGINEER 

select distinct s.skills , count(jdf.*)
  from skills_dim as s inner join skills_job_dim as sj on s.skill_id = sj.skill_id
  inner join job_postings_fact as jdf on jdf.job_id=sj.job_id
  where jdf.job_title_short = 'Data Engineer'
  group by s.skills 
  order by count(*) desc limit 10 
  ; 

  ┌────────────┬──────────────┐
│   skills   │ count_star() │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │       233132 │
│ python     │       224102 │
│ aws        │       130205 │
│ azure      │       128822 │
│ spark      │       106904 │
│ java       │        69657 │
│ databricks │        63012 │
│ snowflake  │        60379 │
│ scala      │        57079 │
│ kafka      │        56410 │
└────────────┴──────────────┘


--- TOP PAYING SKILLS 
select distinct s.skills , count(jdf.*), round(median(jdf.salary_year_avg),0) as med
  from skills_dim as s inner join skills_job_dim as sj on s.skill_id = sj.skill_id
  inner join job_postings_fact as jdf on jdf.job_id=sj.job_id
  where jdf.job_title_short = 'Data Engineer' and
  jdf.job_work_from_home=True
  group by s.skills 
  having count(jdf.*) >100
  order by med  desc limit 10 
  ; 
┌───────────┬──────────────┬──────────┐
│  skills   │ count_star() │   med    │
│  varchar  │    int64     │  double  │
├───────────┼──────────────┼──────────┤
│ rust      │          232 │ 210000.0 │
│ terraform │         3248 │ 184000.0 │
│ golang    │          912 │ 184000.0 │
│ spring    │          364 │ 175500.0 │
│ neo4j     │          277 │ 170000.0 │
│ gdpr      │          582 │ 169616.0 │
│ zoom      │          127 │ 168438.0 │
│ graphql   │          445 │ 167500.0 │
│ mongo     │          265 │ 162250.0 │
│ fastapi   │          204 │ 157500.0 │


---optimal skills for data engineer 

select 
    round(ln(count(jdf.*) * round(median(jdf.salary_year_avg),0)),1) as optimal, s.skills
    from skills_dim as s 
    inner join skills_job_dim as sj on s.skill_id = sj.skill_id
    inner join job_postings_fact as jdf on jdf.job_id=sj.job_id
     where 
     jdf.job_title_short = 'Data Engineer' and
    jdf.job_work_from_home=True
     and jdf.salary_year_avg is not null 
  group by s.skills 
  having count(jdf.*) >100
  order by optimal desc limit 10 
  ; 

│ optimal │  skills   │
│ double  │  varchar  │
├─────────┼───────────┤
│    18.8 │ python    │
│    18.8 │ sql       │
│    18.5 │ aws       │
│    18.1 │ spark     │
│    17.9 │ azure     │
│    17.9 │ airflow   │
│    17.9 │ snowflake │
│    17.6 │ kafka     │
│    17.5 │ java      │
│    17.4 │ redshift  │