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

# Find all .ogg files and convert them to .mp3
find "$input_path" -type f -name "*.ogg" | while read -r ogg_file; do
    # Get the relative path from the input path
    rel_path="${ogg_file#$input_path/}"
    
    # Construct the output .mp3 file path
    mp3_file="$output_path/${rel_path%.ogg}.mp3"
    
    # Create the output directory if it doesn't exist
    mkdir -p "$(dirname "$mp3_file")"
    
    # Convert .ogg to .mp3
    echo -n "Converting $ogg_file to $mp3_file ... "
    if [ -e "$mp3_file" ]; then
      echo "Output already exists. Skipping."
    else
      echo 'Done'
      #ffmpeg -nostdin -i "$ogg_file" -ac 2 -ar 44100 -joint_stereo 0 "$mp3_file" -y -loglevel error
      ffmpeg -nostdin -i "$ogg_file" "$mp3_file" -y -loglevel error
    fi
done

echo "Conversion completed."
