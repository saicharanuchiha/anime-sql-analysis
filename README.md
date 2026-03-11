# 🎌 Anime Market & Trends Analysis (SQL)

## 📌 Project Overview
This project explores the modern anime industry by analyzing a live, dynamically updated dataset of seasonal anime. The goal of this analysis was to uncover trends in studio performance, audience loyalty, genre popularity, and the "Hype vs. Quality" gap among thousands of titles.

This project demonstrates an end-to-end SQL workflow, starting from raw, unformatted data ingestion (ELT) to advanced business logic querying.

## 🛠️ Tools & Techniques
* **Database:** MySQL 8.0
* **Core Skills:** Data Extraction, ELT (Extract, Load, Transform), Staging Tables, Data Type Casting, Conditional Logic, Set Operations (`UNION ALL`).
* **Data Provenance:** Data sourced via automated Python scraping pipelines from MyAnimeList/AniList (Special thanks to [LeoRigasaki/Anime-dataset] for the raw CSV pipeline).

## 🚧 The Data Engineering (ELT) Process
Real-world data is rarely clean. This dataset contained complex Japanese characters, unescaped commas in text fields, and mixed data types. To successfully ingest the 12MB raw CSV, I engineered a robust ELT pipeline:
1. **Bypassed GUI Limitations:** Used raw `LOAD DATA INFILE` scripts to force-load data directly to the database engine.
2. **Staging Tables:** Imported raw data entirely as `VARCHAR` text columns to prevent integer-crashing on values like "Unknown" or numbers formatted with commas (e.g., "1,248").
3. **Dynamic Casting:** Utilized `CAST(... AS UNSIGNED)` and `CAST(... AS DECIMAL)` during the querying phase to transform text back into mathematically viable numbers for analysis.

## 📊 Key Business Insights Explored
This repository contains 10 advanced SQL queries designed to answer specific industry questions, including:
* **The "Hype vs. Quality" Gap:** Identifying shows with massive popularity but comparatively low critical scores (and vice-versa).
* **Studio Consistency Metrics:** Calculating the quality gap (Max Score - Min Score) for major animation studios to find the most consistent producers.
* **Source Material ROI:** Analyzing whether Original concepts, Manga, or Light Novels yield the highest average audience scores.
* **Genre Dominance:** Using keyword matching and set operations (`UNION ALL`) to compare the sheer audience size of Action versus Romance genres.

## 💻 Sample Code Highlight
*Identifying undervalued "Hidden Gems" (High Score, Low Popularity) using type-casting on text-staged data:*
```sql
SELECT 
    title, 
    score, 
    popularity
FROM anime_seasonal
WHERE CAST(score AS DECIMAL(4,2)) > 8.0 
  AND CAST(popularity AS UNSIGNED) > 2000
ORDER BY score DESC;
