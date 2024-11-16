# SQL Mentor User Performance Analysis 


## Project Overview

This project is designed to help beginners understand SQL querying and performance analysis using real-time data from SQL Mentor datasets. In this project, you will analyze user performance by creating and querying a table of user submissions. The goal is to solve a series of SQL problems to extract meaningful insights from user data.

## Objectives

- Learn how to use SQL for data analysis tasks such as aggregation, filtering, and ranking.
- Understand how to calculate and manipulate data in a real-world dataset.
- Gain hands-on experience with SQL functions like `COUNT`, `SUM`, `AVG`, `EXTRACT()`, and `DENSE_RANK()`.
- Develop skills for performance analysis using SQL by solving different types of data problems related to user performance.

## Project Level: Beginner

This project is designed for beginners who are familiar with the basics of SQL and want to learn how to handle real-world data analysis problems. You'll be working with a small dataset and writing SQL queries to solve different tasks that are commonly encountered in data analytics.

## SQL Mentor User Performance Dataset

The dataset consists of information about user submissions for an online learning platform. Each submission includes:
- **User ID**
- **Question ID**
- **Points Earned**
- **Submission Timestamp**
- **Username**

This data allows you to analyze user performance in terms of correct and incorrect submissions, total points earned, and daily/weekly activity.

## SQL Problems and Questions

Here are the SQL problems that you will solve as part of this project:

### Q1. List All Distinct Users and Their Stats
- **Description**: Return the user name, total submissions, and total points earned by each user.
- **Expected Output**: A list of users with their submission count and total points.

### Q2. Calculate the Daily Average Points for Each User
- **Description**: For each day, calculate the average points earned by each user.
- **Expected Output**: A report showing the average points per user for each day.

### Q3. Find the Top 3 Users with the Most Correct Submissions for Each Day
- **Description**: Identify the top 3 users with the most correct submissions for each day.
- **Expected Output**: A list of users and their correct submissions, ranked daily.

### Q4. Find the Top 5 Users with the Highest Number of Incorrect Submissions
- **Description**: Identify the top 5 users with the highest number of incorrect submissions.
- **Expected Output**: A list of users with the count of incorrect submissions.

### Q5. Find the Top 10 Performers for Each Week
- **Description**: Identify the top 10 users with the highest total points earned each week.
- **Expected Output**: A report showing the top 10 users ranked by total points per week.

## Key SQL Concepts Covered

- **Aggregation**: Using `COUNT`, `SUM`, `AVG` to aggregate data.
- **Date Functions**: Using `EXTRACT()` and `TO_CHAR()` for manipulating dates.
- **Conditional Aggregation**: Using `CASE WHEN` to handle positive and negative submissions.
- **Ranking**: Using `DENSE_RANK()` to rank users based on their performance.
- **Group By**: Aggregating results by groups (e.g., by user, by day, by week).

## SQL Queries Solutions

Below are the solutions for each question in this project:

### Q1: List All Distinct Users and Their Stats
```sql
Select username,
count(id) as total_submissions,
sum(points) as total_points_earned
from user_submissions
group by username
order by total_submissions desc;
```

### Q2: Calculate the Daily Average Points for Each User
```sql
select username,avg(points) as average_points_earned, extract(day from submitted_at) As day, extract(month from submitted_at) as month
from user_submissions
group by 1,3
order by username asc
;
```

### Q3: Find the Top 3 Users with the Most Correct Submissions for Each Day
```sql
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
```

### Q4: Find the Top 5 Users with the Highest Number of Incorrect Submissions
```sql
select
username,
sum(case 
when  points < 0 then 1 else 0
end) as incorrect_submissions
  from user_submissions
  group by 1
  order by incorrect_submissions desc
  limit 5;
```
## Q.5: Find the top 5 users with the highest number of incorrect submissions and Incorrect points earned.
 ```sql 
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
```
## Q.6: Find the top 10 users with the highest number of correct submissions.
```sql  
select
username, 
sum(case 
when  points > 0 then 1 else 0
end) as correct_submissions
  from user_submissions
  group by 1
  order by correct_submissions desc
  limit 10;
```
## Q.7: Find the top 5 users with the highest number of correct submissions and  correct points earned. 
 ```sql 
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
```
 ## Q.8: Find the top 5 users with the highest points earned.
  ```sql
  Select username, sum(points) as points_earned
  from user_submissions
  group by username
  order by points_earned desc
  Limit 5;
   ```
### Q9: Find the Top 10 Performers for Each Week
```sql
SELECT *  
FROM (
    SELECT 
        EXTRACT(WEEK FROM submitted_at) AS week_no,
        username,
        SUM(points) AS total_points_earned,
        DENSE_RANK() OVER(PARTITION BY EXTRACT(WEEK FROM submitted_at) ORDER BY SUM(points) DESC) AS rank
    FROM user_submissions
    GROUP BY 1, 2
    ORDER BY week_no, total_points_earned DESC
)
WHERE rank <= 10;
```

## Conclusion

This project provides an excellent opportunity for beginners to apply their SQL knowledge to solve practical data problems. By working through these SQL queries, you'll gain hands-on experience with data aggregation, ranking, date manipulation, and conditional logic.
