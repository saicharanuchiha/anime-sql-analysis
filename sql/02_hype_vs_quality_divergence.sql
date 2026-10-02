-- =============================================================================
-- 02. HYPE VS. QUALITY DIVERGENCE ANALYSIS
-- =============================================================================
USE myanimelist_analytics;

-- 1. Divergence Delta: High Popularity, Low Critical Score (Overhyped Titles)
-- Positive Delta: Popularity rank is significantly ahead of score rank
SELECT 
    title,
    studio,
    score,
    score_rank,
    popularity_rank,
    (CAST(score_rank AS SIGNED) - CAST(popularity_rank AS SIGNED)) AS hype_gap
FROM anime_clean
WHERE score IS NOT NULL 
  AND score_rank IS NOT NULL 
  AND popularity_rank IS NOT NULL
ORDER BY hype_gap DESC
LIMIT 15;

-- 2. Sleeper Hits / Hidden Gems: Elite Quality (Score >= 8.0) but Low Community Reach
SELECT 
    title,
    studio,
    source_material,
    score,
    scored_by,
    popularity_rank
FROM anime_clean
WHERE score >= 8.00 
  AND popularity_rank >= 1500
ORDER BY score DESC, popularity_rank DESC
LIMIT 15;