-- List the top 10 anime with a score above 8.5, but only if they have been scored_by more than 50,000 people.

SELECT 
    title, score, scored_by
FROM
    anime_seasonal
WHERE
    scored_by >= 50000 AND score >= 8.5
ORDER BY scored_by DESC
LIMIT 10;

-- Find all anime where the source is exactly 'Original' and the status is 'Finished Airing'

SELECT 
    title, source, status
FROM
    anime_seasonal
WHERE
    source = 'original'
        AND status = 'finished_airing'
ORDER BY title;

-- List the title, score, and start_date of all 'TV' type anime that started after '2020-01-01' and have a score of 8.0 or higher

SELECT 
    title, score, start_date
FROM
    anime_seasonal
WHERE
    STR_TO_DATE(start_date, '%Y-%m-%d') >= '2020-01-01'
        AND score >= 8.0
        AND type = 'tv'
ORDER BY score DESC;

-- Calculate the average score and the total number of anime for each source (Manga, Light Novel, Original, etc.). Which source material generally results in higher-rated anime?

SELECT 
    COUNT(title), source, AVG(CAST(score AS DECIMAL(4,2))) AS rating
FROM
    anime_seasonal
GROUP BY source
ORDER BY rating DESC;

-- Find the top 5 studios with the highest average score. Only include studios that have at least 5 anime in this dataset to ensure the data is statistically significant.

SELECT 
    studios, AVG(CAST(score AS DECIMAL(4,2))) AS high_avg
FROM
    anime_seasonal
GROUP BY studios
HAVING COUNT(studios) >= 5
ORDER BY high_avg DESC
LIMIT 5;

-- Which broadcast_day has the highest average score?

SELECT 
    broadcast_day, AVG(CAST(score AS DECIMAL(4,2))) AS high_score
FROM
    anime_seasonal
GROUP BY broadcast_day
ORDER BY high_score DESC
LIMIT 1; 

-- Find the top 10 anime where the popularity (the rank of how many people added it to a list) is much better than the actual score rank.

SELECT 
    title, `rank`, popularity
FROM
    anime_seasonal
WHERE
    CAST(popularity AS UNSIGNED) < CAST(`rank` AS UNSIGNED)
ORDER BY `rank` desc
LIMIT 10;

-- Write a query to find anime that have a score above 8.0 but a popularity rank higher than 2000.

SELECT 
    title, score, popularity
FROM
    anime_seasonal
WHERE
    cast(score as decimal(4,2)) > 8.0 AND CAST(popularity AS UNSIGNED) > 2000
ORDER BY score DESC;

-- For each studio, find their MAX(score) and MIN(score). Calculate the "Quality Gap" (Max - Min). Which studio is the most consistent, and which is the most "hit or miss"?

SELECT 
    studios, MAX(CAST(score AS DECIMAL(4,2))) - MIN(CAST(score AS DECIMAL(4,2))) AS quality_gap
FROM
    anime_seasonal
GROUP BY studios
ORDER BY quality_gap DESC;

-- Use the LIKE operator to find how many anime in the genres column contain the word 'Action' vs. 'Romance', and compare their average scored_by counts.

SELECT 
    'Action' AS genre_category, 
    COUNT(*) AS total_anime, 
    ROUND(AVG(CAST(scored_by AS UNSIGNED)), 0) AS avg_popularity
FROM anime_seasonal
WHERE genres LIKE '%Action%'

UNION ALL

SELECT 
    'Romance' AS genre_category, 
    COUNT(*) AS total_anime, 
    ROUND(AVG(CAST(scored_by AS UNSIGNED)), 0) AS avg_popularity
FROM anime_seasonal
WHERE genres LIKE '%Romance%';