-- (SELECT-FROM-WHERE) Queries --

-- 1. Retrieve all of the text of all of the answers for a specific question. (in this example-> from Question 2)
-- Relations: Answer(answer_id, question_id)  Post(post_id, date_created, text_body, user_id)
SELECT `question_id`, `text_body`
FROM `Post`
JOIN `Answer`
	ON `answer_id` = `post_id`
WHERE `question_id` = 2;


-- Grouping and Aggregation Queries --

-- 1. Retrieve the question that has the most answers. (i.e. the Question generating the most traffic)
-- Relations: Answer(answer_id, question_id)  Question(question_id, title)
SELECT `title` AS `Question`, COUNT(*) AS `Answers`
FROM `Question`
JOIN `Answer` ON `Answer`.`question_id` = `Question`.`question_id`
GROUP BY `Question`.`question_id`
ORDER BY COUNT(`answer_id`) DESC
Limit 1;


-- Subqueries --

-- 1. Retrieve the titles of all Questions related to a specific keyword. (in this example, keyword = cooking)
SELECT `title`
FROM `Question`
WHERE `question_id` IN (
	SELECT `question_id`
    FROM `Describes`
    JOIN `Metadata` ON `Metadata`.`tag_id` = `Describes`.`tag_id`
    WHERE `keyword` = 'cooking'
    );