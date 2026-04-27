import 'dart:async';
import 'package:flutter/material.dart';

class FocusViewModel extends ChangeNotifier {
  // =========================================
  // 1. LOGIC HẸN GIỜ (COUNTDOWN)
  // =========================================
  Duration countdownDuration = const Duration(minutes: 25);
  Duration countdownRemaining = const Duration(minutes: 25);
  Timer? _countdownTimer;
  bool isCountdownRunning = false;
  String countdownLabel = 'Hẹn giờ';

  void setCountdownDuration(Duration duration) {
    countdownDuration = duration;
    countdownRemaining = duration;
    notifyListeners();
  }

  void setCountdownLabel(String label) {
    countdownLabel = label.isEmpty ? 'Hẹn giờ' : label;
    notifyListeners();
  }

  void toggleCountdown() {
    if (isCountdownRunning) {
      isCountdownRunning = false;
      _countdownTimer?.cancel();
    } else {
      if (countdownRemaining.inSeconds == 0) return;
      isCountdownRunning = true;
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdownRemaining.inSeconds > 0) {
          countdownRemaining -= const Duration(seconds: 1);
        } else {
          isCountdownRunning = false;
          _countdownTimer?.cancel();
        }
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void cancelCountdown() {
    isCountdownRunning = false;
    _countdownTimer?.cancel();
    countdownRemaining = countdownDuration; 
    notifyListeners();
  }

  // =========================================
  // 2. LOGIC BẤM GIỜ (STOPWATCH)
  // =========================================
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _stopwatchTimer;
  Duration stopwatchElapsed = Duration.zero;
  bool isStopwatchRunning = false;

  void toggleStopwatch() {
    if (isStopwatchRunning) {
      _stopwatch.stop();
      _stopwatchTimer?.cancel();
      isStopwatchRunning = false;
    } else {
      _stopwatch.start();
      isStopwatchRunning = true;
      _stopwatchTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
        stopwatchElapsed = _stopwatch.elapsed;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void resetStopwatch() {
    _stopwatch.stop();
    _stopwatch.reset();
    _stopwatchTimer?.cancel();
    isStopwatchRunning = false;
    stopwatchElapsed = Duration.zero;
    notifyListeners();
  }
}