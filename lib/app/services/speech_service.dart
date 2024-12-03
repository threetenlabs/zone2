// lib/app/services/speech_service.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText speech = SpeechToText();
  final isAvailable = false.obs;
  final isListening = false.obs;
  final currentLocaleId = ''.obs;
  final locales = <LocaleName>[].obs;
  final hasError = false.obs;
  final lastError = Rxn<SpeechRecognitionError>();
  final recognizedWords = ''.obs;
  final systemLocale = Rxn<LocaleName>();
  final logger = Get.find<Logger>();

  Future<void> initSpeechState() async {
    try {
      isAvailable.value = await speech.initialize(
        onError: (error) => _onSpeechError(error),
        onStatus: (status) => _onSpeechStatus(status),
        finalTimeout: const Duration(milliseconds: 5000),
      );

      if (isAvailable.value) {
        locales.value = await speech.locales();
        systemLocale.value = await speech.systemLocale();
        currentLocaleId.value = systemLocale.value?.localeId ?? '';
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> startListening() async {
    if (!isAvailable.value || isListening.value) return;

    try {
      await speech.listen(
        onResult: _onSpeechResult,
        listenOptions: SpeechListenOptions(partialResults: true),
        localeId: currentLocaleId.value,
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 5),
      );
      isListening.value = true;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> stopListening() async {
    if (!isListening.value) return;

    try {
      await speech.stop();
      isListening.value = false;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> cancelListening() async {
    if (!isListening.value) return;

    try {
      await speech.cancel();
      isListening.value = false;
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null, reason: 'Error canceling speech recognition');
      logger.e('Error canceling speech recognition: $e');
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    recognizedWords.value = result.recognizedWords;
  }

  void _onSpeechError(SpeechRecognitionError error) {
    hasError.value = true;
    lastError.value = error;
  }

  void _onSpeechStatus(String status) {
    if (status == 'done') {
      isListening.value = false;
    }
  }
}
