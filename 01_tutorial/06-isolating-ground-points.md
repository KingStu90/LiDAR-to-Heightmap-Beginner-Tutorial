## Step 6: Isolating Ground Points

### Overview

In this step, we are isolating the **ground** from **non-ground points**. To do this, the Cloth Simulation Filter (CSF) tool uses a simulated cloth draped over the inverted point cloud (*Example A*) to determine which points can be classified as ground and non-ground.

<p style="text-align: center;"><strong>Example A</strong></p>

<p align="center">
  <img src="../06_photos/06a_csf_principle.webp"
  alt="CSF visualization"><br>
  <a href="https://ramm.bnu.edu.cn/researchers/wumingzhang/english/default_contributions.htm">Original Contribution by Wuming Zhang</a>
</p>

**For the dataset provided** with this tutorial, the CloudCompare CSF filter does a pretty good job of correctly identifying the ground and non-ground points (*Example B*).

However, there are some cases (*Example C*) where the CloudCompare CSF filter **may not work well**, such as areas with very **steep or vertical terrain** where much of the ground can be incorrectly classified as non-ground. The Eureka Dunes (*Example C*) are also a good example of a dataset where the CSF filter is unnecessary and **can incorrectly classify ground points as non-ground points**.

<table>
  <tr>
    <th colspan="2">Example B</th>
  </tr>
  <tr>
    <td width="50%" align="center">
      <img src="../06_photos/06b_csf_ground.webp"
      alt="Buttonwillow example - CSF ground output">
      <br>
      <strong>Buttonwillow</strong><br>
      Ground Points
    </td>
    <td width="50%" align="center">
      <img src="../06_photos/06c_csf_offground.webp"
      alt="Buttonwillow example - CSF non-ground output">
      <br>
      <strong>Buttonwillow</strong><br>
      Non-Ground Points
    </td>
  </tr>
</table>

<table>
  <tr>
    <th colspan="2">Example C</th>
  </tr>
  <tr>
    <td width="50%" align="center">
      <img src="../06_photos/06e_csf_offground_yosemite.webp"
      alt="Yosemite example - CSF non-ground output">
      <br>
      <strong>Yosemite</strong><br>
      Non-Ground Points
    </td>
    <td width="50%" align="center">
      <img src="../06_photos/06d_csf_offground_dunes.webp"
      alt="Eureka Dunes example - CSF non-ground output">
      <br>
      <strong>Eureka Dunes</strong><br>
      Non-Ground Points
    </td>
  </tr>
</table>

***

### Instructions

#### CloudCompare GUI 

-  `Plugins > CSF Filter`

***

| Setting            | Options / Value         | Description                                   |
| ------------------ | ----------------------- | --------------------------------------------- |
| `SCENES`           | `FLAT` `RELIEF` `SLOPE` | Selects the type of terrain                   |
| `PROC_SLOPE`       |                         | Processes steep slopes                        |
| `CLOTH_RESOLUTION` | `2.00` (*default*)      | Controls the cloth grid resolution            |
| `MAX_ITERATION`    | `500` (*default*)       | Maximum number of cloth simulation iterations |
| `CLASS_THRESHOLD`  | `0.5` (*default*)       | Distance used to classify ground points       |

> [!NOTE]
> `CLOTH_RESOLUTION` and `CLASS_THRESHOLD` values are dependent on the unit of measurement. The **default values are set for meters**, so for datasets using feet, you will need to **convert the values to feet**.
> 
>*1 meter = 3.28 feet*
>
>`SCENES` and `PROC_SLOPE` are also dependent on your dataset.

#### Native Execution (*Linux Mint Flatpak*)

```bash
#!/bin/bash
mkdir -p 02_data/06_heightmap_csf_ground 02_data/06_heightmap_csf_offground

for file in 02_data/05_heightmap_sor_filter/*.laz; do
    base="$(basename "${file%.laz}")"

    PATH="/usr/bin:/bin" \
    env -i \
        HOME="$HOME" \
        DISPLAY="$DISPLAY" \
        WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
        XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
        flatpak run --filesystem=host org.cloudcompare.CloudCompare \
        -SILENT \
        -AUTO_SAVE OFF \
        -C_EXPORT_FMT laz \
        -O -GLOBAL_SHIFT AUTO "$file" \
        -CSF \
        -SCENES FLAT \
        -CLOTH_RESOLUTION 3.28 \
        -MAX_ITERATION 500 \
        -CLASS_THRESHOLD 1.64 \
        -SAVE_CLOUDS

mv "02_data/05_heightmap_sor_filter/${base}"*_ground_points_*.laz \
   "02_data/06_heightmap_csf_ground/${base}_GROUND.laz"

mv "02_data/05_heightmap_sor_filter/${base}"*_offground_points_*.laz \
   "02_data/06_heightmap_csf_offground/${base}_OFFGROUND.laz"

    echo "Finished: ${base}_GROUND.laz"
    echo "Finished: ${base}_OFFGROUND.laz"
done
```

#### Docker Execution 

```bash
./run_pipeline.sh 06a_heightmap_csf_filter.sh
```

>[!WARNING]
>The **command below** converts the `.las` back into `.laz`.
> 
>***This only applies to the Docker workflow.***

#### Docker Execution 

```bash
./run_pipeline.sh 06b_heightmap_las_to_laz.sh
```

***

#### Alternative Methods of Filtering/Cleaning

-  CloudCompare [**Noise Filter**](https://www.cloudcompare.org/doc/wiki/index.php/Noise_filter)
  
	-  `Tools > Clean > Noise filter`

- CloudCompare [**Scalar Fields/ Filter by Value**](https://www.cloudcompare.org/doc/wiki/index.php/Scalar_fields%5CFilter_by_Value)
  
	-  *Return Number*, *Number of Returns*, *Classification* are some useful scalar fields
	  
	- `Edit > Scalar Fields > Filter by Value`

-  PDAL has many [**filters**](https://pdal.io/en/stable/stages/filters.html), including a [**CSF**](https://pdal.io/en/stable/stages/filters.csf.html#filters-csf) filter that supports a `where` option. This can be used to control which points are passed to the CSF filter and may provide a way to exclude steep or vertical surfaces. *I have not tested this approach*.

***

### Previous Step

[**Step 5: Cleaning Point Cloud**](05-cleaning-point-cloud.md)  ←

### Next Step

[**Step 7: Converting from Feet to Meters** (***if needed***)](07-ft-to-m.md) →

### *Dataset Already in Meters?*

[**Step 8: Scale Point Cloud to 50%**](08-scale-50.md) →

***

