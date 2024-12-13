#!/bin/bash

# Get the function name from argument, remove any quotes
current_function=$1
current_workspace=$PWD

if [ -z "$current_function" ]; then
  echo "Error: no argument was passed"
  exit 1
fi

find_reference() {
  local search_path="$1"
  local path_to_ignore="$2" # on the "second call" we would want to ignore the folder that was already searched for.
  # Find the file that exports this function ignoring node_modules, dist, cdk.out, and .git
  found_reference=$(grep -r -n -E --exclude-dir={node_modules,dist,cdk.out,.git,package.,typings,${path_to_ignore}} "export\s+(const|enum|function|class|type|interface|\* as)\s+$current_function\b" "$search_path" | cut -d: -f1,2)
  echo "$found_reference"
}

find_reference $current_workspace

if [ -z "$found_reference" ]; then
  find_reference $(cd .. && pwd) $current_workspace
fi

cursor --goto $found_reference
