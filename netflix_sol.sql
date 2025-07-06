create database netflix_sql;
use netflix_sql;

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

select count(*) from netflix;
select* from netflix;

-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows
select type,count(type) from netflix group by type;

-- 2. Find the most common rating for movies and TV shows
(select type,rating from netflix where type='movie' group by rating order by count(rating) desc limit 1)
union 
(select type,rating from netflix where type='TV show' group by rating order by count(rating) desc limit 1);


-- 3. List all movies released in a specific year (e.g., 2020)
select title from netflix where release_year=2020 and type='movie';


-- 4. Identify the longest movie
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC limit 1;

-- 5. Find content added in the last 5 years
SELECT * FROM netflix WHERE release_year >= YEAR(CURDATE()) - 5;

-- 6. Find all the movies/TV shows by director 'Robert Cullen'!
SELECT *
FROM netflix
WHERE FIND_IN_SET('Robert Cullen', REPLACE(director, ', ', ',')) > 0;
-- or
SELECT *
FROM netflix
WHERE director like '%Robert Cullen%';

-- 7. List all TV shows with more than 5 seasons
select * from netflix where type='TV show' and CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)>5;


-- 8. List all movies that are documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries%';

-- 9. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL OR director = '';

-- 10. Find how many movies actor 'Luna Wedler' appeared in last 5 years!
select * from netflix where casts like '%Luna Wedler%' and release_year>=YEAR(CURDATE()) - 5;


-- 11. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
-- Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

with cte as (select *,case
when description like '%kill%' or description like '%violence%' then 'bad'
else 'good'
end as keyword from netflix)
select keyword,count(keyword) from cte group by keyword;


-- 12.  Which day of september 2021 had the highest number of new titles (movies + TV shows
-- ) added to Netflix in United States, and how many titles were added in that year?

SELECT date_added,COUNT(*) AS total_titles FROM netflix
WHERE country LIKE '%United States%' AND date_added IS NOT NULL GROUP BY date_added
ORDER BY total_titles DESC LIMIT 1;







