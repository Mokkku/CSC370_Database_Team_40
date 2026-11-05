-- Non-persistence for database -------------------------------------

DROP DATABASE IF EXISTS reviews;
create database Reviews;
use reviews;
---------------------------------------------------------------------




-- Create tables for db ------------------------------------------------

create table `Users`(
    `user_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `username` VARCHAR(50) UNIQUE NOT NULL,
    `is_admin` BOOLEAN
);
    
CREATE TABLE `Post` (
	`post_id` INT PRIMARY KEY NOT NULL,
	`date_created` DATE,
	`text_body` VARCHAR(5000),
	`user_id` INT,
    FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
);
    
CREATE TABLE `Question` (
	`question_id` INT PRIMARY KEY NOT NULL,
	`title` VARCHAR(120) NOT NULL,
	FOREIGN KEY (`question_id`) REFERENCES `Post` (`post_id`) ON DELETE CASCADE
);
    
CREATE TABLE `Answer` (
	`answer_id` INT PRIMARY KEY NOT NULL,
	`question_id` int,
	FOREIGN KEY (`answer_id`) REFERENCES `Post` (`post_id`) ON DELETE CASCADE,
    FOREIGN KEY (`question_id`) REFERENCES `Question` (`question_id`) ON DELETE CASCADE
);
    
CREATE TABLE `Metadata` (
	`tag_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	`keyword` VARCHAR(60) NOT NULL UNIQUE
);

create table `VotesOn` (
	`user_id` INT,
	`post_id` INT,
	`vote_type` TINYINT NOT NULL CHECK (`vote_type` IN (1, -1)),
	PRIMARY KEY (`user_id`, `post_id`),
	FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE,
	FOREIGN KEY (`post_id`) REFERENCES `Post`(`post_id`) ON DELETE CASCADE
);

CREATE TABLE `Reports` (
	`user_id` INT,
	`post_id` INT,
	PRIMARY KEY(`user_id`, `post_id`),
	FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE,
    FOREIGN KEY (`post_id`) REFERENCES `Post`(`post_id`) ON DELETE CASCADE
);

CREATE TABLE `Describes` (
	`tag_id` INT,
    `question_id` INT,
    PRIMARY KEY (`tag_id`, `question_id`),
    FOREIGN KEY (`tag_id`) REFERENCES `Metadata`(`tag_id`) ON DELETE CASCADE,
    FOREIGN KEY (`question_id`) REFERENCES `Question`(`question_id`) ON DELETE CASCADE
);

-- ------------------------------------------------------------------




-- Generate dummy entries ----------------------------------------------------------------

INSERT INTO `users` (`username`, `is_admin`) VALUES	
('alpha_admin', TRUE),	-- user ID: 1
('bravo_user', FALSE),	-- user ID: 2
('charlie_dev', TRUE),	-- user ID: 3
('delta_user', FALSE),	-- user ID: 4
('echo_guest', FALSE),	-- user ID: 5
('foxtrot_guest', FALSE); -- User ID: 6
        
INSERT INTO `post` (`post_id`, `date_created`, `text_body`, `user_id`) VALUES
(1, '2026-06-01', 'How do I reverse a list in Python without modifying the original one?', 3), -- question
(2, '2026-06-02', 'How do I crack an egg without breaking the yolk?', 2), -- question
(3, '2026-06-03', 'What are the best practices to extend my laptop battery lifespan over the long term?', 4), -- question
(4, '2026-06-01', 'You can use list slicing like my_list[::-1] or the built-in reversed() function combined with list().', 1), -- answer
(5, '2026-06-02', 'Crack the shell on a flat surface and gently pull it apart with your fingers. Also, be sure you are using fresh eggs. When they get older, the yolks get more fragile. ', 1),
(6, '2026-06-03', 'Try to keep your charge levels between 20% and 80%, and avoid letting it overheat while gaming or rendering.', 1), -- answer
(7, '2026-06-04', 'Crack the shell on the side of a bowl with medium force. If not enough force is applied, the egg may not open easily. If too much force is applied, the egg shells may end up mixed into the yolk.', 5), -- answer
(8, '2026-06-05', 'How do I prevent water from boiling over?', 5), -- question
(9, '2026-06-06', 'How do I play Magic: The Gathering?', 5); -- question

INSERT INTO `question` (`question_id`, `title`) VALUES
(1, 'How do I reverse a list in Python?'),
(2, 'How to crack and egg?'),
(3, 'How can I extend my laptop battery lifespan?'),
(8, 'How do I prevent water from boiling over?'),
(9, 'How do I play Magic: The Gathering?');
    
INSERT INTO `answer` (`answer_id`, `question_id`) VALUES
(4, 1), 
(5, 2),
(6, 3),
(7, 2);
    
INSERT INTO `Metadata` (`tag_id`, `keyword`) VALUES
(1, 'python'),		-- question (ID:1) have tags 'python' & 'programming'
(2, 'programming'),
(3, 'cooking'),		-- question (ID:2) have tags 'cooking' & 'recipes'
(4, 'recipes'),
(5, 'hardware'),		-- question (ID:3) have tags 'hardware' & 'battery'
(6, 'battery');

INSERT INTO `Describes` (`tag_id`, `question_id`) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3),
(3, 8);

INSERT INTO `VotesOn` (`user_id`, `post_id`, `vote_type`) VALUES
(3, 4, 1),   -- charlie_dev upvoted alpha_admin's answer on python
(4, 1, 1),   -- delta_user upvoted charlie_dev's python question
(1, 5, 1),   -- alpha_admin upvoted alpha_admin's egg answer
(4, 5, -1),   -- delta_user downvoted alpha_admin's egg answer
(2, 5, -1),   -- bravo_user downvoted alpha_admin's egg answer
(2, 6, 1),   -- bravo_user upvoted alpha_admin's battery answer
(1, 6, 1),   -- alpha_admin upvoted alpha_admin's battery answer
(3, 6, 1);   -- charlie_dev upvoted alpha_admin's battery answer

INSERT INTO `Reports` (`user_id`, `post_id`) VALUES
(2, 1);      -- delta_user reported a python question by accident
    
-- INSERT INTO `Users` (`username`, `is_admin`) VALUES
-- ('NOT_UNIQUE', true)	-- Fails the UNIQUE constraint on 'username'
-- ;

-- INSERT INTO `Users` (`username`, `is_admin`) VALUES
-- ('NOT_UNIQUE', true)	-- Fails the UNIQUE constraint on 'username'
-- ;

-- INSERT INTO `question` (`question_id`, `title`) VALUES
-- (1, Null)	-- Fails the NOT NULL constraint on 'title'
-- ;

-- Show tables and data ----------------------------------------------------------------

show tables;
select * from users;
select * from post;
select * from question;
select * from answer;
select * from metadata;
select * from describes;