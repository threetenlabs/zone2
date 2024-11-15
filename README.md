<h1 align="center">Zone 2</h1>

<a name="readme-top"></a>

<div align="center">
  <strong>Democrotized weight loss tracking application</strong>
  <br />
  <div style="display: flex; justify-content: center; align-items: center;">
    <span style="width: 120px; text-align: right;">Built with :</span>
    <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" style="margin-left: 5px;" />
  </div>
  <div style="display: flex; justify-content: center; align-items: center;">
    <span style="width: 120px; text-align: right;">Powered by:</span>
    <img width="30" src="https://lh3.googleusercontent.com/F_PEyEw8W6BPzpIj8MlmIZFgW5HqfdFqIxCB3_RDiamJA3hNg7GDJ6YZThPngXXz5nOXWlCcoUuAUaZF1ZbkX6TEUtGCZMWh0YQRcgX20rSf2E_04OMB=e30" style="margin-left: 5px;" />
  </div>
  <div style="display: flex; justify-content: center; align-items: center;">
    <span style="width: 120px; text-align: right;">And :</span>
    <img width="30" src="https://developer.apple.com/assets/elements/icons/healthkit/healthkit-96x96_2x.png" style="margin-left: 5px;" />
  </div>
</div>

<br />

<div align="center">
  <sub>Built with ❤︎ by
  <a href="https://github.com/threetenlabs">ThreeTen Labs</a>
</div>

<!-- vscode-markdown-toc -->

- [🚀 Getting Started with Zone 2](#GettingStartedwithZone2)
  - [Prerequisites](#Prerequisites)
    - [Test Mock Generator](#TestMockGenerator)
  - [Development Setup](#DevelopmentSetup)
    - [General Commands](#GeneralCommands)
    - [Mobile Commands](#MobileCommands)
    - [Mecca Commands](#MeccaCommands)
    - [Add to .zsh](#Addto.zsh)
    - [Additional Commands](#AdditionalCommands)
  - [💫 Support](#Support)
  - [Roadmap](#Roadmap)
- [📌 License](#License)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

<!-- GETTING STARTED -->

## <a name='GettingStartedwithZone2'></a>🚀 Getting Started with Zone 2

Instructions to get developer environment set-up.

### <a name='Prerequisites'></a>Prerequisites

The following is a list of things you need to develop zone2 and how to install them.

- xcode [install](https://developer.apple.com/xcode/)
- android studio [install](https://developer.android.com/studio)
- flutter [install](https://docs.flutter.dev/get-started/install/macos)

#### <a name='TestMockGenerator'></a>Test Mock Generator

- flutter_gen

  ```sh
  dart pub global activate flutter_gen
  ```

### <a name='DevelopmentSetup'></a>Development Setup

1. Clone the repo

   ```sh
   git clone https://github.com/threetenlabs/zone2
   ```

1. Clean Install All Packages

   ```sh
   make clean
   ```

#### <a name='GeneralCommands'></a>General Commands

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

#### <a name='MobileCommands'></a>Mobile Commands

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

#### <a name='MeccaCommands'></a>Mecca Commands

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

#### <a name='Addto.zsh'></a>Add to .zsh

- export KEY_PASSWORD='ThreeTen Labs Password'
- export STORE_PASSWORD='ThreeTen Labs Password'
- export FASTLANE_USERNAME='threetenlabs email address'
- export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD= App Specific Password from [here](https://appleid.apple.com/account/manage)

#### <a name='AdditionalCommands'></a>Additional Commands

> get base64 string of jks

prod

```sh
openssl base64 -in ./packages/mobile/zone2.jks
```

[back to top](#readme-top)

### <a name='Support'></a>💫 Support

<!-- SUPPORT -->

### <a name='Roadmap'></a>Roadmap

<!-- ROADMAP -->

See the [roadmap](https://github.com/orgs/threetenlabs/projects/3/views/1) for a full list of proposed features (and known issues).

[back to top](#readme-top)

Reach out to the maintainers at one of the following places:

- [GitHub Discussions](https://github.com/boxyhq/jackson/discussions)
- [GitHub Issues](https://github.com/boxyhq/jackson/issues)
- [Discord](https://discord.gg/uyb7pYt4Pa)

## <a name='License'></a>📌 License

[GPLv3](https://github.com/threetenlabs/zone2/blob/main/LICENSE.txt)
