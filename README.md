<h1 align="center">Zone 2</h1>
<a name="readme-top"></a>
<div align="center">
  <strong>Multi-player mobile gaming platform powered with <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" /> and <img src="https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase" /></strong>
</div>

<br />

<div align="center">
  <sub>Built with ❤︎ by
  <a href="https://www.linkedin.com/in/ryansites/">Ryan Sites</a> and
  <a href="https://www.linkedin.com/in/michael-helfer/">
    Mike Helfer
  </a>
</div>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/threetenlabs/zone2">
    <img src="https://raw.githubusercontent.com/threetenlabs/bedlam-flutter/main/packages/common/lib/assets/images/bedlam.webp?token=GHSAT0AAAAAACQLLOFOQX3PQWMLTOD6DO4SZQZOJ3Q" alt="Logo" width="600" height="300">
  </a>
</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Development Setup](#development-setup)
    - [Android Setup](#android-setup)
    - [Additional Commands](#additional-commands)
- [Roadmap](#roadmap)
- [Additional Links](#additional-links)
- [Troubleshooting](#troubleshooting)

[back to top](#readme-top)

<!-- GETTING STARTED -->

## Getting Started

Instructions to get developer environment set-up.

### Prerequisites

The following is a list of things you need to develop zone2 and how to install them.

- xcode [install](https://developer.apple.com/xcode/)

- android studio [install](https://developer.android.com/studio)
- flutter [install](https://docs.flutter.dev/get-started/install/macos)
- nodejs [install](https://nodejs.org/en/download)

- firebase cli

  ```sh
  curl -sL https://firebase.tools | bash
  ```

- melos

  ```sh
  dart pub global activate melos
  ```

- get_cli

  ```sh
  flutter pub global activate -s git https://github.com/knottx/get_cli.git
  ```

- flutter_gen

  ```sh
  dart pub global activate flutter_gen
  ```

- ensure Pub executables are on your PATH

  ```sh
  export PATH="$PATH":"$HOME/.pub-cache/bin"
  ```

- fastlane

  ```sh
  brew install fastlane
  ```

### Development Setup

Below is an example of how you can instruct your audience on installing and setting up your app. This template doesn't rely on any external dependencies or services.\_

1. Clone the repo

   ```sh
   git clone https://github.com/threetenlabs/bedlam-flutter
   ```

1. Upgrade flutter to the latest

   ```sh
   flutter upgrade
   ```

1. Clean Install All Packages

   ```sh
   make clean
   ```

#### General Commands

1. Run Device Preview

   ```sh
   make preview
   ```

1. Run All Tests

   ```sh
   make test
   ```

1. Dart Fix All

   ```sh
   make fix
   ```

1. Generate Assets

   ```sh
   make asset
   ```

#### Mobile Commands

1. Run mobile

   ```sh
   make mobile
   ```

   or

   ```sh
   make mobile-web
   ```

1. Test mobile

   ```sh
   make mobile-test
   ```

1. Update pods

   ```sh
   make mobile-pod
   ```

1. Clean and pub get

   ```sh
   make mobile-clean
   ```

#### Mecca Commands

1. Run mecca in web browser

   ```sh
   make mecca-web
   ```

1. Run mecca on andorid tv (emulator must be started)

   ```sh
   make mecca-android
   ```

1. Run mecca on mac

   ```sh
   make mecca-mac
   ```

#### Add to .zsh

- export KEY_PASSWORD='our password'
- export STORE_PASSWORD='our password'
- export FASTLANE_USERNAME='threetenlabs email address'
- export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD= App Specific Password from [here](https://appleid.apple.com/account/manage)

#### Additional Commands

> show android debug keystore

```sh
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
```

> show nonprod keystore

nonprod mobile

```sh
keytool -list -v -alias zone2 -keystore ./packages/mobile/bedlam-nonprod.jks
```

nonprod mecca

```sh
keytool -list -v -alias mecca-nonprod -keystore ./packages/mecca/mecca-nonprod.jks
```

> show prod keystore mobile

```sh
keytool -list -v -alias bedlam -keystore ./packages/mobile/bedlam.jks
```

> show prod keystore mecca

```sh
keytool -list -v -alias mecca -keystore ./packages/mecca/mecca.jks
```

> get base64 string of jks

nonprod

```sh
openssl base64 -in ./packages/mobile/bedlam-nonprod.jks
```

prod

```sh
openssl base64 -in ./packages/mobile/bedlam.jks
```

[back to top](#readme-top)

<!-- ROADMAP -->

## Roadmap

See the [open issues](https://github.com/orgs/threetenlabs/projects/2/views/1) for a full list of proposed features (and known issues).

[back to top](#readme-top)

## Additional Links

[Signing apk](https://danielllewellyn.medium.com/flutter-github-actions-for-a-signed-apk-fcdf9878f660)

[Github Actions Flutter](https://blog.logrocket.com/flutter-ci-cd-using-github-actions/)

[Create Service Credential](https://github.com/wzieba/Firebase-Distribution-Github-Action/wiki/FIREBASE_TOKEN-migration#guide-2---the-same-but-with-screenshots)

https://blog.stackademic.com/flutter-extensions-tricks-to-boost-your-productivity-88573b7efc0f

https://medium.com/flutter-community/build-a-custom-bottom-navigation-bar-in-flutter-with-animated-icons-from-rive-13651bc80629

test commit
