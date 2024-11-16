CREATE TABLE user_submissions (
    id SERIAL PRIMARY KEY,
    user_id BIGINT,
    question_id INT,
    points INT,
    submitted_at timestamp,
    username VARCHAR(50)
);

select * FROM USER_SUBMISSIONS;

-- ANALYSIS NEED TO BE DONE
-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)
-- Q.2 Calculate the daily average points for each user.
-- Q.3 Find the top 3 users with the most positive submissions for each day.
-- Q.4 Find the top 5 users with the highest number of incorrect submissions.
-- Q.5 Find the top 5 users with the highest number of incorrect submissions and points earned.
-- Q.6 Find the top 5 users with the highest number of correct submissions.
-- Q.7 Find the top 5 users with the highest number of correct submissions and correct submissions points.
-- Q.8 Find the top 5 users with the highest points earned.
-- Q.9 Find the top 10 performers for each week.


-- SOLUTIONS

-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)
Select username,
count(id) as total_submissions,
sum(points) as total_points_earned
from user_submissions
group by username
order by total_submissions desc;


-- Q.2 Calculate the daily average points for each user.

select username,avg(points) as average_points_earned, extract(day from submitted_at) As day, extract(month from submitted_at) as month
from user_submissions
group by 1,3
order by username asc
;


-- Q.3 Find the top 3 users with the most correct/positive submissions for each day.

with daily_submissions as(
select extract(day from submitted_at) as day, extract(month from submitted_at) as month,
username,
sum(case 
when  points > 0 then 1 else 0
end) as correct_submissions
  from user_submissions
  group by 1,2,3
  ),
  User_rank 
  as
  (select day, month, username, correct_submissions,
  dense_rank() over (partition by day order by correct_submissions desc) as day_rank
  from daily_submissions)
  select 
  day, month, username, correct_submissions,day_rank
  from user_rank
  where day_rank <=  3;
  
  
-- Q.4 Find the top 5 users with the highest number of incorrect submissions.
  
select
username,
sum(case 
when  points < 0 then 1 else 0
end) as incorrect_submissions
  from user_submissions
  group by 1
  order by incorrect_submissions desc
  limit 5;
  
-- Q.5 Find the top 5 users with the highest number of incorrect submissions and Incorrect points earned.
  
  select
username, 
sum(case 
when  points < 0 then 1 else 0
end) as incorrect_submissions,
sum(case
when points < 0 then points else 0
end ) as incorrect_submission_points
  from user_submissions
  group by 1
  order by incorrect_submissions desc
  limit 5;
  
-- Q.6 Find the top 10 users with the highest number of correct submissions.
  
select
username, 
sum(case 
when  points > 0 then 1 else 0
end) as correct_submissions
  from user_submissions
  group by 1
  order by correct_submissions desc
  limit 10;
  
-- Q.7 Find the top 5 users with the highest number of correct submissions and  correct points earned. 
  select
username, 
sum(case 
when  points > 0 then 1 else 0
end) as correct_submissions,
sum( case
when points > 0 then points else 0
end) as correct_submission_points
  from user_submissions
  group by 1
  order by correct_submissions desc
  limit 5;
  
-- Q.8 Find the top 5 users with the highest points earned.
  
  Select username, sum(points) as points_earned
  from user_submissions
  group by username
  order by points_earned desc
  Limit 5;
  
-- Q.9 Find the top 10 performers for each week.

select * from
(
select extract(week from submitted_at) as week, 
username,
sum(points) as points_earned,
dense_rank() over(partition by extract(week from submitted_at) order by sum(points) desc) as rank_num
  from user_submissions
  group by 2
  order by week, points_earned desc 
  ) as rank_details
  where rank_num <= 10;
  
  
-- end of project
  
  
  

  
 
  
  
  