#!/bin/bash

while getopts p: flag; do
    case "${flag}" in
    p) platform=${OPTARG} ;;
    esac
done

echo "Preparing to deploy to Firebase on platform: ${platform}"

if [[ $platform == "ios" ]]; then
    appId="1:361589238597:ios:6719d6cf4d5c41d8a92c2c"
    project="projects/361589238597/apps/$appId"
    js_return_value=$(node .github/workflows/scripts/latest.js $project)

    if [[ $js_return_value -eq 0 ]]; then
        echo "Could not determine current iOS version."
    else
        echo "The next iOS build version is: $js_return_value"

        pubspec_file="packages/mobile/pubspec.yaml"
        CURRENT_VERSION=$(grep 'version:' $pubspec_file | awk '{print $2}')
        echo "Current Version: $CURRENT_VERSION"
        MAJOR=$(echo $CURRENT_VERSION | cut -d'.' -f1)
        MINOR=$(echo $CURRENT_VERSION | cut -d'.' -f2)
        PATCH=$(echo $CURRENT_VERSION | cut -d'.' -f3 | cut -d'+' -f1)
        updated_version="$MAJOR.$MINOR.$PATCH+$js_return_value"
        awk -v new_version="$updated_version" '/^version:/ {sub(/^version: .*/, "version: " new_version)} 1' "$pubspec_file" >tmpfile && mv tmpfile "$pubspec_file"

        (cd ./packages/mobile && firebase use bedlam-nonprod && flutter build ipa --release --flavor nonprod --target lib/main.dart --export-options-plist=ios/FirebaseDistributionOptions.plist)

        firebase appdistribution:distribute packages/mobile/build/ios/ipa/bedlam.ipa \
            --app $appId \
            --release-notes "Sending $updated_version for internal testing" --groups "alpha"

        git checkout -- "$pubspec_file"
    fi

elif [[ $platform == "android" ]]; then
    appId="1:361589238597:android:0a124b3dc1b5ed23a92c2c"
    project="projects/361589238597/apps/$appId"
    js_return_value=$(node .github/workflows/scripts/latest.js $project)

    if [[ $js_return_value -eq 0 ]]; then
        echo "Could not determine current Android version."
    else
        echo "The next Android build version is: $js_return_value"

        pubspec_file="packages/mobile/pubspec.yaml"
        CURRENT_VERSION=$(grep 'version:' $pubspec_file | awk '{print $2}')
        echo "Current Version: $CURRENT_VERSION"
        MAJOR=$(echo $CURRENT_VERSION | cut -d'.' -f1)
        MINOR=$(echo $CURRENT_VERSION | cut -d'.' -f2)
        PATCH=$(echo $CURRENT_VERSION | cut -d'.' -f3 | cut -d'+' -f1)
        updated_version="$MAJOR.$MINOR.$PATCH+$js_return_value"
        awk -v new_version="$updated_version" '/^version:/ {sub(/^version: .*/, "version: " new_version)} 1' "$pubspec_file" >tmpfile && mv tmpfile "$pubspec_file"

        (cd ./packages/mobile && firebase use bedlam-nonprod && flutter build apk --release --flavor nonprod --target lib/main.dart)

        firebase appdistribution:distribute packages/mobile/build/app/outputs/flutter-apk/app-nonprod-release.apk \
            --app $appId \
            --release-notes "Sending $updated_version for internal testing" --groups "alpha"

        git checkout -- "$pubspec_file"
    fi
fi
