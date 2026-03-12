import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _lastWords = '';
  Function(String)? onResult;
  Function(bool)? onStatusChange;

  Future<bool> initialize() async {
    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
          _isListening = status == 'listening';
          onStatusChange?.call(_isListening);
        },
        onError: (error) {
          print('语音识别错误：${error.errorMsg}');
          _isListening = false;
          onStatusChange?.call(false);
        },
      );
      return available;
    } catch (e) {
      print('初始化失败：$e');
      return false;
    }
  }

  void startListening({Function(String)? onPartialResult}) {
    if (_isListening) return;
    
    _lastWords = '';
    _speech.listen(
      onResult: (SpeechRecognitionResult result) {
        _lastWords = result.recognizedWords;
        onResult?.call(_lastWords);
        onPartialResult?.call(_lastWords);
      },
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 3),
      partialResults: true,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
    
    _isListening = true;
    onStatusChange?.call(true);
  }

  void stopListening() {
    if (!_isListening) return;
    _speech.stop();
    _isListening = false;
    onStatusChange?.call(false);
  }

  bool get isListening => _isListening;
  String get lastWords => _lastWords;
}
