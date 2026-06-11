USE NetflixData;

-- Top 10 most common genres

SELECT TOP 10 genre, COUNT(*) AS count
FROM title INNER JOIN genre ON title.id = genre.title_id
GROUP BY genre
ORDER BY count DESC;

-- Top 10 most common countries

SELECT TOP 10 country, COUNT(*) AS count
FROM title
GROUP BY country
ORDER BY count DESC;

-- Distribution of movie minutes
SELECT FLOOR(runtime / 10.0) * 10 AS bucket, COUNT(*) AS count
FROM title
WHERE type = 'Movie' AND runtime IS NOT NULL
GROUP BY FLOOR(runtime / 10.0)
ORDER BY bucket ASC;

-- Summary statistics for TV and movies

SELECT type, 
COUNT(*) as count,
ROUND(AVG(coalesce(CAST(runtime AS FLOAT), CAST(seasons AS FLOAT), 0)), 2) AS average_runtime_or_seasons
FROM title
GROUP BY type
ORDER BY COUNT(*) DESC;

-- Genres and their most common rating

WITH genre_rating AS (
    SELECT genre, rating, COUNT(*) AS rating_count,
           ROW_NUMBER() OVER (PARTITION BY genre ORDER BY COUNT(*) DESC) AS rn
    FROM title
    INNER JOIN genre ON title.id = genre.title_id
    GROUP BY genre, rating
)
SELECT genre, rating
FROM genre_rating
WHERE rn = 1
ORDER BY genre;



