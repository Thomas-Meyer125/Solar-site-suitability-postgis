-- 04_zonal_statistics.sql

ALTER TABLE parcels_no_flood
ADD COLUMN area_m2 DOUBLE PRECISION;

UPDATE parcels_no_flood
SET area_m2 = ST_Area(geom);

-- Calculate mean slope within each parcel

CREATE TABLE parcel_slope_stats AS
SELECT
    p.gid,
    p.geom,
    p.area_m2,
    (ST_SummaryStats(
        ST_Clip(s.rast, p.geom)
    )).mean AS mean_slope
FROM parcels_no_flood p
JOIN dem_slope s
ON ST_Intersects(p.geom, ST_ConvexHull(s.rast));

CREATE INDEX parcel_slope_stats_gix 
ON parcel_slope_stats 
USING GIST (geom);
