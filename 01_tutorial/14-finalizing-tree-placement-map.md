## Step 14: Finalizing the Tree Placement Map

***

### Overview

- This step combines several GDAL processing operations.
   
- The **values used** throughout the commands are **specific to this tutorial example** and BeamNG.drive.

***

### Instructions

#### 1) Scaling the Tree Placement Map

- For BeamNG.drive, the **Tree Placement Map** should be resized with `outsize` to the \***same dimensions**\* as `heightmap_MERGED.tif` from **Step 10**.

- The remaining settings are **recommended defaults** for this workflow and should not normally need to be changed.

```bash
mkdir -p 02_data/14_final_tree_placement_map

input_file="02_data/13b_trees_rasters/trees_MERGED.tif"
output_file="02_data/14_final_tree_placement_map/trees_MERGED_SCALED.tif"

echo "Scaling: $input_file"

docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
    gdal_translate \
        -ot Float32 \
        -outsize 1144 1144 \
        -r nearest \
        -co COMPRESS=DEFLATE \
        -co PREDICTOR=3 \
        -co TILED=YES \
        -co BIGTIFF=IF_NEEDED \
        "$input_file" \
        "$output_file"

echo "Finished: $output_file"
```

***

#### 2) Cropping Tree Placement Map

- Crop the **Tree Placement Map** using the **same crop coordinates** used for `heightmap_MERGED.tif` in **Step 10**.

```bash
#!/bin/bash
input_file="02_data/14_final_tree_placement_map/trees_MERGED_SCALED.tif"
output_file="02_data/14_final_tree_placement_map/trees_MERGED_SCALED_CROP.tif"

echo "Cropping: $input_file"

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

#### 3) Find the Minimum and Maximum Values

- Use `gdalinfo -mm` or **QGIS** to obtain the **minimum and maximum** pixel values needed for the `scale` operation in the next step.

```bash
docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
    gdalinfo 02_data/14_final_tree_placement_map/trees_MERGED_SCALED_CROP.tif -mm
```

***

#### 4) Convert to 8-Bit `.png`

- **Outputs the final Tree Placement Map**. Replace `buttonwillow` with your own name.

```bash
#!/bin/bash
input_file="02_data/14_final_tree_placement_map/trees_MERGED_SCALED_CROP.tif"
output_file="02_data/14_final_tree_placement_map/FINAL_tree_placement_map_buttonwillow.png"

echo "Converting: $input_file"

docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/data" \
    -w /data \
    lidar-pipeline \
    gdal_translate \
        -ot Byte \
        -of PNG \
        -scale 285.110 314.830 0 255 \
        -a_nodata none \
        "$input_file" \
        "$output_file"

echo "Finished: $output_file"
```

***

### Previous Step

[**Step 13: Creating the Tree Placement Map**](13-isolating-trees.md)  ←

***

### Map Downloads & More Examples 

[**Final Results**](../07_credits_and_resources/01-downloads-and-more-examples.md) →

### Citations and Attribution

[**Sources**](../07_credits_and_resources/03-citations-and-attribution.md) →

### LiDAR Data and Other Resources

[**Useful Resources**](../07_credits_and_resources/02-lidar-data-and-other-resources.md) →

***