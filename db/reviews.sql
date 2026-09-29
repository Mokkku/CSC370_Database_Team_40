-- Non-persistence for database -------------------------------------

DROP DATABASE IF EXISTS reviews;
create database Reviews;
use reviews;
-- ---------------------------------------------------------------------




-- Create tables for db ------------------------------------------------

create table users(
    user_id int primary key auto_increment,
    username varchar(50),
    is_admin boolean);
    
create table questions(
	question_id int primary key,
    title varchar(100),
    date_created date,
    body_text varchar(5000));
    
create table answers(
	answer_id int primary key,
    date_created date,
    text_body varchar(5000),
	question_id int,
    foreign key (question_id) references questions(question_id));
    
create table metadata(
	tag_id int primary key,
    keyword varchar(120),
    question_id int,
    foreign key (question_id) references questions(question_id));
-- ------------------------------------------------------------------




-- Generate dummy entries ----------------------------------------------------------------

insert into users (username, is_admin)
values	('alpha_admin', true),
		('bravo_user', false),
		('charlie_dev', true),
		('delta_user', false),
		('echo_guest', false);
        
insert into questions
values(12345, 'How long should I boil an egg?', '2000-09-16', 'How long should I realisticlaly boil an egg for a runny consistency?'),
		(00000, 'difference between text and varchar in sql', '2016-05-10', 'what is the performance difference between using text vs. varchar(5000) for storing body text?'),
		(12346,'is it bool or boolean in mysql', '2026-09-28', 'I\'m using MySQL version 5.1.49-1ubuntu8.1. It allows me to define columns of two different data types: BOOL and BOOLEAN. What are the differences between the two types?');

insert into answers 
values 	(1, '2000-09-17', 'for a runny yolk, boil the egg for 6 to 7 minutes and put it in an ice bath immediately after.', 12345),
		(2, '2000-09-18', '6 minutes in boiling water will give you a runny yolk and set whites.', 12345),
		(3, '2016-05-11', 'in mysql, varchar is stored inline with the row up to its defined limit, while text is stored off-page if large.', 0),
		(4, '2026-09-28', 'in mysql, bool and boolean are exact synonyms for tinyint(1). 0 is false, 1 is true.', 12346);

insert into metadata 
values	(1, 'cooking', 12345),
		(2, 'eggs', 12345),
		(3, 'sql', 0),
		(4, 'database', 0),
		(5, 'mysql', 12346),
		(6, 'boolean', 12346);
-- Show tables and data ----------------------------------------------------------------

show tables;
select * from users;
select * from questions;
select * from answers;
select * from metadata;