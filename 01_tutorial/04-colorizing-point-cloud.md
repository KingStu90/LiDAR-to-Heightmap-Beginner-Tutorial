## Step 4: Colorizing Point Cloud

***

### Overview

- To apply the color information from the imagery to the point cloud, we are going to use PDAL's `filters.colorization`.
  
- **Adding color to a point cloud can make it much easier to see the data**, especially when viewing it in 3D point cloud software such as CloudCompare.

<table>
  <tr>
    <td width="50%" align="center">
      <img src="../06_photos/04a_before_colorization.webp"
      alt="Before colorization">
      <br>
      <strong>Original Point Cloud</strong>
    </td>
    <td width="50%" align="center">
      <img src="../06_photos/04b_after_colorization.webp"
      alt="After colorization">
      <br>
      <strong>Colored Point Cloud</strong>
    </td>
  </tr>
</table>

***

### Instructions

This script **colorizes each `.laz` file using the reprojected `.tif` raster**, adding RGB color information to the LiDAR point data. It then **saves each colorized file as a compressed `.laz` file**.

>[!IMPORTANT]  
>**I highly recommend you check the point clouds in CloudCompare or QGIS after this step** to make sure the colorization process was successful.
>
>**This process will still output "completed" `.laz` files even if the imagery and point cloud data are misaligned.** Depending on the workflow of later processes, you may not be able to colorize the point cloud later if its spatial information has been lost or overwritten.

#### Native Execution 

```bash
#!/bin/bash
mkdir -p 02_data/04_colorize

for file in 02_data/01_download/*.laz; do
    base="$(basename "${file%.laz}")"

    pdal pipeline --stdin --stream <<EOF
{
  "pipeline": [
    {
      "type": "readers.las",
      "filename": "$file"
    },
    {
      "type": "filters.colorization",
      "raster": "02_data/01_download/MERGED_REPROJECT.tif"
    },
    {
      "type": "writers.las",
      "compression": true,
      "minor_version": 4,
      "dataformat_id": 7,
      "filename": "02_data/04_colorize/${base}_COLOR.laz"
    }
  ]
}
EOF

    echo "Finished: ${base}_COLOR.laz"
done
```

#### Docker Execution 

```bash
./run_pipeline.sh 04_colorize.sh
```

***
  
### Previous Step

[**Step 3: Reprojecting Imagery**](03-reprojecting-imagery.md)  ←

### Next Step

[**Step 5: Cleaning Point Cloud**](05-cleaning-point-cloud.md) →

***
