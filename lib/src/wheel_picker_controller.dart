import 'package:flutter/material.dart';
import './wheel_picker_style.dart';

part './wheel_picker.dart';

class WheelPickerController {
  final int itemCount;
  final int initialIndex;
  final WheelPickerController? mount;

  final FixedExtentScrollController _scrollController;
  _WheelPickerControllerAttachment? _attachment;

  WheelPickerController({
    required this.itemCount,
    this.initialIndex = 0,
    this.mount,
  }) : _scrollController =
            FixedExtentScrollController(initialItem: initialIndex);

  bool get isAttached => _attachment != null;

  int get selected => _attachment?.getCurrent() ?? -1;

  Future<int> shiftUp() async {
    await _attachment?._shiftUp();
    return selected;
  }

  Future<int> shiftDown() async {
    await _attachment?._shiftDown();
    return selected;
  }

  FixedExtentScrollController? _getScrollController() =>
      _attachment?._controller;

  void _attach(bool looping) {
    assert(!isAttached, "controller can't have multiple attachments");
    assert(mount?.isAttached != false,
        "mounted controller must be attached before attaching, try arranging the order in which they are built");
    _attachment = _WheelPickerControllerAttachment(
      _scrollController,
      itemCount,
      looping,
      mount?._attachment,
    );
  }

  void dispose() {
    _attachment?.disposeAttachment();
    _scrollController.dispose();
  }
}

class _WheelPickerControllerAttachment {
  final int itemCount;
  final bool looping;
  final _WheelPickerControllerAttachment? attachedMount;

  int _previousCycle = 0;

  final FixedExtentScrollController _controller;

  _WheelPickerControllerAttachment(
    this._controller,
    this.itemCount,
    this.looping,
    this.attachedMount,
  ) {
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

  Future<void> _shiftUp() async {
    if (!looping && _controller.selectedItem == 0) return; //! Edge
    return await _animateFromCurrent(-1);
  }

  Future<void> _shiftDown() async {
    if (!looping && _controller.selectedItem == itemCount - 1) return; //! Edge
    return await _animateFromCurrent(1);
  }

  Future<void> _animateFromCurrent(int step) async {
    if (!_hasClients) return;
    return await _controller.animateToItem(
      _controller.selectedItem + step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  int? getCurrent() => _hasClients ? _controller.selectedItem : null;

  void disposeAttachment() {
    _controller.removeListener(_onLoopShiftMount);
  }
}
