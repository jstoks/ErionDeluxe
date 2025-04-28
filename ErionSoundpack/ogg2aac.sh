#!/bin/bash

# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_path> <output_path>"
    exit 1
fi

input_path="$1"
output_path="$2"

# Remove trailing slash from input_path if present
input_path="${input_path%/}"
output_path="${output_path%/}"

# Check if input path exists
if [ ! -d "$input_path" ]; then
    echo "Error: Input path '$input_path' does not exist or is not a directory."
    exit 1
fi

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed. Please install it first."
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$output_path"

# Find all .ogg files and convert them to .aac
find "$input_path" -type f -name "*.ogg" | while read -r ogg_file; do
    # Get the relative path from the input path
    rel_path="${ogg_file#$input_path/}"
    
    # Construct the output .acc file path
    aac_file="$output_path/${rel_path%.ogg}.aac"
    
    # Create the output directory if it doesn't exist
    mkdir -p "$(dirname "$aac_file")"
    
    # Convert .ogg to .aac
    echo -n "Converting $ogg_file to $aac_file ... "
    if [ -e "$aac_file" ]; then
      echo "Output already exists. Skipping."
    else
      echo 'Done'
      #ffmpeg -nostdin -i "$ogg_file" -ac 2 -ar 44100 -joint_stereo 0 "$aac_file" -y -loglevel error
      ffmpeg -nostdin -i "$ogg_file" "$aac_file" -y -loglevel error
    fi
done

echo "Conversion completed."
