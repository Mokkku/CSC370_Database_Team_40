-- (SELECT-FROM-WHERE) Queries --

USE reviews;

-- 1. Query: Retrieve all of the text of all of the answers for a specific question. (in this example-> Question 2)
-- Relations: Answer(answer_id, question_id)  Post(post_id, date_created, text_body, user_id)
-- Justification: Allows the user to view all of the responses to a specific question.
SELECT `question_id`, `text_body`
FROM `Post`
JOIN `Answer`
	ON `answer_id` = `post_id`
WHERE `question_id` = 2;

-- 2. Query: Retrieve all answers from the current year related to a specific question. (in this example-> Question 2)
-- Relations: Answer(answer_id, question_id)  Post(post_id, date_created, text_body, user_id)
-- Justification: Allows the user to access potentially more relevant and useful answers than ones from older dates.
SELECT `answer_id`, `text_body`, `date_created`
FROM `Answer`
JOIN `Post`
	ON `Post`.`post_id` = `Answer`.`answer_id`
WHERE `date_created` >= '2026-01-01'
	AND `date_created` < '2027-01-01'
    AND `question_id` = 2
ORDER BY `date_created` DESC;

-- 2. Query: Retrieve all administrative users in the database.
-- Relations: Users(user_id, username, is_admin)
-- Justification: Allows the system to verify staff accounts and manage platform permissions.
SELECT  `user_id`,`username`
FROM `Users`
WHERE `is_admin` = 1; 

-- Grouping and Aggregation Queries --

-- 1. Query: Retrieve the question that has the most answers. 
-- Relations: Answer(answer_id, question_id)  Question(question_id, title)
-- Justification: Allows the user to find the question that is generating the most engagement.
SELECT `title` AS `Question`, COUNT(*) AS `Answers`
FROM `Question`
JOIN `Answer` ON `Answer`.`question_id` = `Question`.`question_id`
GROUP BY `Question`.`question_id`
ORDER BY COUNT(`answer_id`) DESC
Limit 1;

-- 2. Query: Retrieve the keyword that has the most questions related to it.
-- Relations: Metadata(tag_id, keyword)  Describes(tag_id, question_id)
-- Justification: Allows the user to find which topics are the most popular. 
SELECT `keyword`, COUNT(*) AS `Questions`
FROM `Metadata`
JOIN `Describes` ON `Metadata`.`tag_id` = `Describes`.`tag_id`
GROUP BY `Describes`.`tag_id`
ORDER BY COUNT(`question_id`) DESC
Limit 1;

-- 3. Query: Retrieve the total number of votes a post has recieved
-- Relations: VotesOn(post_id, user_id, vote_type)
-- Justification: Allows administrators to track post interactivity. 
SELECT `post_id`, COUNT(*)
FROM `VotesOn`
GROUP BY `VotesOn`.`post_id`;

-- 4. Query: Retrieve the net number of votes a post has recieved
-- Relations: VotesOn(post_id, user_id, vote_type)
-- Justification: Allows the user to see user sentiment towards a post/answer. 
SELECT `post_id`, SUM(`VotesOn`.`vote_type`)
FROM `VotesOn`
GROUP BY `VotesOn`.`post_id`;

-- Subqueries --

-- 1. Query: Retrieve the titles of all Questions related to a specific keyword. (in this example, keyword = cooking)
-- Relations: Question(question_id, title)  Metadata(tag_id, keyword)  Describes(tag_id, question_id)
-- Justification: Allows the user to filter questions by topics to find things related to their interests.
SELECT `title`
FROM `Question`
WHERE `question_id` IN (
	SELECT `question_id`
    FROM `Describes`
    JOIN `Metadata` ON `Metadata`.`tag_id` = `Describes`.`tag_id`
    WHERE `keyword` = 'cooking'
    );
    
-- 2. Query: Retrieve all users who have not made a post in the database.
-- Relations: Users(user_id, username, is_admin)  Post(Post_id, date_created, text_body, user_id)
-- Justification: Allows administrators to track users who are inactive. 
SELECT `user_id`
FROM `Users`
WHERE `user_id` NOT IN (
	SELECT `user_id`
    FROM `Post`
    );

-- 3. Query: Retrieve the users with the most posts.
-- Relations: Users(user_id, username, is_admin)  Post(Post_id, date_created, text_body, user_id)
-- Justification: Allows administrators to see which user has the greatest contribution to the forum.
SELECT *
FROM `Users`
WHERE `Users`.`user_id` = (
	SELECT `Post`.`user_id`
    FROM `Post`
    GROUP BY `user_id`
    ORDER BY COUNT(`post_id`) DESC
    LIMIT 1
);

-- 4. Query: Retrieve the posts with no answers.
-- Relations: Answer(answer_id, post_id),  Post(Post_id, date_created, text_body, user_id)
-- Justification: Allows community members to find unanswered questions and provide assistance.
SELECT `post_id`
FROM `Post`
WHERE `Post`.`post_id` NOT IN (
	SELECT `question_id`
    FROM `Answer`
)
AND `Post`.`post_id` NOT IN (
	SELECT `answer_id`
    FROM `Answer`
)