## Step 12: Finalizing the Basemap

### Overview

- This step combines several GDAL processing operations.
   
- The **values used** throughout the commands are **specific to this tutorial example** and BeamNG.drive.
  
### Instructions

#### 1) Scaling the Basemap

For this step we will need the original dimensions of `heightmap_MERGED.tif` from **Step 10**.

```text
heightmap_MERGED.tif = 1144 x 1144
                            ↓ ×2
basemap_MERGED.tif    = 2288 x 2288
```

 *If the point cloud has been scaled to 50% the basemap dimensions need to be scaled to 2x.*

```bash
#!/bin/bash
mkdir -p 02_data/12_final_basemap

input_file="02_data/11_basemap_raster/basemap_MERGED.tif"
output_file="02_data/12_final_basemap/basemap_MERGED_SCALED.tif"

echo "Scaling: $input_file"

docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
    gdal_translate \
        -outsize 2288 2288 \
        -r lanczos \
        -co COMPRESS=LZW \
        -co TILED=YES \
        "$input_file" \
        "$output_file"

echo "Finished: $output_file"
```

`outsize` - Resizes the image to a **specific width and height** in pixels.
  
For **aerial and satellite imagery**, these resampling methods are good options:

**A)** `r lanczos` - Usually the best choice when **maximum sharpness and detail** are the priority.

**B)** `r cubic` - Produces **sharper results than bilinear**, with more processing time.

**C)** `r bilinear` - **Faster than cubic**, but generally produces a softer image.

#### 2) Cropping the Basemap

```text
Heightmap crop:  x=100, y=50, width=1024, height=1024
                       ↓ ×2
Basemap crop:    x=200, y=100, width=2048, height=2048
```

*The basemap crop values are also 2x the heightmap crop values if the point cloud was scaled to 50%.*

```bash
#!/bin/bash
input_file="02_data/12_final_basemap/basemap_MERGED_SCALED.tif"
output_file="02_data/12_final_basemap/basemap_MERGED_SCALED_CROP.tif"

echo "Cropping: $input_file"

docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
    gdal_translate \
        -srcwin 200 100 2048 2048 \
        "$input_file" \
        "$output_file"

echo "Finished: $output_file"
```

#### 3) Convert from `.tif` to `.png`

**Outputs the final basemap**. Replace `buttonwillow` with your own name.

```bash
#!/bin/bash
input_file="02_data/12_final_basemap/basemap_MERGED_SCALED_CROP.tif"
output_file="02_data/12_final_basemap/FINAL_basemap_buttonwillow.png"

echo "Converting: $input_file"

docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
    gdal_translate \
        -ot Byte \
        -of PNG \
        -a_nodata none \
        "$input_file" \
        "$output_file"

echo "Finished: $output_file"
```

## Previous Step

[**Step 11: Creating the Basemap Raster**](11-creating-the-basemap-cloudcompare.md)  ←

## Next Step

[**Step 13: Isolating Trees**](13-isolating-trees.md) →