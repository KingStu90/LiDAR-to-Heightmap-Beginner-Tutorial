## Step 9a: Merging the Point Cloud

***

### Overview

**A)** **Recommended Workflow**

**Merging the point clouds before rasterization helps prevent artifacts** in the final heightmap, such as visible lines where individual tiles meet.

```text
Step 9a: Merging the Point Cloud
             ↓
Step 9b: Creating the Heightmap Raster
             ↓
Step 10: Finalizing the Heightmap
```

***

**B)** **Large-Project Alternative Workflow**

This **alternative workflow** is for projects where the merged point cloud is **too large to process all at once. Skip to** [**Step 9b**](09b-creating-the-heightmap.md), if you are following this workflow.

```text
Step 9b: Creating the Heightmap Raster
                  ↓
Step 9c: Merging Individual Raster Tiles
                  ↓
Step 10: Finalize Heightmap
```

***

### Instructions

***

This script **merges multiple `.laz` files into a single point cloud** and saves the result as a new `.laz` file.

***
#### Native Execution 

```bash
#!/bin/bash
mkdir -p 02_data/09a_heightmap_merge_laz

pdal merge \
    02_data/08_heightmap_scale_50/*.laz \
    02_data/09a_heightmap_merge_laz/heightmap_MERGED.laz

echo "Finished: heightmap_MERGED.laz"
```

***

#### Docker Execution

```bash
./run_pipeline.sh 09a_heightmap_merge_laz.sh
```

***

### Previous Step

[**Step 8: Scaling Point Cloud to 50%**](08-scale-50.md)  ←

### Next Step

[**Step 9b: Creating the Heightmap Raster**](09b-creating-the-heightmap.md) →

***