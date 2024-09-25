// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:app/app/audio/sounds.dart';
import 'package:app/app/services/shared_preferences_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

/// Allows playing music and sound. A facade to `package:audioplayers`.
class AudioService {
  static AudioService get to => Get.find();
  static final _log = Get.find<Logger>();

  // final AudioPlayer _musicPlayer;

  /// This is a list of [AudioPlayer] instances which are rotated to play
  /// sound effects.
  final List<AudioPlayer> _sfxPlayers;

  int _currentSfxPlayer = 0;

  final userInteracted = false.obs;

  // final Queue<Song> _playlist;

  final Random _random = Random();

  SharedPreferencesService? _settings;

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  /// Creates an instance that plays music and sound.
  ///
  /// Use [polyphony] to configure the number of sound effects (SFX) that can
  /// play at the same time. A [polyphony] of `1` will always only play one
  /// sound (a new sound will stop the previous one). See discussion
  /// of [_sfxPlayers] to learn why this is the case.
  ///
  /// Background music does not count into the [polyphony] limit. Music will
  /// never be overridden by sound effects because that would be silly.
  AudioService({int polyphony = 2})
      : assert(polyphony >= 1),
        // _musicPlayer = AudioPlayer(playerId: 'musicPlayer'),
        _sfxPlayers = Iterable.generate(polyphony, (i) => AudioPlayer(playerId: 'sfxPlayer#$i'))
            .toList(growable: false) {
    AudioCache.instance.prefix = '';
    // _musicPlayer.onPlayerComplete.listen(_changeSong);
  }

  /// Enables the [AudioService] to listen to [AppLifecycleState] events,
  /// and therefore do things like stopping playback when the game
  /// goes into the background.
  void attachLifecycleNotifier(ValueNotifier<AppLifecycleState> lifecycleNotifier) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  /// Enables the [AudioService] to track changes to settings.
  /// Namely, when any of [SharedPreferencesService.muted],
  /// [SettingsController.musicOn] or [SettingsController.soundsOn] changes,
  /// the audio controller will act accordingly.
  void attachSettings(SharedPreferencesService settingsService) {
    if (_settings == settingsService) {
      // Already attached to this instance. Nothing to do.
      return;
    }
    _settings = settingsService;
    // _settings?.muted.listen((_) => _mutedHandler());
    // _settings?.musicOn.listen((_) => _musicOnHandler());
    _settings?.soundsOnStream.listen((_) => _soundsOnHandler());

    // if (!_settings!.muted.value && _settings!.musicOn.value) {
    //   _startMusic();
    // }
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    // _stopAllSound();
    // _musicPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
  }

  /// Preloads all sound effects.
  Future<void> initialize() async {
    // _log.i('Preloading sound effects');
    // This assumes there is only a limited number of sound effects in the game.
    // If there are hundreds of long sound effect files, it's better
    // to be more selective when preloading.
    final preload = SfxType.values.expand(soundTypeToFilename).map((path) => path).toList();
    AudioCache.instance = AudioCache(prefix: '');
    await AudioCache.instance.loadAll(preload);
  }

  /// Plays a single sound effect, defined by [type].
  ///
  /// The controller will ignore this call when the attached settings'
  /// [SettingsController.muted] is `true` or if its
  /// [SettingsController.soundsOn] is `false`.
  Future playSfx(SfxType type) async {
    // final muted = _settings?.muted.value ?? true;
    if (!userInteracted.value) {
      _log.i(() => 'Ignoring playing sound ($type) because user has NOT interacted with UI first.');
      return;
    }
    final soundsOn = _settings?.isSoundsOn ?? false;
    if (!soundsOn) {
      _log.i(() => 'Ignoring playing sound ($type) because sounds are turned off.');
      return;
    }

    _log.i(() => 'Playing sound: $type');
    final options = soundTypeToFilename(type);
    final filename = options[_random.nextInt(options.length)];
    _log.i(() => '- Chosen filename: $filename');

    final currentPlayer = _sfxPlayers[_currentSfxPlayer];
    currentPlayer.play(AssetSource(filename), volume: soundTypeToVolume(type));
    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
  }

  Future playNtworkSfx(NetworkSfxType type) async {
    // final muted = _settings?.muted.value ?? true;
    if (!userInteracted.value) {
      _log.i(() => 'Ignoring playing sound ($type) because user has NOT interacted with UI first.');
      return;
    }
    final soundsOn = _settings?.isSoundsOn ?? false;
    if (!soundsOn) {
      _log.i(() => 'Ignoring playing sound ($type) because sounds are turned off.');
      return;
    }

    _log.i(() => 'Playing sound: $type');
    // final assetName = soundTypeToAsset(type);

    final currentPlayer = _sfxPlayers[_currentSfxPlayer];
    // final url = await GraphicallFirebaseService.to.getDownloadURL(assetName);
    const url = '';
    _log.i(() => '- Chosen filename: $url');
    currentPlayer.play(UrlSource(url));
    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
  }

  // void _changeSong(void _) {
  //   _log.i('Last song finished playing.');
  //   // Put the song that just finished playing to the end of the playlist.
  //   // _playlist.addLast(_playlist.removeFirst());
  //   // Play the next song.
  //   _playFirstSongInPlaylist();
  // }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      // _stopAllSound();
      case AppLifecycleState.resumed:
      // if (!_settings!.muted.value && _settings!.musicOn.value) {
      //   _resumeMusic();
      // }
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
    }
  }

  // void _musicOnHandler() {
  //   if (_settings!.musicOn.value) {
  //     // Music got turned on.
  //     if (!_settings!.muted.value) {
  //       _resumeMusic();
  //     }
  //   } else {
  //     // Music got turned off.
  //     _stopMusic();
  //   }
  // }

  // void _mutedHandler() {
  //   if (_settings!.muted.value) {
  //     // All sound just got muted.
  //     _stopAllSound();
  //   } else {
  //     // All sound just got un-muted.
  //     if (_settings!.musicOn.value) {
  //       _resumeMusic();
  //     }
  //   }
  // }

  // Future<void> _playFirstSongInPlaylist() async {
  //   _log.i(() => 'Playing ${_playlist.first} now.');
  //   await _musicPlayer.play(AssetSource('music/${_playlist.first.filename}'));
  // }

  // Future<void> _resumeMusic() async {
  //   _log.i('Resuming music');
  //   switch (_musicPlayer.state) {
  //     case PlayerState.paused:
  //       _log.i('Calling _musicPlayer.resume()');
  //       try {
  //         await _musicPlayer.resume();
  //       } catch (e) {
  //         // Sometimes, resuming fails with an "Unexpected" error.
  //         _log.f(e);
  //         await _playFirstSongInPlaylist();
  //       }
  //     case PlayerState.stopped:
  //       _log.i("resumeMusic() called when music is stopped. "
  //           "This probably means we haven't yet started the music. "
  //           "For example, the game was started with sound off.");
  //       await _playFirstSongInPlaylist();
  //     case PlayerState.playing:
  //       _log.w('resumeMusic() called when music is playing. '
  //           'Nothing to do.');
  //     case PlayerState.completed:
  //       _log.w('resumeMusic() called when music is completed. '
  //           "Music should never be 'completed' as it's either not playing "
  //           "or looping forever.");
  //       await _playFirstSongInPlaylist();
  //     default:
  //       _log.w('Unhandled PlayerState: ${_musicPlayer.state}');
  //   }
  // }

  void _soundsOnHandler() {
    for (final player in _sfxPlayers) {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    }
  }

  // void _startMusic() {
  //   _log.i('starting music');
  //   _playFirstSongInPlaylist();
  // }

  // void _stopAllSound() {
  //   if (_musicPlayer.state == PlayerState.playing) {
  //     _musicPlayer.pause();
  //   }
  //   for (final player in _sfxPlayers) {
  //     player.stop();
  //   }
  // }

  // void _stopMusic() {
  //   _log.i('Stopping music');
  //   if (_musicPlayer.state == PlayerState.playing) {
  //     _musicPlayer.pause();
  //   }
  // }
}
