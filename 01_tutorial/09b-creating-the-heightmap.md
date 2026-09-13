## Step 9b: Creating the Heightmap Raster

***

### Overview

- This script is set up to work with both workflows: the **recommended workflow** and the **large-project alternative workflow**. 
  
- Recommended Workflow: **Step 9a → Step 9b → Step 10**
  
- Large-Project Alternative Workflow: **Step 9b → Step 9c → Step 10**
  
- In this step, we use CloudCompare's [**rasterize**](https://www.cloudcompare.org/doc/wiki/index.php?title=Rasterize) tool to **create the heightmap** [**raster**](https://desktop.arcgis.com/en/arcmap/latest/manage-data/raster-and-images/what-is-raster-data.htm).

>[!NOTE]
>When I say "**CloudCompare Interpolate**", I am referring to the "**Interpolate**" option in CloudCompare, which relies on Delaunay triangulation.

In general, I find CloudCompare **Kriging** to produce a **sharper raster** than CloudCompare **Interpolate**. However, as shown below, when there are "**nodata**" or **empty spaces** along the edge of the dataset, CloudCompare **Interpolate may produce a more desirable raster**.

<table>
  <tr>
    <td width="50%" align="center">
      <img src="../06_photos/09b_cc_kriging.webp"
      alt="Kriging interpolate">
      <br>
      <strong>CloudCompare Kriging</strong>
    </td>
    <td width="50%" align="center">
      <img src="../06_photos/09c_cc_interpolate.webp"
      alt="CloudCompare Interpolate">
      <br>
      <strong>CloudCompare Interpolate</strong>
    </td>
  </tr>
</table>

***

### Instructions

#### CloudCompare GUI 

-  `Tools > Projection > Rasterize`

***

CloudCompare Interpolate CLI Command: `EMPTY_FILL INTERP`

For creating the raster tiles for **heightmaps** , the remaining settings are **recommended defaults** for this workflow and should not normally need to be changed.

#### Native Execution (*Linux Mint Flatpak*)

```bash
#!/bin/bash
mkdir -p 02_data/09b_heightmap_raster

if [ -d "02_data/09a_heightmap_merge_laz" ]; then
    input_dir="02_data/09a_heightmap_merge_laz"
else
    input_dir="02_data/08_heightmap_scale_50"
fi

for file in "$input_dir"/*.laz; do
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
        -GRID_STEP 1.0 \
        -VERT_DIR 2 \
        -PROJ AVG \
        -EMPTY_FILL KRIGING \
        -OUTPUT_RASTER_Z

    mv "$input_dir/${base}"*RASTER_Z*.tif \
       "02_data/09b_heightmap_raster/${base}.tif"

    echo "Finished: ${base}.tif"
done
```

#### Docker Execution

```bash
./run_pipeline.sh 09b_heightmap_raster.sh
```

***

### Previous Step

[**Step 9a: Merging Point Cloud**](09a-merging-point-cloud.md)  ←

### Next Step

[**Step 10: Finalizing Heightmap**](10-finalizing-heightmap.md) →

***

### *Large-Project Alternative Workflow*

[**Step 9c: Merging Individual Raster Tiles**](09c-merging-raster.md) →

***