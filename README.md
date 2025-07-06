# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Schema

```sql
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
```

## Business Problems and Solutions

### 1.Count the number of Movies vs TV Shows


```sql
select type,count(type) from netflix group by type;
```

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
(
select type,rating from netflix where type='movie'
group by rating order by count(rating) desc limit 1
)
union 
(
select type,rating from netflix where type='TV show'
 group by rating order by count(rating) desc limit 1
);
```


### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select title from netflix where release_year=2020 and type='movie';
```


### 4. Find the movie with the longest duration

```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC limit 1;

```



### 5. Find Content Added in the Last 5 Years

```sql
SELECT * FROM netflix WHERE release_year >= YEAR(CURDATE()) - 5;
```

### 6. Find All Movies/TV Shows by Director 'Robert Cullen'

```sql
SELECT *
FROM netflix
WHERE FIND_IN_SET('Robert Cullen', REPLACE(director, ', ', ',')) > 0;
-- or
SELECT *
FROM netflix
WHERE director like '%Robert Cullen%';
```

### 7. List All TV Shows with More Than 5 Seasons

```sql
select * from netflix where type='TV show'
and CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)>5;
```


### 8. List All Movies that are Documentaries

```sql
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
```


### 9. Find All Content Without a Director

```sql
SELECT *
FROM netflix
WHERE director IS NULL OR director = '';
```
### 10. Find How Many Movies Actor 'Luna Wedler' Appeared in the Last 5 Years

```sql
select * from netflix where casts like '%Luna Wedler%'
and release_year>=YEAR(CURDATE()) - 5;
```


### 11. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

```sql
with cte as (select *,case
when description like '%kill%' or description like '%violence%' then 'bad'
else 'good'
end as keyword from netflix)
select keyword,count(keyword) from cte group by keyword;
```
### 12. which day of september 2021 had the highest number of new titles (movies + TV shows) added to Netflix in United States, and how many titles were added in that year?

```sql
SELECT date_added,COUNT(*) AS total_titles FROM netflix
WHERE country LIKE '%United States%' AND date_added IS NOT NULL
GROUP BY date_added ORDER BY total_titles DESC LIMIT 1;

```


## Findings and Conclusion

- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.


