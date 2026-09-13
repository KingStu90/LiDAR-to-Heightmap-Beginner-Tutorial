## Step 13: Creating Tree Placement Map

### Overview

- ***This process, like the basemap rasterization process, was modified during the writing of this tutorial,*** so I have not done as much testing on this process as the rest of this tutorial.

- This step uses **PDAL filters** on the point cloud tiles from Step 4 to **isolate points associated with trees**.
  
- The filtered points are converted into raster tiles to create a **tree placement map**. In BeamNG.drive we can use this to **place trees with the World Editor** [**Biome Tool**](https://documentation.beamng.com/world_editor/tools/biome_tool/).
  
The filtering process **removes most of the points from the original tile**, so the **remaining points might occupy only a small portion of the original extent** (*as shown with Buttonwillow*). When the raster is created from only the filtered points, the **resulting raster is smaller than the original tile**. With this new method the **original tile extent is preserved** during the rasterization process **so the same crop coordinates can be used** later to keep the tree placement map aligned with the heightmap and basemap.

<div align="center">
  <img src="../06_photos/13e_trees.webp" 
  alt="Simple drawing of tree filtering concept"
  style="max-width: 60%; height: auto;">
</div>

<figure style="text-align: center; margin: auto;">
  <h2>Tree Placement Map Examples</h2>
  
  <table style="width: 100%; table-layout: fixed; border-collapse: collapse;">
    <tr>
      <td align="center" style="width: 33.33%; vertical-align: top; padding: 8px;">
        <img src="../06_photos/13a_buttonwillow.webp" 
        alt="Buttonwillow tree filter over basemap"
        style="width: 100%; height: auto;">
        <br>
        <strong>Buttonwillow Raceway Park</strong>
      </td>
      <td align="center" style="width: 33.33%; vertical-align: top; padding: 8px;">
        <img src="../06_photos/13b_ridge.webp" 
        alt="Ridge Motorsports Park tree filter over basemap"
        style="width: 100%; height: auto;">
        <br>
        <strong>Ridge Motorsports Park</strong>
        <em>(Out of Date Imagery)</em>
      </td>
      <td align="center" style="width: 33.33%; vertical-align: top; padding: 8px;">
        <img src="../06_photos/13c_yosemite.webp" 
        alt="El Capitan tree filter over basemap"
        style="width: 100%; height: auto;">
        <br>
        <strong>El Capitan</strong>
      </td>
    </tr>
  </table>

  <figcaption style="text-align: center; margin-top: 10px;"><em>Colors swapped for easier viewing. Red = tree placement</em></figcaption>
</figure>

> [!NOTE]  
> This is one of the steps that **may require some experimentation with different settings to correctly identify trees**. As shown above **(A)**, parts of the El Capitan mountain face were **misidentified as trees**. This could be reduced by further refining `filters.approximatecoplanar` and adding linearity-based filtering. The settings in this tutorial are intentionally kept **conservative and broadly applicable**.

### Instructions

#### 13a_pipeline_trees_filter.json

<div align="center">
  <img src="../06_photos/13d_pdal_pipeline.webp" 
  alt="PDAL pipeline settings"
  style="max-width: 50%; height: auto;">
</div>

**A)** Classifies **ground points** and separates them from **non-ground points**.

**B)** Calculates the height of each point above the ground.

**C)** Analyzes the local geometry of points to help distinguish **planar surfaces** from **irregular vegetation**.

**D)** Keeps only points **35–115 units above ground** and **removes points classified as coplanar**.

**E)** **Reduces the number of remaining points** by keeping a representative point within each **20-unit voxel**.

| Filter                                 | Setting                     | Unit-dependent? |
| -------------------------------------- | --------------------------- | --------------- |
| `filters.smrf`                         | `window: 50.0`              | **Yes**\*       |
| `filters.smrf`                         | `slope: 0.20`               | No              |
| `filters.smrf`                         | `threshold: 1.0`            | **Yes**\*       |
| `filters.approximatecoplanar`          | `knn: 12`                   | No              |
| `filters.approximatecoplanar`          | `thresh1: 25.0`             | No              |
| `filters.approximatecoplanar`          | `thresh2: 6.0`              | No              |
| `filters.range`                        | `HeightAboveGround[35:115]` | **Yes**\*       |
| `filters.range`                        | `Coplanar[0:0]`             | No              |
| `filters.voxelcentroidnearestneighbor` | `cell: 20.0`                | **Yes**\*       |

>[!NOTE]
>The settings that are **unit-dependent**\* are given in **feet**. **If your original dataset uses meters**, multiply the values given by `0.3048` to convert them to meters.

#### 13b_pipeline_trees_raster.json

These settings in `13b_pipeline_trees_raster.json` are ***recommended*** and ***should not*** normally need to be changed.

#### 13a Tree Filter and Raster

##### Native Execution

```bash
mkdir -p 02_data/13a_trees_filter
mkdir -p 02_data/13b_trees_rasters

for file in 02_data/04_colorize/*.laz; do
    base="$(basename "${file%.laz}")"

    echo "Processing: $base"

    # Get original tile bounds
    bounds=$(pdal info --summary "$file")

    read xmin xmax ymin ymax < <(
        echo "$bounds" | python -c '
import sys
import json

data = json.load(sys.stdin)
bbox = data["summary"]["bounds"]

print(bbox["minx"], bbox["maxx"], bbox["miny"], bbox["maxy"])
'
    )

    echo "Bounds:"
    echo "  X: $xmin → $xmax"
    echo "  Y: $ymin → $ymax"

    # Filter tree points
    pdal pipeline 04_resources/13a_pipeline_trees_filter.json \
        --readers.las.filename="$file" \
        --writers.las.filename="02_data/13a_trees_filter/${base}_TREES.laz"

    # Rasterize tree points using original tile extent
    pdal pipeline 04_resources/13b_pipeline_trees_raster.json \
        --readers.las.filename="02_data/13a_trees_filter/${base}_TREES.laz" \
        --writers.gdal.filename="02_data/13b_trees_rasters/${base}_TREES.tif" \
        --writers.gdal.bounds="([$xmin,$xmax],[$ymin,$ymax])"

    echo "Finished: ${base}"
done

```

##### Docker Execution

```bash
./run_pipeline.sh 13a_tree_filter_and_raster.sh
```

#### 13b Merge Tree Rasters

##### Native Execution

The following settings are ***recommended*** and ***should not*** normally need to be changed.

```bash
#!/bin/bash
gdalbuildvrt \
    "02_data/13b_trees_rasters/trees_MERGED.vrt" \
    "02_data/13b_trees_rasters/"*.tif

gdal_translate \
    -ot Float32 \
    -co COMPRESS=DEFLATE \
    -co PREDICTOR=3 \
    -co TILED=YES \
    -co BIGTIFF=IF_NEEDED \
    "02_data/13b_trees_rasters/trees_MERGED.vrt" \
    "02_data/13b_trees_rasters/trees_MERGED.tif"

rm "02_data/13b_trees_rasters/trees_MERGED.vrt"

echo "Finished: trees_MERGED.tif"
```

##### Docker Execution

```bash
./run_pipeline.sh 13b_trees_merge_tif.sh
```

## Previous Step

[**Step 12: Finalizing the Basemap**](12-finalizing-basemap.md)  ←

## Next Step

[**Step 14: Finalizing the Tree Placement Map**](14-finalizing-tree-placement-map.md) →
