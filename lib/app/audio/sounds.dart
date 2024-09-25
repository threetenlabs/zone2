// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:app/gen/assets.gen.dart';

List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.huhsh:
      return [
        CommonAssets.audio.sfx.hash1,
        CommonAssets.audio.sfx.hash2,
        CommonAssets.audio.sfx.hash3,
      ];
    case SfxType.wssh:
      return [
        CommonAssets.audio.sfx.wssh1,
        CommonAssets.audio.sfx.wssh2,
        CommonAssets.audio.sfx.dsht1,
        CommonAssets.audio.sfx.ws1,
        CommonAssets.audio.sfx.spsh1,
        CommonAssets.audio.sfx.hh1,
        CommonAssets.audio.sfx.hh2,
        CommonAssets.audio.sfx.kss1,
      ];
    case SfxType.buttonTap:
      return [
        CommonAssets.audio.sfx.k1,
        CommonAssets.audio.sfx.k2,
        CommonAssets.audio.sfx.p1,
        CommonAssets.audio.sfx.p2,
      ];
    case SfxType.congrats:
      return [
        CommonAssets.audio.sfx.yay1,
        CommonAssets.audio.sfx.wehee1,
        CommonAssets.audio.sfx.oo1,
      ];
    case SfxType.erase:
      return [
        CommonAssets.audio.sfx.fwfwfwfwfw1,
        CommonAssets.audio.sfx.fwfwfwfw1,
      ];
    case SfxType.swishSwish:
      return [
        CommonAssets.audio.sfx.swishswish1,
      ];
  }
}

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.huhsh:
      return 0.4;
    case SfxType.wssh:
      return 0.2;
    case SfxType.buttonTap:
    case SfxType.congrats:
    case SfxType.erase:
    case SfxType.swishSwish:
      return 1.0;
  }
}

enum SfxType {
  huhsh,
  wssh,
  buttonTap,
  congrats,
  erase,
  swishSwish,
}

enum NetworkSfxType {
  foghorn,
}

String soundTypeToAsset(NetworkSfxType type) {
  switch (type) {
    case NetworkSfxType.foghorn:
      return 'assets/sounds/foghorn.mp3';
  }
}
