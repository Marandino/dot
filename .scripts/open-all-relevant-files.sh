#!/bin/bash

# If a file is passed as an argument, use that
current_file="$1"
echo "Using file path passed as an argument: $current_file"
echo "Finding imports in current file..."

# Create a temporary file to store the processed imports
temp_file=$(mktemp)

# First, capture multiline imports into single lines
awk '
    /^import.*{/ { 
        printf "%s", $0
        in_block=1
        next
    }
    in_block { 
        gsub(/^[ \t]+/, "")  # Remove leading whitespace
        printf " %s", $0
        if (/}/) {
            in_block=0
            print ""
        }
        next
    }
    /^import/ {
        print
    }
' "$current_file" >"$temp_file"

# Now extract the imported names
imports=$(grep -E "^import" "$temp_file" |
  sed -E '
        # Handle destructured imports like: import { x, y } from ...
        s/import[[:space:]]*{([^}]*)}.*$/\1/;
        # Handle default imports like: import x from ...
        s/import[[:space:]]+([^{][^ ]*)[[:space:]]+from.*$/\1/;
        # Clean up whitespace and commas
        s/,/ /g;
        s/[[:space:]]+/ /g;
        s/^[[:space:]]*//;
        s/[[:space:]]*$//
    ' | tr ' ' '\n' | sort -u)

# Get the workspace root (assuming we're in a git repository)
workspace_root=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")

#For each import, find files that export it
while IFS= read -r import_name; do
  if [ -n "$import_name" ]; then
    echo "Looking for exports of '$import_name'..."
    # Use recursive grep to search for exports
    grep -r -n -E --exclude-dir={node_modules,dist,cdk.out,.git} "export\s+(const|enum|function|class|type|interface)\s+$import_name\b" . | cut -d: -f1,2 | while read -r file_and_line; do
      if [ -n "$file_and_line" ]; then
        cursor --goto "$file_and_line"
      fi
    done
  else
    echo "  No files found"
  fi
done <<<"$imports"

# Clean up
rm "$temp_file"
