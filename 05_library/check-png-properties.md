## Check .png Properties

This scripts scans PNG files in the current folder and lists their dimensions, alpha channel, bit depth, and color type (grayscale/RGB), sorted from largest to smallest image size.

```bash
results=""

for f in $(find . -maxdepth 1 -name "*.png"); do
  # Run gdalinfo once and store the output
  info=$(gdalinfo "$f" 2>/dev/null)
  
  # Skip if gdalinfo failed to read the file
  [ -z "$info" ] && continue

  # 1. Extract Dimensions (e.g., "1920x1080")
  dimensions=$(echo "$info" | grep -m 1 "Size is" | sed 's/Size is //;s/, /x/')

  # Calculate total pixels for accurate numerical sorting
  width=$(echo "$dimensions" | cut -d'x' -f1)
  height=$(echo "$dimensions" | cut -d'x' -f2)
  total_pixels=$((width * height))

  # 2. Check bit depth / data type
  if echo "$info" | grep -qi "Type=Byte"; then
    bit_type="8-bit"
  elif echo "$info" | grep -qi "Type=UInt16"; then
    bit_type="16-bit"
  else
    bit_type="Other"
  fi

  # 3. Check if Grayscale or RGB based on band count
  band_count=$(echo "$info" | grep -c "Band [0-9]")
  if [ "$band_count" -le 2 ]; then
    color_type="Grayscale"
  else
    color_type="RGB"
  fi

  # 4. Check for Alpha channel
  if echo "$info" | grep -qi "Alpha"; then
    alpha_status="with Alpha"
  else
    alpha_status="no Alpha"
  fi

  # Format line with a padded pixel count prefix for proper sorting
  printf -v padded_pixels "%010d" "$total_pixels"
  results="${results}${padded_pixels}|[$dimensions] | $alpha_status | $bit_type $color_type <- $f\n"
done

# Sort biggest to smallest (-rn) and strip the temporary pixel prefix
printf "%b" "$results" | sort -rn | cut -d'|' -f2-
```


