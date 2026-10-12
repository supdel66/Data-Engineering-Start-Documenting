create database supp;


create table manager(
    m_id int PRIMARY key ,
    mname varchar(100)
);

create table employee(
    id int primary key,
    name varchar(100),
    m_id int,
    foreign key (m_id) references manager(m_id)
);

