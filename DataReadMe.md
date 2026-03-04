# Raw Data Sources

This project uses publicly available geospatial datasets:

1. County Parcel Polygons  
   Source: [Hamilton County GIS Portal]

2. FEMA DFIRM Flood Zones  
   Source: FEMA Flood Map Service Center

3. Digital Elevation Model (DEM)  
   Source: USGS 3DEP 10m DEM

Raw data is not redistributed in this repository due to licensing and file size constraints.

To reproduce the analysis:
- Download datasets from the sources above
- Reproject to EPSG:26917
- Load into PostGIS using ogr2ogr or shp2pgsql
