.PHONY: test, seed, assets

clean:
	flutter clean && flutter pub get

fix:
	dart fix --apply

assets:
	fluttergen

icon:
	dart run flutter_launcher_icons:main

test:
	flutter test

pod:
	cd packages/mobile/ios && pod update

generate:
	flutter pub run build_runner build --delete-conflicting-outputs

mobile:
	flutter run --target lib/main.dart


build-android:
	flutter build appbundle --release --target lib/main.dart      

build-ios:
	flutter build ipa --release --target lib/main.dart --export-options-plist=ios/AppStoreDistributionOptions.plist


debug-keystore:
	keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore

firebaseInit:
	firebase login --reauth && 

firebase-ios: 
	npm install
	npm run firebase:ios

firebase-android:
	npm install
	npm run firebase:android

firebase: firebase-android firebase-ios

beta-android:
	flutter build appbundle --release --target lib/main.dart
	cd packages/mobile/android && fastlane deploy

beta-ios:
	flutter build ipa --release --target lib/main.dart --export-options-plist=ios/AppStoreDistributionOptions.plist
	cd packages/mobile/ios && fastlane deploy
