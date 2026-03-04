-- 03_slope_analysis.sql

-- Create slope raster in degrees
CREATE TABLE dem_slope AS
SELECT
    ST_Slope(rast, 1, '32BF', 'DEGREES') AS rast
FROM dem;

CREATE INDEX dem_slope_gix 
ON dem_slope 
USING GIST (ST_ConvexHull(rast));
