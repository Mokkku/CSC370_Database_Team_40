-- Non-persistence for database -------------------------------------

DROP DATABASE IF EXISTS reviews;
create database Reviews;
use reviews;
-- ---------------------------------------------------------------------




-- Create tables for db ------------------------------------------------

create table `users`(
    `user_id` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(50),
    `is_admin` BOOLEAN);
    
CREATE TABLE `post` (
	`post_id` INT PRIMARY KEY,
	`date_created` DATE,
	`text_body` VARCHAR(5000),
	`user_id` INT
);
    
CREATE TABLE `question` (
	`question_id` INT PRIMARY KEY,
	`title` VARCHAR(120),
	FOREIGN KEY (`question_id`) REFERENCES post (post_id) ON DELETE CASCADE
);
    
CREATE TABLE `answer` (
	`answer_id` INT PRIMARY KEY,
	`question_id` int,
	FOREIGN KEY (`answer_id`) REFERENCES `post` (`post_id`) ON DELETE CASCADE,
    FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`) ON DELETE CASCADE
);
    
CREATE TABLE `Metadata` (
	`tag_id` INT PRIMARY KEY AUTO_INCREMENT,
	`keyword` VARCHAR(60),
	`question_id` INT, FOREIGN KEY (`question_id`) REFERENCES `Question`(`question_id`) ON DELETE CASCADE
);

create table `VotesOn` (
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

INSERT INTO `users` (`username`, `is_admin`) VALUES	
('alpha_admin', TRUE),	-- user ID: 1
('bravo_user', FALSE),	-- user ID: 2
('charlie_dev', TRUE),	-- user ID: 3
('delta_user', FALSE),	-- user ID: 4
('echo_guest', FALSE);	-- user ID: 5
        
INSERT INTO `post` (`post_id`, `date_created`, `text_body`, `user_id`) VALUES
(1, '2026-06-01', 'How do I reverse a list in Python without modifying the original one?', 3), -- question
(2, '2026-06-02', 'How do I crack an egg without breaking the yolk?', 2), -- question
(3, '2026-06-03', 'What are the best practices to extend my laptop battery lifespan over the long term?', 4), -- question
(4, '2026-06-01', 'You can use list slicing like my_list[::-1] or the built-in reversed() function combined with list().', 1), -- answer
(5, '2026-06-02', 'Crack the shell on a flat surface and gently pull it apart with your fingers. Also, be sure you are using fresh eggs. When they get older, the yolks get more fragile. ', 1),
(6, '2026-06-03', 'Try to keep your charge levels between 20% and 80%, and avoid letting it overheat while gaming or rendering.', 1); -- answer
    
INSERT INTO `question` (`question_id`, `title`) VALUES
(1, 'How do I reverse a list in Python?'),
(2, 'How to crack and egg?'),
(3, 'How can I extend my laptop battery lifespan?');
    
INSERT INTO `answer` (`answer_id`, `question_id`) VALUES
(4, 1),
(5, 2),
(6, 3);
    
INSERT INTO `Metadata` (`tag_id`, `keyword`, `question_id`) VALUES
(1, 'python', 1),		-- question (ID:1) have tags 'python' & 'programming'
(2, 'programming', 1),
(3, 'cooking', 2),		-- question (ID:2) have tags 'cooking' & 'recipes'
(4, 'recipes', 2),
(5, 'hardware', 3),		-- question (ID:3) have tags 'hardware' & 'battery'
(6, 'battery', 3);

INSERT INTO `VotesOn` (`user_id`, `post_id`, `vote_type`) VALUES
(3, 4, 1),   -- charlie_dev upvoted alpha_admin's answer on python
(4, 1, 1),   -- delta_user upvoted charlie_dev's python question
(1, 5, 1),   -- alpha_admin upvoted alpha_admin's egg answer
(2, 6, 1);   -- bravo_user upvoted alpha_admin's battery answer

INSERT INTO `Reports` (`user_id`, `post_id`) VALUES
(4, 1);      -- delta_user reported a python question by accident
    
-- delete from post where post_id = 12345;

-- Show tables and data ----------------------------------------------------------------

show tables;
select * from users;
select * from post;
select * from question;
select * from answer;
select * from metadata;