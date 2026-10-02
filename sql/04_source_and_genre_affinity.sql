-- =============================================================================
-- 04. SOURCE MATERIAL YIELD & GENRE REACH
-- =============================================================================
USE myanimelist_analytics;

-- 1. Source Material Rating Yield & Market Share
SELECT 
    COALESCE(source_material, 'unknown') AS source,
    COUNT(*) AS title_count,
    ROUND(AVG(score), 2) AS avg_rating,
    ROUND(AVG(scored_by), 0) AS avg_community_engagement,
    ROUND(COUNT(*) / (SELECT COUNT(*) FROM anime_clean WHERE score IS NOT NULL) * 100, 1) AS catalog_share_pct
FROM anime_clean
WHERE score IS NOT NULL
GROUP BY source_material
ORDER BY avg_rating DESC;

-- 2. Genre Engagement Benchmark: Action vs. Romance vs. Sci-Fi
SELECT 
    genre_group,
    COUNT(*) AS total_titles,
    ROUND(AVG(score), 2) AS avg_score,
    ROUND(AVG(scored_by), 0) AS avg_audience_reach
FROM (
    SELECT 'Action' AS genre_group, score, scored_by FROM anime_clean WHERE genres LIKE '%Action%'
    UNION ALL
    SELECT 'Romance' AS genre_group, score, scored_by FROM anime_clean WHERE genres LIKE '%Romance%'
    UNION ALL
    SELECT 'Sci-Fi' AS genre_group, score, scored_by FROM anime_clean WHERE genres LIKE '%Sci-Fi%'
    UNION ALL
    SELECT 'Fantasy' AS genre_group, score, scored_by FROM anime_clean WHERE genres LIKE '%Fantasy%'
) AS GenreBuckets
GROUP BY genre_group
ORDER BY avg_audience_reach DESC;