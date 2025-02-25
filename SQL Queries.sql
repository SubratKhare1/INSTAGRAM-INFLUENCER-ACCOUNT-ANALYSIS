## 1st Question
SELECT DISTINCT post_type
FROM fact_content;

## 2nd Question
SELECT post_type,
	max(impressions) AS highest_recorded_impressions,
	min(impressions) AS lowest_recorded_impressions
FROM fact_content
GROUP BY post_type;

## 3rd Question
SELECT fc.*
FROM fact_content fc
JOIN dim_dates dates ON fc.date = dates.date
WHERE dates.month_name IN ('March', 'April')
AND dates.weekday_or_weekend = 'Weekend';

## 4th Question
SELECT month_name,
   sum(profile_visits) AS total_profile_visits,
   sum(new_followers) AS total_new_followers
   FROM fact_account
   JOIN dim_dates USING (date)
   GROUP BY month_name;
   
   
 ## 5th Question  
WITH CategoryLikes AS ( 
     SELECT post_category,
     sum(likes) AS total_likes
     FROM fact_content
     JOIN dim_dates USING (date)
     WHERE month_name = 'July'
     GROUP BY post_category )
     
SELECT *
FROM CategoryLikes
ORDER BY total_likes DESC;

## 6th Question
SELECT month_name,
	   GROUP_CONCAT(DISTINCT post_category SEPARATOR ' , ') AS post_catrgory_names,
       COUNT(DISTINCT post_category) AS post_catrgory_count
FROM fact_content
JOIN dim_dates USING (date)
GROUP BY month_name
ORDER BY min(date);


## 7th Question
SELECT post_type,
  sum(reach) AS total_reach,
  round(sum(reach) * 100 / ( SELECT sum(reach) FROM fact_content), 2) AS reach_percentage
FROM fact_content
GROUP BY post_type
ORDER BY total_reach DESC;

## 8th Question
SELECT post_category,
   CASE 
	   WHEN month_name IN ('January', 'February', 'March') THEN 'Q1'
	   WHEN month_name IN ('April', 'May', 'June') THEN 'Q2'
	   WHEN month_name IN ('July', 'August', 'September') THEN 'Q3'
   END AS quarter,
   sum(comments) AS total_comments,
   sum(saves) AS total_saves
FROM fact_content
JOIN dim_dates USING (date)
GROUP BY post_category, quarter
ORDER BY quarter;

## 9th Question
WITH TOP_3 AS (
     SELECT month_name, date, new_followers,
           RANK() OVER (PARTITION BY month_name ORDER BY new_followers DESC) AS rank_num
	 FROM fact_account
     JOIN dim_dates USING (date) )
SELECT month_name, date, new_followers
FROM TOP_3
WHERE rank_num <= 3
ORDER BY min(date) OVER (PARTITION BY month_name), rank_num;

## 10th Question
CREATE DEFINER=`root`@`localhost` PROCEDURE `Total_Shares_Each_Post_Type`(IN Week_No varchar(500))
BEGIN
        SELECT post_type,
        sum(shares) AS total_shares
        FROM fact_content fc
        JOIN dim_dates d USING (date)
        WHERE d.Week_No = Week_No
        GROUP BY post_type, Week_No
        ORDER BY total_shares DESC;
END
