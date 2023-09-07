import 'package:flutter/material.dart';
import './wheel_picker_style.dart';

part './wheel_picker.dart';

class WheelPickerController {
  final int itemCount;
  int initialIndex;
  final WheelPickerController? mount;

  _AttachedWheelPickerController? _attachment;

  WheelPickerController({
    required this.itemCount,
    this.initialIndex = 0,
    this.mount,
  });

  bool get _isAttached => _attachment != null;

  FixedExtentScrollController? _getScrollController() =>
      _attachment?._controller;

  void _attach(bool looping) {
    assert(!_isAttached, "controller can't have multiple attachments");
    assert(mount?._isAttached != false,
        "mounted controller must be attached before attaching, try arranging the order in which they are built");
    _attachment = _AttachedWheelPickerController(
      itemCount,
      looping,
      mount?._attachment,
      initialIndex,
    );
  }

  int get selected => _attachment?.getCurrent() ?? -1;

  void _disposeAttachment() {
    _attachment?.dispose();
    _attachment = null;
  }
}

class _AttachedWheelPickerController {
  final int itemCount;
  final bool looping;
  final _AttachedWheelPickerController? attachedMount;

  int _previousCycle = 0;

  final FixedExtentScrollController _controller;

  _AttachedWheelPickerController(
    this.itemCount,
    this.looping,
    this.attachedMount,
    int initialIndex,
  ) : _controller = FixedExtentScrollController(initialItem: initialIndex) {
    if (looping && attachedMount != null) {
      _controller.addListener(_onLoopShiftMount);
    }
  }

  bool get _hasClients => _controller.hasClients;

  void _onLoopShiftMount() {
    if (!_hasClients) return;
    final currentCycle = (_controller.selectedItem / itemCount).floor();
    if (currentCycle != _previousCycle) {
      currentCycle > _previousCycle
          ? attachedMount?._shiftDown()
          : attachedMount?._shiftUp();
      _previousCycle = currentCycle;
    }
  }

  void _shiftUp() {
    if (!looping && _controller.selectedItem == 0) return; //! Edge
    _animateFromCurrent(-1);
  }

  void _shiftDown() {
    if (!looping && _controller.selectedItem == itemCount - 1) return; //! Edge
    _animateFromCurrent(1);
  }

  void _animateFromCurrent(int step) {
    if (!_hasClients) return;
    _controller.animateToItem(
      _controller.selectedItem + step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  int getCurrent() => _hasClients ? _controller.initialItem : -1;

  void dispose() {
    _controller.removeListener(_onLoopShiftMount);
    _controller.dispose();
  }
}
