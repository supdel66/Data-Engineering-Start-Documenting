-- we are trying to learn merge but doing batch processing with insert update delete  

create or replace table staging.priority_roles(
    role_id int primary key,
    role_name varchar,
    priority_lvl int
);

insert into staging.priority_roles 
values
(1, 'Data Engineer', 1),
(2,'Senior Data Analyst', 1),
(3,'Machine Learning Engineer',8)
;

select * from staging.priority_roles