-- 05_suitability_scoring.sql

-- Step 1: Apply constraints

ALTER TABLE suitable_parcels
ADD COLUMN suitability_score DOUBLE PRECISION;

CREATE TABLE suitable_parcels AS
SELECT *
FROM parcel_slope_stats
WHERE area_m2 >= 20000
AND mean_slope <= 5;

-- Step 2: Normalize area and slope

WITH stats AS (
    SELECT
        MIN(area_m2) AS min_area,
        MAX(area_m2) AS max_area,
        MIN(mean_slope) AS min_slope,
        MAX(mean_slope) AS max_slope
    FROM suitable_parcels
)

UPDATE suitable_parcels sp
SET
    suitability_score =
        0.7 * ((sp.area_m2 - stats.min_area) /
               NULLIF(stats.max_area - stats.min_area,0))
      +
        0.3 * (1 - ((sp.mean_slope - stats.min_slope) /
               NULLIF(stats.max_slope - stats.min_slope,0)))
FROM stats;

-- Step 3: Rank parcels

ALTER TABLE suitable_parcels
ADD COLUMN parcel_rank INTEGER;

UPDATE suitable_parcels
SET parcel_rank = sub.rank
FROM (
    SELECT gid,
           RANK() OVER (ORDER BY suitability_score DESC) AS rank
    FROM suitable_parcels
) sub
WHERE suitable_parcels.gid = sub.gid;
