# Path to your pubspec.yaml file
pubspec_file="pubspec.yaml"

# Check if the file exists
if [ -f "$pubspec_file" ]; then
    # Extract the current version
    current_version=$(awk '/^version:/ {print $2; exit}' "$pubspec_file")
    echo "Current version: $current_version"
    # Check if the version ends with '+number'
    if [[ $current_version =~ \+([0-9]+)$ ]]; then
        current_increment="${BASH_REMATCH[1]}"
        updated_increment=$((current_increment + 1))
        updated_version="${current_version/+${current_increment}/+$updated_increment}"

        # Replace the version in the pubspec.yaml file using awk
        awk -v new_version="$updated_version" '/^version:/ {sub(/^version: .*/, "version: " new_version)} 1' "$pubspec_file" >tmpfile && mv tmpfile "$pubspec_file"

        echo "Version updated from $current_version to $updated_version."
    else
        echo "Version does not end with '+number'. No update performed."
    fi
else
    echo "pubspec.yaml file not found."
fi
