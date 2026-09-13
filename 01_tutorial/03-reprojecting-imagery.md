## Step 3: Reprojecting Imagery 

### Overview

- This tutorial is more focused on the end result rather than explaining some of the more technical Geographic Information System (GIS) concepts, such as the **Coordinate Reference System** (CRS). For these topics, I will point to other [**resources**](https://earthdatascience.org/courses/earth-analytics/spatial-data-r/intro-to-coordinate-reference-systems/).

- The main thing to make sure of is that the **imagery** and **point cloud** use the **same EPSG code** so they line up correctly during the colorization process.
  
- The two photos in **Example A may look identical before** and **after** reprojecting because **EPSG:2229** and **EPSG:6424** use the same California State Plane zone and the same units of measurement. However, the imagery's geographic reference has changed.
  
- *In order to visually show what reprojection does*, the imagery in **Example B** was downloaded in **EPSG:26910** and then reprojected into **EPSG:6424**.

>[!NOTE]
>The script works with either a single imagery tile or multiple individual tiles downloaded from QGIS.

<table>
  <tr>
    <th colspan="2">Example A</th>
  </tr>
  <tr>
    <td align="center">
      <img src="../06_photos/03c_before_reprojection.webp" 
      alt="Before reprojection"
      width="80%">
      <br>
      <strong>Before Reprojection</strong><br>
      EPSG:2229
    </td>
    <td align="center">
      <img src="../06_photos/03d_after_reprojection.webp" 
      alt="After reprojection"
      width="80%">
      <br>
      <strong>After Reprojection</strong><br>
      EPSG:6424
    </td>
  </tr>
</table>

<table>
  <tr>
    <th colspan="2">Example B</th>
  </tr>
  <tr>
    <td align="center">
      <img src="../06_photos/03a_before_reprojection.webp" 
      alt="Visual representation only - before reprojection"
      width="80%">
      <br>
      <strong>Before Reprojection</strong><br>
      EPSG:26910
    </td>
    <td align="center">
      <img src="../06_photos/03b_after_reprojection.webp" 
      alt="Visual representation only - after reprojection"
      width="80%">
      <br>
      <strong>After Reprojection</strong><br>
      EPSG:6424
    </td>
  </tr>
</table>

<div align="center">
  <img src="../06_photos/03e_gdalinfo.webp" 
  alt="GDAL info terminal output"
  style="max-width: 60%; height: auto;">
</div>

>[!NOTE]
>**`gdalinfo` is essentially the GDAL equivalent of `pdal info`, but for raster data.** It can be used to inspect information about a raster file, including its CRS, dimensions, resolution, bands, and other metadata.

#### GDAL Info Native Execution 

```bash
gdalinfo 02_data/01_download/2022_4BandImagery_California_J1425462tR0_C0.tif
```

#### GDAL Info Docker Execution

```bash
docker run --rm \
   --user "$(id -u):$(id -g)" \
   -v "$PWD:/data" \
   -w /data \
   lidar-pipeline \
   gdalinfo 02_data/01_download/2022_4BandImagery_California_J1425462tR0_C0.tif
```

***

### Instructions

This script combines multiple `.tif` files into a single mosaic, **reprojects it to EPSG:6424 using Lanczos resampling**, and saves the result as a compressed, tiled `.tif`. It then removes the temporary files created during processing.

#### Native Execution 

```bash
#!/bin/bash
INPUT_DIR="02_data/01_download"

gdalbuildvrt \
    mosaic.vrt \
    "$INPUT_DIR"/*.tif

gdalwarp \
    -t_srs EPSG:6424 \
    -r lanczos \
    -of VRT \
    mosaic.vrt \
    reprojected.vrt

gdal_translate \
    -co COMPRESS=LZW \
    -co BIGTIFF=IF_NEEDED \
    -co PREDICTOR=2 \
    -co TILED=YES \
    reprojected.vrt \
    02_data/01_download/MERGED_REPROJECT.tif

rm mosaic.vrt reprojected.vrt

echo "Finished: MERGED_REPROJECT.tif"
```

#### Docker Execution 

```bash
./run_pipeline.sh 03_reproject.sh
```

***

### Previous Step

[**Step 2: Downloading Imagery**](02-downloading-imagery.md)  ←

### Next Step

[**Step 4: Colorizing Point Cloud**](04-colorizing-point-cloud.md) →

***
