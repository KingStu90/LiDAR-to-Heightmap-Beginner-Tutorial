## Validate .laz Data

Checks every .laz file by having PDAL read and decompress the point cloud. Helps detect corrupted or incomplete downloads.

```bash
#!/bin/bash

for file in *.laz; do
    [ -e "$file" ] || continue
    echo "Checking: $file"

    if pdal translate "$file" /dev/null > /dev/null 2>&1; then
        echo "  -> [PASS]"
    else
        echo "  -> [FAIL] Check $file may be corrupted or incomplete."
    fi
done

```
