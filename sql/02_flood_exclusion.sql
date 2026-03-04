-- 02_flood_exclusion.sql

-- Step 1: Identify Special Flood Hazard Areas (SFHA)
-- AE = Base Flood Elevation determined
-- AO = Shallow flooding (sheet flow)
-- A  = Base floodplain, no BFE determined

CREATE TABLE flood_sfha AS
SELECT *
FROM flood_zones
WHERE zone IN ('AE', 'AO', 'A');

CREATE INDEX flood_sfha_gix ON flood_sfha USING GIST (geom);

-- Step 2: Remove parcels intersecting SFHA

CREATE TABLE parcels_no_flood AS
SELECT p.*
FROM parcels p
LEFT JOIN flood_sfha f
ON ST_Intersects(p.geom, f.geom)
WHERE f.geom IS NULL;

CREATE INDEX parcels_no_flood_gix ON parcels_no_flood USING GIST (geom);
