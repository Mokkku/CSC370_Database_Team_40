-- Non-persistebce for database
DROP DATABASE IF EXISTS reviews;
create database Reviews;
use reviews;
--

-- Create tables for db
create table user(
	name varchar(120));
    
create table question(
	question_id int(100));
    
create table answer(
	answer_id int(100));
    
show tables;