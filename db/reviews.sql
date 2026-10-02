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
    
CREATE TABLE `post` (
	`post_id` INT PRIMARY KEY,
	`date_created` date,
	`text_body` varchar(5000),
	user_id int
);
    
CREATE TABLE `question` (
	`question_id` INT PRIMARY KEY,
	`title` VARCHAR(120),
	foreign key (question_id) references post (post_id) on delete cascade
);
    
CREATE TABLE `answer` (
	`answer_id` INT PRIMARY KEY,
	`question_id` int,
	foreign key (answer_id) references post (post_id) on delete cascade,
    foreign key (question_id) references question (question_id) on delete cascade
);
    
CREATE TABLE `Metadata` (
	`tag_id` INT PRIMARY KEY auto_increment,
	`keyword` VARCHAR(60),
	`question_id` INT, FOREIGN KEY (`question_id`) REFERENCES `Question`(`question_id`) on delete cascade
);

create table VotesOn (
	user_id int,
	post_id int,
	vote_type int,
	FOREIGN KEY (user_id) REFERENCES `users`(user_id),
	FOREIGN KEY (post_id) REFERENCES post(post_id),
	primary key (user_id, post_id)
);


-- ------------------------------------------------------------------




-- Generate dummy entries ----------------------------------------------------------------

insert into users (username, is_admin)
values	('alpha_admin', true),
		('bravo_user', false),
		('charlie_dev', true),
		('delta_user', false),
		('echo_guest', false);
        
insert into post 
	values(12345, "2006-01-23", "this is a question.", 1),
    (1, "2005-02-23", "this is an answer.", 2);
    
insert into question
	values(12345, "Question title.");
    
insert into answer
	values(1, 12345);
    
insert into metadata (keyword, question_id)
	values("tag1", 12345),
    ("tag2", 12345);
    
-- delete from post where post_id = 12345;

-- Show tables and data ----------------------------------------------------------------

show tables;
select * from users;
select * from post;
select * from question;
select * from answer;
select * from metadata;