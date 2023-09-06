import 'package:flutter/material.dart';
import './wheel_picker_style.dart';

part './wheel_picker.dart';

class PickedItem<T> {
  final T item;
  final int index;

  const PickedItem(this.item, this.index);

  @override
  String toString() => 'PickedItem(item: $item, index: $index)';
}

class WheelPickerController<T> {
  final List<T> items;
  final int initialIndex;
  final WheelPickerController? mount;

  _AttachedWheelPickerController? _attachment;

  WheelPickerController({
    required this.items,
    this.initialIndex = 0,
    this.mount,
  });

  bool get isAttached => _attachment != null;

  PickedItem? get current {
    final T? item = _attachment?.getCurrentItem();
    final int? index = _attachment?.getCurrentIndex();
    if (item == null || index == null) return null;
    return PickedItem(item, index);
  }

  void dispose() => _attachment?.dispose();

  FixedExtentScrollController? _getScrollController() =>
      _attachment?._controller;

  void _attach(bool looping) {
    assert(!isAttached, "controller can't have multiple attachments");
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
    if (looping && attachedMount != null) {
      _controller.addListener(_onLoopShiftMount);
    }
  }

  bool get _hasClients => _controller.hasClients;

  int get _range => items.length;

  void _onLoopShiftMount() {
    if (!_hasClients) return;
    final currentCycle = (_controller.selectedItem / _range).floor();
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
    if (!looping && _controller.selectedItem == _range - 1) return;
    _animateFromCurrent(1);
  }

  int? getCurrentIndex() =>
      _hasClients ? _controller.selectedItem % _range : null;

  T? getCurrentItem() => items.elementAtOrNull(getCurrentIndex() ?? _range);

  void dispose() {
    _controller.removeListener(_onLoopShiftMount);
    _controller.dispose();
  }
}
