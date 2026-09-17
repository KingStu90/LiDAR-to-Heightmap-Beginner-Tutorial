## Python Script for Merging JSON Configuration Files

This Python script combines multiple `.json` configuration files from different developer maps into a **single combined** `.json` **file** that can be used in your own project. 

For example,

- `art > forest > managedItemData.json` or

- `art > terrain > main.materials.json`

### Instructions

1) **Copy** the developer `.json` files from whichever developer maps have the configuration files you want to use and move them into **the same folder**.

	You **will** have to rename the developer configuration files so they have different file names. 
	
	For example: 

	`managedItemData_westcoast.json`

	`managedItemData_eastcoast.json`

2) Save the Python code in a **text document** in **the same folder** as the `.json` files and save it as a `.py`. 
   
	For example:
	
	`combine_forestitems.py`

3) Open a terminal and navigate to the folder containing the `.json` files and the `.py`file. 

	Run:
   
	`	python3 combine_forestitems.py`
   
	**Note: If the same entry appears in multiple files, the last version processed by the script will be used.**

	Use the `find and replace` function to replace map names ***if needed***

4) The `output_filename` variable can be changed if you want the combined file to have a different name.

```python
import json
import os

def merge_json_files():
    merged_data = {}
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    output_filename = 'combined_forestitems.json'
    
    # Look for all JSON files in the current directory
    for filename in os.listdir(current_dir):
        if filename.endswith('.json') and filename != output_filename:
            print(f"Processing: {filename}...")
            try:
                with open(os.path.join(current_dir, filename), 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    # Merge the dictionary items (overwriting duplicates if they appear in later files)
                    for key, value in data.items():
                        if key in merged_data:
                            print(f"  -> Duplicate found: '{key}' already exists. Overwriting.")
                        merged_data[key] = value
            except Exception as e:
                print(f"Error reading {filename}: {e}")

    # Save the combined result
    output_path = os.path.join(current_dir, output_filename)
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(merged_data, f, indent=2)
    
    print(f"\nSuccess! Combined {len(merged_data)} unique json into '{output_filename}'")

if __name__ == "__main__":
    merge_json_files()
```
