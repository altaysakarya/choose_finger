import 'dart:async';
import 'dart:math';

import 'package:choose_game/features/components/tap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PositionObject {
  int id;
  Offset position;
  PositionObject(this.id, this.position);
}

class GameController extends GetxController implements GetxService {
  static GameController get to => Get.find<GameController>();
  static GameController put() => Get.put<GameController>(GameController());
  static bool get isRegistered => Get.isRegistered<GameController>();

  final RxList<PositionObject> _taps = <PositionObject>[].obs;
  List<PositionObject> get taps => _taps.toList();

  final RxInt _selectedIndex = RxInt(-1);
  int get selectedIndex => _selectedIndex.value;

  final Rx<TapState> _tapState = Rx<TapState>(TapState.initial);
  TapState get tapState => _tapState.value;

  final Random _random = Random();
  final Rxn<Timer> _selectionTimer = Rxn<Timer>(null);
  RxInt defaultSeconds = RxInt(5);
  final RxInt _seconds = RxInt(5);
  int get seconds => _seconds.value;

  Worker? _secondWorker;

  bool get isPlaying =>
      _selectionTimer.value != null && _selectionTimer.value!.isActive;
  bool get isCompleted =>
      _selectedIndex.value != -1 && _taps.isNotEmpty && isPlaying;

  final Map<int, Offset> _activePointers = {};

  Map<int, Offset> get activePointers => _activePointers;

  void changeDefaultSeconds(int seconds) {
    defaultSeconds.value = seconds;
    _seconds.value = seconds;
  }

  void handlePointerMove(PointerMoveEvent event) {
    if (_activePointers.containsKey(event.pointer)) {
      _activePointers[event.pointer] = event.position;
      _updateTapsFromActivePointers();
    }
  }

  void handlePointerDown(PointerDownEvent event) {
    _activePointers[event.pointer] = event.position;
    _updateTapsFromActivePointers();
  }

  void handlePointerUp(PointerUpEvent event) {
    _activePointers.remove(event.pointer);
    _updateTapsFromActivePointers();
  }

  void handlePointerCancel(PointerCancelEvent event) {
    _activePointers.remove(event.pointer);
    _updateTapsFromActivePointers();
  }

  void _updateTapsFromActivePointers() {
    _taps.clear();
    int activePointersLength = _activePointers.length;
    _activePointers.forEach((id, position) {
      _taps.add(PositionObject(id, position));
    });

    if (activePointersLength < _activePointers.length) {
      HapticFeedback.selectionClick();
    }

    if (taps.isEmpty) {
      _cancelSelectionTimer();
      _selectedIndex.value = -1;
      _seconds.value = defaultSeconds.value;
    }
    if (taps.length == 1 && !isPlaying) {
      _startSelectionTimer();
    }
  }

  void _startSelectionTimer() {
    _cancelSelectionTimer();
    _startWorker();
    _selectedIndex.value = -1;
    _selectionTimer.value = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_seconds.value > 0) {
        _seconds.value--;
      } else {
        _seconds.value = -1;
        _selectRandomFinger();
      }
    });
  }

  void _cancelSelectionTimer() {
    _selectionTimer.value?.cancel();
    _selectionTimer.value = null;
    _seconds.value = defaultSeconds.value;
  }

  void _selectRandomFinger() {
    if (_taps.isNotEmpty && _selectedIndex.value == -1) {
      _selectedIndex.value = _random.nextInt(_taps.length);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _startWorker();
  }

  void _startWorker() {
    _disposeWorker();
    _secondWorker = ever(_seconds, (int seconds) {
      if (seconds == 0) {
        HapticFeedback.mediumImpact();
        _disposeWorker();
      } else {
        HapticFeedback.lightImpact();
      }
    });
  }

  void _disposeWorker() {
    if (_secondWorker == null) return;
    if (!_secondWorker!.disposed) {
      _secondWorker!.dispose();
      _secondWorker = null;
    }
  }

  @override
  void onClose() {
    _cancelSelectionTimer();
    _disposeWorker();
    super.onClose();
  }
}
