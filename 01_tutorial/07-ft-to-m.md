## Step 7: Converting from Feet to Meters (if needed)

### Overview

- Since [**January 1, 2023**](https://www.nist.gov/pml/us-surveyfoot), the **U.S. survey foot has been obsolete**. New datasets should use the international foot: `1 ft = 0.3048 m`.
  
- Older datasets may still use the **U.S. survey foot**: `1 ft = 0.304800609601219 m`.
  
- **For this tutorial**, the provided data is in **U.S. survey feet**, while BeamNG.drive uses **meters**.
  
- To find out what unit of measurement your dataset is in, use `pdal info` (*covered in Step 2*).

***

### Instructions

This script **converts the X, Y, and Z coordinates of each `.laz` point cloud from feet to meters** using a conversion factor of **0.3048006096 meters per foot**. It then **saves the converted point clouds as new `.laz` files**.

#### Native Execution 

```bash
#!/bin/bash
mkdir -p 02_data/07_heightmap_ft_to_m

for file in 02_data/06_heightmap_csf_ground/*.laz; do
    base="$(basename "${file%.laz}")"

    pdal pipeline --stdin <<EOF
{
    "pipeline": [
        {
            "type": "readers.las",
            "filename": "$file"
        },
        {
            "type": "filters.transformation",
            "matrix": "0.304800609601219 0 0 0 0 0.304800609601219 0 0 0 0 0.304800609601219 0 0 0 0 1"
        },
        {
            "type": "writers.las",
            "compression": "laszip",
            "filename": "02_data/07_heightmap_ft_to_m/${base}_METERS.laz"
        }
    ]
}
EOF

    echo "Finished: ${base}_METERS.laz"
done
```

#### Docker Execution 

```bash
./run_pipeline.sh 07_heightmap_ft_to_m.sh
```

***

### Previous Step

[**Step 6: Isolating Ground Points**](06-isolating-ground-points.md)  ←

### Next Step

[**Step 8: Scaling Point Cloud to 50%**](08-scale-50.md) →

***