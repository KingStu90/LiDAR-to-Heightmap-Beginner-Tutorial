## Step 5: Cleaning Point Cloud

### Overview

*Steps 5 and 6* use CloudCompare's Command Line Interface (*CLI*) to process the point cloud instead of the Graphical User Interface (*GUI*).

| **CLI Benefit**                                                                                    | **GUI Benefit**                                                                        |
| :------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------- |
| &bull; Repeatability / Docker Compatibility<br>&bull; More efficient processing of large data sets | &bull; Easier for beginners to learn<br>&bull; Much easier to experiment with settings |
| **CLI Drawback**                                                                                   | **GUI Drawback**                                                                       |
| &bull; CloudCompare built primarily as GUI application<br>&bull; Code complexity                   | &bull; RAM dependent (bottleneck)<br>&bull; Longer loading time (render data)          |

There are **many different methods for cleaning up noisy point cloud data**. This step is very dependent on your dataset. The number of tiles, point density, and amount of available **RAM and virtual memory** can all affect how you process the data.

For example, **9 merged** `.laz` tiles from **Yosemite National Park** contained over **849,648,733 points** and were **5.8 GB** in size. When loaded into CloudCompare, this dataset required **over 46 GB of memory** and caused CloudCompare to crash due to insufficient memory.

On the other hand, **9 merged** `.laz` tiles from **Buttonwillow Raceway Park** contained **93,526,691 points** and were only **288 MB** in size. When loaded into CloudCompare, this dataset required approximately **8.5 GB of memory**, which is much more manageable on most computers.

The important takeaway is that for smaller projects, you can generally do most of the processing within the CloudCompare GUI. **As datasets become larger, you may need to split the work into smaller sections or process the individual tiles separately**.

<table>
  <tr>
    <td width="50%" align="center">
      <img src="../06_photos/05a_before_sor.webp"
      alt="Before SOR filter">
      <br>
      <strong>Before SOR Filter</strong>
    </td>
    <td width="50%" align="center">
      <img src="../06_photos/05b_after_sor.webp"
      alt="After SOR filter">
      <br>
      <strong>After SOR Filter</strong>
    </td>
  </tr>
</table>

For this tutorial, the code I have provided uses CloudCompare's SOR Filter to **remove statistical outliers**, as shown in the Before and After photos. The values used are relatively conservative and **may have to be changed for different datasets.**

***

### Instructions

#### CloudCompare GUI 

-  `Tools > Clean > SOR filter`

***

The values used in the SOR script correspond to the following:

- **12** (*nearest neighbors*): Defines the **local neighborhood** around each point that the filter uses for comparison. A higher number looks at a **larger surrounding area**, while a lower number focuses on a **smaller area**.
    
- **2.5** (*standard deviations*): Controls **how far a point can differ from the surrounding points before it is removed**. A *larger value removes fewer points*, while a *smaller value removes more points*.

#### Native Execution (*Linux Mint Flatpak*)

> [!NOTE]  
> These commands are written for the **Flatpak version of CloudCompare** on Linux Mint. If you are using the **native execution** commands, you *may have to remove* the Flatpak/environment lines and replace them with `CloudCompare`.

```bash
mkdir -p 02_data/05_heightmap_sor_filter

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
        -AUTO_SAVE OFF \
        -C_EXPORT_FMT LAZ \
        -O -GLOBAL_SHIFT AUTO "$file" \
        -SOR 12 2.5 \
        -SAVE_CLOUDS FILE "02_data/05_heightmap_sor_filter/${base}_SOR.laz"

    echo "Finished: ${base}_SOR.laz"
done
```

#### Docker Execution

```bash
./run_pipeline.sh 05a_heightmap_sor_filter.sh
```

> [!WARNING]  
> As mentioned before, CloudCompare is primarily built for processing with the GUI. **In order to get CloudCompare to work with Docker, all scalar fields had to be removed** using `-REMOVE_ALL_SFS`, and the point cloud also had to be exported as a `.las` file.
> 
> The **command below** converts the `.las` back into `.laz`.
> 
> *This only applies to the Docker workflow.*

#### Docker Execution

```bash
./run_pipeline.sh 05b_heightmap_las_to_laz.sh
```

***

### Previous Step

[**Step 4: Colorizing Point Cloud**](04-colorizing-point-cloud.md) ←

### Next Step

[**Step 6: Isolating Ground Points**](06-isolating-ground-points.md) →

***
