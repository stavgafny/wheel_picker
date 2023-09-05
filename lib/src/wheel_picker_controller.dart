import 'package:flutter/material.dart';
import './wheel_picker_style.dart';

part './item_wheel_picker.dart';

class WheelPickerController {
  final int initialIndex;
  final WheelPickerController? mount;
  _AttachedWheelPickerController? _attachment;
  WheelPickerController({
    this.initialIndex = 0,
    this.mount,
  });

  bool get isAttached => _attachment != null;

  void dispose() => _attachment?.dispose();

  FixedExtentScrollController _getScrollController() =>
      _attachment?._controller ?? FixedExtentScrollController();

  void _attach<T>(List<T> items, bool looping) {
    assert(!isAttached, "controller can't have multiple attachedment");
    _attachment = _AttachedWheelPickerController<T>(
      items,
      looping,
      mount?._attachment,
      initialIndex,
    );
  }
}

class _AttachedWheelPickerController<T> {
  final List<T> items;
  final bool looping;
  final _AttachedWheelPickerController? attachedMount;

  int _previousCycle = 0;

  final FixedExtentScrollController _controller;
  _AttachedWheelPickerController(
    this.items,
    this.looping,
    this.attachedMount,
    int initialIndex,
  ) : _controller = FixedExtentScrollController(initialItem: initialIndex) {
    _controller.addListener(_onUpdate);
  }

  bool get _hasClients => _controller.hasClients;

  void _onUpdate() {
    if (!_hasClients) return;
    final currentCycle = (_controller.selectedItem / items.length).floor();
    if (currentCycle != _previousCycle) {
      currentCycle > _previousCycle
          ? attachedMount?._shiftDown()
          : attachedMount?._shiftUp();
      _previousCycle = currentCycle;
    }
  }

  void _animateFromCurrent(int step) {
    if (!_hasClients) return;
    _controller.animateToItem(
      _controller.selectedItem + step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _shiftUp() {
    if (!looping && _controller.selectedItem == 0) return;
    _animateFromCurrent(-1);
  }

  void _shiftDown() {
    if (!looping && _controller.selectedItem == items.length - 1) return;
    _animateFromCurrent(1);
  }

  void dispose() {
    _controller.dispose();
  }
}
