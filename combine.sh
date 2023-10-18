#!/bin/bash

output_file="merged-certified-results-august.json"
echo "[" > "$output_file"

# Find all claim.json files recursively within the parent folder
find reports-certified -name "claim.json" | while read -r file; do
    # Extract the folder name
    folder=$(basename "$(dirname "$file")")

    # Extract the "results" value from claim.json
    results=$(jq -r '.claim.results' "$file")

    # Add folder name and "results" value to the output file
    echo "{ \"Operator\": \"$folder\", \"results\": $results }," >> "$output_file"
done

echo "]" >> "$output_file"

echo "Merged results saved to $output_file"

