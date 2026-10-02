-- =============================================================================
-- 01. ELT PIPELINE: STAGING & DATA SANITIZATION
-- =============================================================================

CREATE DATABASE IF NOT EXISTS myanimelist_analytics;
USE myanimelist_analytics;

DROP TABLE IF EXISTS anime_clean;

-- Build sanitized, strongly-typed analytical table
CREATE TABLE anime_clean AS
SELECT 
    TRIM(title) AS title,
    LOWER(TRIM(type)) AS media_type,
    CASE 
        WHEN score NOT IN ('N/A', '', 'tbd') AND score REGEXP '^[0-9]+(\.[0-9]+)?$' 
            THEN CAST(score AS DECIMAL(4,2))
        ELSE NULL 
    END AS score,
    CASE 
        WHEN scored_by REGEXP '^[0-9]+$' THEN CAST(scored_by AS UNSIGNED)
        ELSE 0 
    END AS scored_by,
    CASE 
        WHEN `rank` REGEXP '^[0-9]+$' THEN CAST(`rank` AS UNSIGNED)
        ELSE NULL 
    END AS score_rank,
    CASE 
        WHEN popularity REGEXP '^[0-9]+$' THEN CAST(popularity AS UNSIGNED)
        ELSE NULL 
    END AS popularity_rank,
    LOWER(TRIM(source)) AS source_material,
    LOWER(TRIM(status)) AS airing_status,
    CASE 
        WHEN start_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}' 
            THEN CAST(SUBSTRING(start_date, 1, 10) AS DATE)
        ELSE NULL 
    END AS release_date,
    NULLIF(TRIM(studios), '') AS studio,
    NULLIF(TRIM(broadcast_day), '') AS broadcast_day,
    NULLIF(TRIM(genres), '') AS genres
FROM anime_seasonal
WHERE title IS NOT NULL AND TRIM(title) != '';

-- Performance Indexes
CREATE INDEX idx_studio ON anime_clean(studio);
CREATE INDEX idx_score ON anime_clean(score);
CREATE INDEX idx_popularity_rank ON anime_clean(popularity_rank);
CREATE INDEX idx_source ON anime_clean(source_material);
CREATE INDEX idx_release_date ON anime_clean(release_date);