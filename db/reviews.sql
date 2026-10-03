-- Non-persistence for database -------------------------------------

DROP DATABASE IF EXISTS reviews;
create database Reviews;
use reviews;
-- ---------------------------------------------------------------------




-- Create tables for db ------------------------------------------------

create table users(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50),
    is_admin BOOLEAN);
    
CREATE TABLE `post` (
	`post_id` INT PRIMARY KEY,
	`date_created` DATE,
	`text_body` VARCHAR(5000),
	user_id INT
);
    
CREATE TABLE `question` (
	`question_id` INT PRIMARY KEY,
	`title` VARCHAR(120),
	FOREIGN KEY (`question_id`) REFERENCES post (post_id) ON DELETE CASCADE
);
    
CREATE TABLE `answer` (
	`answer_id` INT PRIMARY KEY,
	`question_id` int,
	FOREIGN KEY (answer_id) REFERENCES post (post_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question (question_id) ON DELETE CASCADE
);
    
CREATE TABLE `Metadata` (
	`tag_id` INT PRIMARY KEY AUTO_INCREMENT,
	`keyword` VARCHAR(60),
	`question_id` INT, FOREIGN KEY (`question_id`) REFERENCES `Question`(`question_id`) ON DELETE CASCADE
);

create table VotesOn (
	`user_id` INT,
	`post_id` INT,
	`vote_type` INT,
	PRIMARY KEY (`user_id`, `post_id`),
	FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`),
	FOREIGN KEY (`post_id`) REFERENCES `post`(`post_id`)
);

CREATE TABLE `Reports` (
	`user_id` INT,
	`post_id` INT,
	PRIMARY KEY(`user_id`, `post_id`),
	FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`),
    FOREIGN KEY (`post_id`) REFERENCES `post`(`post_id`)
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