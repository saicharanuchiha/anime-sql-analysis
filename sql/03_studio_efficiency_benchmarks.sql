-- =============================================================================
-- 03. STUDIO BENCHMARKS & VOLATILITY AUDIT
-- =============================================================================
USE myanimelist_analytics;

WITH StudioMetrics AS (
    SELECT 
        studio,
        COUNT(*) AS total_productions,
        ROUND(AVG(score), 2) AS avg_score,
        MAX(score) AS max_score,
        MIN(score) AS min_score,
        ROUND(MAX(score) - MIN(score), 2) AS quality_gap,
        ROUND(AVG(scored_by), 0) AS avg_engagement_per_title,
        SUM(CASE WHEN score >= 8.0 THEN 1 ELSE 0 END) AS elite_tier_count
    FROM anime_clean
    WHERE studio IS NOT NULL AND score IS NOT NULL
    GROUP BY studio
    HAVING COUNT(*) >= 5
)
SELECT 
    studio,
    total_productions,
    avg_score,
    min_score,
    max_score,
    quality_gap,
    elite_tier_count,
    ROUND((elite_tier_count / total_productions) * 100, 1) AS elite_hit_rate_pct
FROM StudioMetrics
ORDER BY avg_score DESC;