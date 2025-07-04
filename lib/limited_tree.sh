#!/bin/bash

cd ios/

# Remove all build related directories
echo "🗑️ Removing build directories..."
rm -rf build/
rm -rf Pods/
rm -rf .symlinks/
rm -rf Flutter/Flutter.framework/
rm -rf Flutter/Flutter.podspec
rm -rf Flutter/Generated.xcconfig
rm -rf .flutter-plugins
rm -rf .flutter-plugins-dependencies
rm -rf Podfile.lock

# Remove XCode derived data
echo "🗑️ Removing Xcode DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Remove XCode cache
echo "🗑️ Removing Xcode cache..."





# #!/bin/bash

# #run this first  'chmod +x limited_tree.sh'

# # limited_tree.sh - Recursively prints folder structure.
# # At the top level it shows all items, but for subdirectories it limits to 10 items.

# print_tree() {
#   local dir="$1"
#   local prefix="$2"
#   local count=0
#   local total
#   total=$(find "$dir" -maxdepth 1 -mindepth 1 | wc -l)

#   # Determine the limit: top-level (empty prefix) shows all items; subdirectories limit to 10.
#   local limit
#   if [ -z "$prefix" ]; then
#     limit=$total
#   else
#     limit=10
#   fi

#   for item in "$dir"/*; do
#     if [ $count -eq $limit ]; then
#       # Only show the ellipsis if there are more items than the limit
#       if [ "$limit" -lt "$total" ]; then
#         echo "${prefix}└── ... ($(( total - limit )) more items)"
#       fi
#       break
#     fi

#     local connector="├──"
#     # Check if this item is the last to be printed (based on the limit)
#     if [ $(( count + 1 )) -eq $limit ] || { [ $(( count + 1 )) -eq $total ] && [ "$total" -le "$limit" ]; }; then
#       connector="└──"
#     fi

#     if [ -d "$item" ]; then
#       echo "${prefix}${connector} $(basename "$item")/"
#       # Recursively print subdirectories with increased indent
#       print_tree "$item" "    ${prefix}"
#     else
#       echo "${prefix}${connector} $(basename "$item")"
#     fi
#     count=$((count + 1))
#   done
# }

# # Start from the given directory, defaulting to the current directory (e.g. "public")
# start_dir="${1:-.}"
# print_tree "$start_dir" ""