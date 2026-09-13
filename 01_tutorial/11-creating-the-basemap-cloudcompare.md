## Step 11: Creating the Basemap Raster

### Overview

This step uses the color applied to the point cloud in Step 4 to **create the basemap raster**.

***While writing this tutorial, I found a better approach for creating the basemap***. The original version of this tutorial used a **PDAL pipeline** to create the raster, but in this tutorial we’ll use **CloudCompare Rasterize tool** instead.

This is a good example of why this tutorial is **not intended to demonstrate the one and only way to process LiDAR data**. There are many different tools and methods that can be used to accomplish the same task, and some approaches may work better than others depending on the dataset.

I am including the PDAL method [**here**](../05_library/99-creating-the-basemap-pdal.md) as a backup option.

As shown in the photos below, **PDAL IDW** interpolation **is not able to fill in the data where there are no points**, whereas CloudCompare **Kriging is able to fill in those areas with similar colors**.

<table>
  <tr>
    <td width="50%" align="center">
      <img src="../06_photos/11a_pdal_raster.webp" 
      alt="PDAL IDW interpolation"
      width="80%">
      <br>
      <strong>PDAL IDW</strong>
    </td>
    <td width="50%" align="center">
      <img src="../06_photos/11b_cloudcompare_raster.webp" 
      alt="CloudCompare Kriging interpolation"
      width="80%">
      <br>
      <strong>CloudCompare Kriging</strong>
    </td>
  </tr>
</table>

> [!IMPORTANT]  
> Use the **original colored point cloud before cleaning/filtering** to generate the raster. The processed point cloud contains fewer points, which can leave gaps when creating the basemap.
> 
> ***Fewer points → more interpolation → blurrier image***

### Instructions

#### Step 11a: Creating the Basemap Raster via *CloudCompare*

>[!NOTE]
>We are using `GRID_STEP 0.5` to create a **higher-resolution intermediate raster** before **downsampling in Step 12**. This allows more of the color variation from the point cloud to be represented before the final resampling step. When resampled with Lanczos, **this additional detail can then be used when calculating the final pixels, generally producing a sharper-looking basemap**.

##### Native Execution (*Linux Mint Flatpak*)

```bash
#!/bin/bash
mkdir -p 02_data/11_basemap_raster

for file in 02_data/04_colorize/*.laz; do
    base="$(basename "${file%.laz}")"

    PATH="/usr/bin:/bin" \
    env -i \
        HOME="$HOME" \
        DISPLAY="$DISPLAY" \
        WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
        XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
        flatpak run --filesystem=host org.cloudcompare.CloudCompare \
        -SILENT \
        -O -GLOBAL_SHIFT AUTO "$file" \
        -RASTERIZE \
        -GRID_STEP 0.5 \
        -VERT_DIR 2 \
        -PROJ AVG \
        -EMPTY_FILL KRIGING \
        -OUTPUT_RASTER_RGB

    mv "02_data/04_colorize/${base}"*RASTER_RGB*.tif \
       "02_data/11_basemap_raster/${base}.tif"

    echo "Finished: ${base}.tif"
done
```

##### Docker Execution

```bash
./run_pipeline.sh 11a_basemap_raster.sh
```

#### Step 11b: Merging the Basemap

For merging **imagery** raster tiles, the following settings are ***recommended*** and ***should not*** normally need to be changed.

##### Native Execution

```bash
#!/bin/bash
mkdir -p "02_data/11_basemap_raster"

gdalbuildvrt \
    "02_data/11_basemap_raster/basemap_MERGED.vrt" \
    "02_data/11_basemap_raster/"*.tif

gdal_translate \
    -ot Byte \
    -co COMPRESS=DEFLATE \
    -co PREDICTOR=2 \
    -co TILED=YES \
    -co PHOTOMETRIC=RGB \
    -co INTERLEAVE=PIXEL \
    -co BIGTIFF=IF_NEEDED \
    "02_data/11_basemap_raster/basemap_MERGED.vrt" \
    "02_data/11_basemap_raster/basemap_MERGED.tif"

rm "02_data/11_basemap_raster/basemap_MERGED.vrt"

echo "Finished: basemap_MERGED.tif"
```

##### Docker Execution

```bash
./run_pipeline.sh 11b_basemap_merge_tif.sh
```

### Previous Step

[**Step 10: Finalizing the Heightmap**](10-finalizing-heightmap.md)  ←

### Next Step

[**Step 12: Finalizing the Basemap**](12-finalizing-basemap.md) →
