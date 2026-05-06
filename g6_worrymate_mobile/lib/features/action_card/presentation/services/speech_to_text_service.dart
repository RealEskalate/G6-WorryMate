import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isAvailable = false;
  bool _isListening = false;

  Future<bool> init() async {
    _isAvailable = await _speech.initialize();
    print('[SpeechToTextService] Initialized: $_isAvailable');
    return _isAvailable;
  }

  bool get isAvailable => _isAvailable;
  bool get isListening => _isListening;

  Future<void> listen({
    required Function(String recognizedText) onResult,
    String localeId = 'en_US',
  }) async {
    if (!_isAvailable) {
      print('[SpeechToTextService] Not available.');
      return;
    }
    _isListening = true;
    print('[SpeechToTextService] Listening...');
    await _speech.listen(
      onResult: (result) {
        print(
          '[SpeechToTextService] onResult: ${result.recognizedWords}, final: ${result.finalResult}',
        );
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: localeId,
      listenMode: stt.ListenMode.confirmation,
    );
  }

  Future<void> stop() async {
    if (!_isListening) return;
    await _speech.stop();
    _isListening = false;
    print('[SpeechToTextService] Stopped listening.');
  }

  Future<void> cancel() async {
    if (!_isListening) return;
    await _speech.cancel();
    _isListening = false;
    print('[SpeechToTextService] Cancelled listening.');
  }
}
