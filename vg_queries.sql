-- Retrieves all the columns and records from the "video_games" table
SELECT *
FROM video_games;

-- What are the top-selling games of all time?
SELECT
	name,
	SUM(global_sales) AS total_sales
FROM video_games
GROUP BY name
ORDER BY total_sales DESC
LIMIT 10;

-- Which are the top 10 gaming platforms based on the number of games released?
SELECT
    platform,
    num_games,
    rank_no
FROM (
    SELECT
        platform,
        COUNT(*) AS num_games,
        DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS rank_no
    FROM video_games    
    GROUP BY platform) AS subquery
WHERE rank_no <= 10 
ORDER BY num_games DESC;

-- What is the percentage distribution of game genres in the video games dataset, ranked by the highest percentage?
WITH genre_pct AS (
	SELECT
		genre,
		COUNT(*) * 100 / (SELECT COUNT(*) FROM video_games) AS percentage_genre
	FROM video_games
	GROUP BY genre)
	
SELECT
	genre,
	percentage_genre,
	DENSE_RANK() OVER(ORDER BY percentage_genre DESC)
FROM genre_pct
ORDER BY percentage_genre DESC;

-- What is the count of games per publisher and year, ordered by the number of games in descending order?
SELECT
	publisher,
	year,
	COUNT(*) AS num_games
FROM video_games
GROUP BY publisher, year
ORDER BY num_games DESC;

/*
-- What is the cumulative count of games per publisher, ordered by year and the number of games in descending order,
for games released after 2010?
*/

SELECT
	publisher,
	year,
	SUM(COUNT(*)) OVER(PARTITION BY publisher ORDER BY year) as num_games
FROM video_games
WHERE year > 2010
GROUP BY publisher,year
ORDER BY year, num_games DESC;

-- What is the overall distribution of game ratings?
SELECT
	rating,
	COUNT(*) num_rating
FROM video_games
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY num_rating DESC;

-- How do sales vary across different publishers (NA, EU, JP, Other)?
SELECT
	genre, 
	SUM(na_sales) AS total_na_sales,
	SUM(eu_sales) AS total_eu_sales,
	SUM(jp_sales) AS total_jp_sales,
	SUM(global_sales) AS total_global_sales
FROM video_games
GROUP BY genre
ORDER BY genre;

-- What is the relationship between critic scores and user scores?
SELECT
    ROUND(AVG(critic_score),2) AS Average_critic_score,
    ROUND(AVG(user_score),2) AS Average_user_score,
    ROUND(CAST(CORR(critic_score, user_score) AS numeric), 3) AS correlation
FROM video_games   
WHERE
    critic_score IS NOT NULL
    AND user_score IS NOT NULL;


-- What is the cumulative sales trend over the years for global sales in the video games?
WITH sales AS (
	SELECT
		year,
		SUM(global_sales) as global_sales
	FROM video_games
	WHERE year IS NOT NULL
	GROUP BY year)

SELECT
	year,
	SUM(global_sales) OVER(ORDER BY year
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS global_sales_rt
FROM sales

-- Are there any correlations between user scores and sales?

SELECT
    
    ROUND(AVG(user_score),2) AS average_user_score,
	ROUND(AVG(global_sales),2) AS average_global_sales,
    ROUND(CAST(CORR(user_score, global_sales) AS numeric), 3) AS correlation
FROM
    video_games
WHERE
    critic_score IS NOT NULL
    AND user_score IS NOT NULL;
	
-- Which video games have the highest user scores considering the top 10 highest critic scores?

WITH games AS (
	SELECT *
	FROM video_games
	WHERE critic_score IS NOT NULL
	 AND user_score IS NOT NULL)

SELECT
	name,
	platform,
	year,
	genre,
	publisher,
	global_sales,
	critic_score,
	user_score
FROM games
WHERE critic_score IN (SELECT critic_score FROM games ORDER BY critic_score DESC LIMIT 10)
ORDER BY user_score DESC
LIMIT 10;
