-- (SELECT-FROM-WHERE) Queries --

USE reviews;

-- 1. Query: Retrieve all of the text of all of the answers for a specific question. (in this example-> Question 2)
-- Relations: Answer(answer_id, question_id),  Post(post_id, date_created, text_body, user_id)
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

-- 3. Query: Retrieve all administrative users in the database.
-- Relations: Users(user_id, username, is_admin)
-- Justification: Allows the system to verify staff accounts and manage platform permissions.
SELECT  `user_id`,`username`
FROM `Users`
WHERE `is_admin` = 1; 

-- 4. Query: Retrieve a list of all posts made by a specific user including the title and date created of the posts.
-- Relations: Users(user_id, username, is_admin)  Question(question_id, title)  Post(post_id, date_created, text_body, user_id)
-- Justification: Allows the user to view all of the posts curated by one user as one informative list. 

SELECT `username` AS `Username`, `title` AS `Title`, `date_created` AS `Date`
FROM `Post`
JOIN `Question` 
	ON `Question`.`question_id` = `Post`.`post_id`
JOIN `Users`
	ON `Users`.`user_id` = `Post`.`user_id`
WHERE `username` = 'echo_guest';

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

-- 4. Query: Retrieve the net score of votes and total votes that a post has recieved.
-- Relations: VotesOn(post_id, user_id, vote_type)
-- Justification: Allows the user to see user sentiment towards a post/answer. 
SELECT `post_id`, SUM(`VotesOn`.`vote_type`) AS `Net Score`, COUNT(*) AS `Total Votes`
FROM `VotesOn`
GROUP BY `VotesOn`.`post_id`;

-- 5. Query: Retrieve all of the Posts created this year that have negative overall feedback (i.e. more downvotes than upvotes).
-- Relations: VotesOn(post_id, user_id, vote_type)  Post(post_id, date_created, text_body, user_id)
-- Justification: Allows administrators to monitor posts that have receieved negative community feedback to learn more about user sentiment. 
SELECT `text_body`, `Post`.`post_id`, SUM(`vote_type`) AS `Net Score`
FROM `Post`
JOIN `VotesOn`
	ON `Post`.`post_id` = `VotesOn`.`post_id`
WHERE `date_created` >= '2026-01-01'
	AND `date_created` < '2027-01-01'
GROUP BY `Post`.`post_id`
HAVING SUM(`vote_type`) < 0;

-- 6. Query: Retrieve all the questions and show how many Answers each question has received, including Questions with no answers.
-- Relations: Question(question_id, title), Answer(answer_id, question_id)
-- Justification: Allows users to find questions that have no answers and contribute to them.
SELECT `title`, COUNT(`Answer`.`answer_id`) AS `Total Answers`
FROM `Question`
LEFT OUTER JOIN `Answer`
	ON `Question`.`question_id` = `Answer`.`question_id`
GROUP BY `Question`.`question_id`;

-- Subqueries --

-- 1. Query: Retrieve the titles of all Questions related to a specific keyword. (in this example, keyword = cooking)
-- Relations: Question(question_id, title),  Metadata(tag_id, keyword)  Describes(tag_id, question_id)
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
-- Justification: Allows administrators to better understand user participation. 
SELECT `user_id`, `username`
FROM `Users`
WHERE `user_id` NOT IN (
	SELECT `user_id`
    FROM `Post`
    );

-- 3. Query: Retrieve one of the users with the greatest total number of posts (breaks ties by choosing a user with the lowest user ID number)
-- Relations: Users(user_id, username, is_admin)  Post(Post_id, date_created, text_body, user_id)
-- Justification: Allows administrators to filter by one of the users that have the greatest contributions to the forum.
SELECT `Users`.`user_id`, `username`, `is_admin`, COUNT(*) AS `Total Posts`
FROM `Users`
JOIN `Post`
	ON `Users`.`user_id` = `Post`.`user_id`
WHERE `Users`.`user_id` = (
	SELECT `Post`.`user_id`
    FROM `Post`
    GROUP BY `user_id`
    ORDER BY COUNT(`post_id`) DESC, `user_id` ASC
    LIMIT 1
)
GROUP BY `Users`.`user_id`, `username`, `is_admin`;

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
);

-- 5. Query: Retrieve questions that have at least one answer with a positive net score (more positive ratings than negative).
-- Relations: VotesOn(post_id, user_id, vote_type), Answer(answer_id, question_id), Question(question_id, title) 
-- Justification: Helps to highlight questions that have positively rated Answers from the community.
SELECT `title`, `question_id`
FROM `Question`
WHERE EXISTS(
	SELECT `answer_id`
	FROM `Answer`
    JOIN `VotesOn`
		ON `Answer`.`answer_id` = `VotesOn`.`post_id`
	WHERE `Answer`.`question_id` = `Question`.`question_id`
    GROUP BY `Answer`.`answer_id`
    HAVING SUM(`vote_type`) > 0
    );

