-- 01_data_import.sql
-- Assumes data already loaded using shp2pgsql or ogr2ogr

-- Enable PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_raster;

-- Confirm SRID
SELECT Find_SRID('', 'parcels', 'geom');
SELECT Find_SRID('', 'flood_zones', 'geom');
SELECT ST_SRID(rast) FROM dem LIMIT 1;

-- Create spatial indexes (CRITICAL for performance)
CREATE INDEX parcels_gix ON parcels USING GIST (geom);
CREATE INDEX flood_zones_gix ON flood_zones USING GIST (geom);
CREATE INDEX dem_gix ON dem USING GIST (ST_ConvexHull(rast));

ANALYZE parcels;
ANALYZE flood_zones;
ANALYZE dem;
