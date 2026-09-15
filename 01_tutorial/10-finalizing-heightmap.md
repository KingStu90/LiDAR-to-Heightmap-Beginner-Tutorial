## Step 10: Finalizing the Heightmap

### Overview

- This step combines several GDAL processing operations.
  
- Having access to QGIS and GIMP can make this process easier.
  
- The values used throughout the commands are **specific to this tutorial example** and BeamNG.drive.
  
- BeamNG.drive supports map sizes `512x512`, `1024x1024`, `2048x2048`, `4096x4096`, `8192x8192`.

***

### Instructions

***If running GDAL natively, remove the following Docker-specific code from each command:***

```bash
docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
```

***

#### 1) Cropping the Heightmap

- *`heightmap_MERGED.tif` when opened in GIMP may be a blank canvas.*

  - `Color > Auto > Stretch Contrast`

<div style="text-align: center;">
  <img src="../06_photos/10a_crop_extent_gimp.webp" 
  alt="GIMP rectangle tool - X and Y coordinate position instruction"
  style="max-width: 60%; height: auto;"><br>
  <em>X and Y define the starting position of the crop, measured from the upper-left corner of the image and 1024x1024 is the map size</em>
</div>

```bash
#!/bin/bash
mkdir -p 02_data/10_final_heightmap

input_file="02_data/09b_heightmap_raster/heightmap_MERGED.tif"
output_file="02_data/10_final_heightmap/heightmap_MERGED_CROP.tif"

echo "Cropping: $input_file"

# -srcwin X Y WIDTH HEIGHT
docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
    gdal_translate \
        -srcwin 100 50 1024 1024 \
        "$input_file" \
        "$output_file"

echo "Finished: $output_file"
```

***

#### 2) Convert Heightmap to 16-Bit

**A) Find Minimum and Maximum Heights**

- ***QGIS Method***

<div style="text-align: center;">
  <img src="../06_photos/10b_convert_16bit_qgis.webp" 
  alt="QGIS - minimum and maximum height"
  style="max-width: 60%; height: auto;"><br>
  <em>Note: QGIS may display slightly different min/max values than gdalinfo -mm</em>
</div>

- ***GDAL Method***

```bash
docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
    gdalinfo 02_data/10_final_heightmap/heightmap_MERGED_CROP.tif -mm
```

**B) Convert to 16-Bit**

- `scale` rescales the minimum and maximum elevations to fit the full 0–65,535 range.

```bash
#!/bin/bash
input_file="02_data/10_final_heightmap/heightmap_MERGED_CROP.tif"
output_file="02_data/10_final_heightmap/heightmap_MERGED_CROP_16BIT.tif"

echo "Converting: $input_file"

# -scale MIN MAX 0 65535
docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
    gdal_translate \
        -ot UInt16 \
        -scale 37.237 43.480 0 65535 \
        "$input_file" \
        "$output_file"

echo "Finished: $output_file"
```

***

#### 3) Convert `.tif` to `.png`

> [!IMPORTANT]
> If you are following my process of scaling the point cloud to 50%, the **X, Y, and Z dimensions are all reduced by 50%**.
>
> Setting `Meters per Pixel` to *2* in BeamNG.drive **restores the horizontal** (*X/Y*) **scale** but does **not** affect the **height** (*Z-axis*). The height must therefore be **manually scaled by 2x to restore the original elevation**.
>
>*Scaled Height (50%) = 9.457 m*<br>
>*Actual Height (2x) = 18.914 m*

- **Outputs the final heightmap**. Replace `FINAL_heightmap_buttonwillow_h18.914` with your own name.

```bash
#!/bin/bash
input_file="02_data/10_final_heightmap/heightmap_MERGED_CROP_16BIT.tif"
output_file="02_data/10_final_heightmap/FINAL_heightmap_buttonwillow_h18.914.png"

echo "Converting: $input_file"

docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
    gdal_translate \
        -of PNG \
        -a_nodata none \
        "$input_file" \
        "$output_file"

echo "Finished: $output_file"
```

>[!WARNING]  
>I recommend that the original heightmap **not be resized or resampled in a image editor** if it is being used as elevation data. Changes to the pixel values can alter the resulting terrain. 
>
>**Heightmap modifications** may be appropriate for **visual purposes**, such as generating normal maps or other PBR textures.

***

### Previous Step

[**Step 9b: Creating the Heightmap Raster**](09b-creating-the-heightmap.md)  ←

### Next Step

[**Step 11: Creating the Basemap Raster**](11-creating-the-basemap-cloudcompare.md) →

***
