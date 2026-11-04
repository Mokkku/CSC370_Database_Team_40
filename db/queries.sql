-- (SELECT-FROM-WHERE) Queries --

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