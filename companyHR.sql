/*CREATE DATABASE companyHR;
USE companyHR;
CREATE TABLE co_employees(
	id int primary key auto_increment,
	em_name varchar(255) not null,
	gender char(1) not null,
	contact_number varchar(255),
	age int not null,
	date_created timestamp not null default now()
);
create table mentorships(
	mentor_id int not null,
    mentee_id int not null,
    status varchar(255) not null,
    project varchar(255) not null,
    
    primary key (mentor_id, mentee_id, project),
    constraint fk1 foreign key(mentor_id) references co_employees(id) on delete cascade on update restrict,
    constraint fk2 foreign key(mentee_id) references co_employees(id) on delete cascade on update restrict,
    constraint mm_constraint unique(mentor_id, mentee_id)
);
rename table co_employees to employees;
alter table employees
	drop column age,
    add column salary float not null after contact_number,
    add column years_in_company int not null after salary;
describe employees;

alter table mentorships
	drop foreign key fk2;
alter table mentorships
	add constraint fk2 foreign key(mentee_id) references employees(id) on delete cascade on update cascade,
    drop index mm_constraint;

# insert data
insert into employees (em_name, gender, contact_number, salary, years_in_company) values
('James Lee', 'M', '516-514-6568', 3500, 11),
('Peter Pasternak', 'M', '845-644-7919', 6010, 10),
('Clara Couto', 'F', '845-641-5236', 3900, 8),
('Walker Welch', 'M', NULL, 2500, 4),
('Li Xiao Ting', 'F', '646-218-7733', 5600, 4),
('Joyce Jones', 'F', '523-172-2191', 8000, 3),
('Jason Cerrone', 'M', '725-441-7172', 7980, 2),
('Prudence Phelps', 'F', '546-312-5112', 11000, 2),
('Larry Zucker', 'M', '817-267-9799', 3500, 1),
('Serena Parker', 'F', '621-211-7342', 12000, 1);

insert into mentorships values
(1, 2, 'Ongoing', 'SQF Limited'),
(1, 3, 'Past', 'Wayne Fibre'),
(2, 3, 'Ongoing', 'SQF Limited'),
(3, 4, 'Ongoing', 'SQF Limited'),
(6, 5, 'Past', 'Flynn Tech');

update employees set contact_number = '516-514-1729' where id = 1;

update employees set id = 11 where id = 4;	
delete from employees where id = 5;		


select * from employees where gender = 'M';*/

select employees.id, mentorships.mentor_id, 
employees.em_name as 'Mentor', mentorships.project as 'Project Name'
from mentorships join employees on employees.id = mentorships.mentor_id;

