## Step 9c: Merging the Individual Raster Tiles

### Overview

As mentioned earlier in the tutorial, it is **safer to merge the point clouds first** and create a raster from the single, merged point cloud.  However, this is not always possible when working with very dense point clouds or projects covering a large area.

***

### Instructions

<br>

- For merging **elevation data / heightmap** raster tiles, the following settings are **recommended defaults** for this workflow and should not normally need to be changed.

#### Native Execution

```bash
#!/bin/bash
gdalbuildvrt \
    "02_data/09b_heightmap_raster/heightmap_MERGED.vrt" \
    "02_data/09b_heightmap_raster/"*.tif

gdal_translate \
    -ot Float32 \
    -co COMPRESS=DEFLATE \
    -co PREDICTOR=3 \
    -co TILED=YES \
    -co BIGTIFF=IF_NEEDED \
    "02_data/09b_heightmap_raster/heightmap_MERGED.vrt" \
    "02_data/09b_heightmap_raster/heightmap_MERGED.tif"

rm "02_data/09b_heightmap_raster/heightmap_MERGED.vrt"

echo "Finished: heightmap_MERGED.tif"

```

#### Docker Execution

```bash
./run_pipeline.sh 09c_heightmap_merge_tif.sh
```

***

## Previous Step

[**Step 9b: Creating the Heightmap Raster**](09b-creating-the-heightmap.md)  ←

## Next Step

[**Step 10: Finalizing the Heightmap**](10-finalizing-heightmap.md) →

***
