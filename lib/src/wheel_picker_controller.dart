import 'package:flutter/material.dart';
import './wheel_picker_style.dart';

part './wheel_picker.dart';

class WheelPickerController {
  final int itemCount;
  final int initialIndex;

  final List<WheelPickerController> _mounts;
  final FixedExtentScrollController _scrollController;
  int _current;
  int _previousCycle = 0;
  bool _looping = true;

  WheelPickerController({
    required this.itemCount,
    this.initialIndex = 0,
    List<WheelPickerController>? mounts,
  })  : _mounts = mounts ?? [],
        _scrollController =
            FixedExtentScrollController(initialItem: initialIndex),
        _current = initialIndex;

  bool get _hasClients => _scrollController.hasClients;

  void _attach(bool looping) {
    _looping = looping;
  }

  void _update(int value) {
    if (!_hasClients) return;
    _current = value % itemCount;
    final currentCycle = (value / itemCount).floor();
    if (_previousCycle != currentCycle) {
      final step = currentCycle > _previousCycle
          ? VerticalDirection.down
          : VerticalDirection.up;
      _shiftMounts(step);
      _previousCycle = currentCycle;
    }
  }

  void _shiftMounts(VerticalDirection direction) {
    if (direction == VerticalDirection.down) {
      for (final mount in _mounts) {
        mount.shiftDown();
      }
    } else {
      for (final mount in _mounts) {
        mount.shiftUp();
      }
    }
  }

  Future<void> shiftUp() async {
    if (!_hasClients) return;
    //! Edge
    if (!_looping && _scrollController.selectedItem == 0) return;
    return await _shiftController(this, -1);
  }

  Future<void> shiftDown() async {
    if (!_hasClients) return;
    //! Edge
    if (!_looping && _scrollController.selectedItem == itemCount - 1) return;
    return await _shiftController(this, 1);
  }

  Future<void> shiftBy({required int steps}) async {
    if (!_hasClients) return;
    return await _shiftController(this, steps);
  }

  int getCurrent() => _hasClients ? _current : -1;

  void dispose() => _scrollController.dispose();
}

Future<void> _shiftController(
  WheelPickerController controller,
  int steps,
) async {
  if (!controller._hasClients) return;
  return await controller._scrollController.animateToItem(
    controller._scrollController.selectedItem + steps,
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeInOut,
  );
}
