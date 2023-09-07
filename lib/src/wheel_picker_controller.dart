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
  WheelShiftStyle _shiftStyle = WheelPickerStyle.defaultStyle.shiftStyle;

  WheelPickerController({
    required this.itemCount,
    this.initialIndex = 0,
    List<WheelPickerController>? mounts,
  })  : _mounts = mounts ?? [],
        _scrollController =
            FixedExtentScrollController(initialItem: initialIndex),
        _current = initialIndex;

  bool get _hasClients => _scrollController.hasClients;

  void _attach(bool looping, WheelShiftStyle shiftStyle) {
    _looping = looping;
    _shiftStyle = shiftStyle;
  }

  void _update(int index) {
    if (!_hasClients) return;
    _current = index % itemCount;
    final currentCycle = (index / itemCount).floor();
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
    return await _shiftController(this, -1, _shiftStyle);
  }

  Future<void> shiftDown() async {
    if (!_hasClients) return;
    //! Edge
    if (!_looping && _scrollController.selectedItem == itemCount - 1) return;
    return await _shiftController(this, 1, _shiftStyle);
  }

  Future<void> shiftBy({required int steps}) async {
    if (!_hasClients) return;
    return await _shiftController(this, steps, _shiftStyle);
  }

  int getCurrent() => _hasClients ? _current : -1;

  void dispose() => _scrollController.dispose();
}

Future<void> _shiftController(
  WheelPickerController controller,
  int steps,
  WheelShiftStyle shiftStyle,
) async {
  if (!controller._hasClients) return;
  return await controller._scrollController.animateToItem(
    controller._scrollController.selectedItem + steps,
    duration: shiftStyle.duration,
    curve: shiftStyle.curve,
  );
}
