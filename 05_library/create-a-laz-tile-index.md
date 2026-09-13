## Create a .laz Tile Index

`--fast_boundary` tells PDAL to use a faster method for determining the boundary rather than scanning the entire point cloud. For standard LAZ tiles, the file's spatial bounds are usually sufficient. 

This is useful in **QGIS**, for example, because you can load the GeoJSON and visually see where all your LAZ tiles are.

```bash
pdal tindex create --tindex laz_border.geojson --filespec "*.laz" -f "GeoJSON" --fast_boundary
```
