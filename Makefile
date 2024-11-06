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
	cd ios && pod update

generate:
	dart run build_runner clean
	dart run build_runner build --delete-conflicting-outputs

mobile: generate
	flutter run --target lib/main.dart

build-android: generate
	flutter build appbundle --release --target lib/main.dart      

build-ios: generate
	flutter build ipa --release --target lib/main.dart --export-options-plist=ios/AppStoreDistributionOptions.plist

debug-keystore:
	keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore

zone2-keystore:
	keytool -list -v -alias zone2 -keystore ./zone2.jks
