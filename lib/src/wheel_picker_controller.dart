part of './wheel_picker.dart';

/// Controller for managing and synchronizing `WheelPicker` widgets.
///
/// The `WheelPickerController` allows you to:
/// - Retrieve the selected item index.
/// - Shift the attached `WheelPicker` widget.
/// - Set the current item selected.
/// - Mount additional `WheelPickerController` instances, which will be shifted when looped.
///
/// It provides precise control over scrolling and synchronization of multiple `WheelPicker` widgets.
///
/// To use this controller:
/// - Create an instance of `WheelPickerController`.
/// - Connect it to one or more `WheelPicker` widgets using the `controller` property.
/// - Use its methods to manipulate the selected item index and scrolling behavior.
class WheelPickerController {
  static const _defaultInitialIndex = 0;

  /// The total number of items in the wheel - (can be changed).
  int itemCount;

  /// The initial selected item index.
  final int initialIndex;

  /// A list of `WheelPickerController` instances for shifting when looped.
  final List<WheelPickerController> _mounts;

  /// The scroll controller used for managing scroll behavior.
  FixedExtentScrollController _scrollController;

  /// The current selected item index.
  int _current;

  /// The previous cycle of the wheel (for looped scrolling).
  int _previousCycle = 0;

  /// The animation style used for shifting the wheel.
  WheelShiftAnimationStyle _shiftAnimationStyle = const WheelPickerStyle().shiftAnimationStyle;

  /// Creates a `WheelPickerController` with optional settings.
  ///
  /// Example usage:
  /// ```dart
  /// final controller = WheelPickerController(itemCount: 10, initialIndex: 2);
  /// ```
  ///
  /// Note: Make sure to manually dispose of the controller when it is no longer needed to release associated resources.
  WheelPickerController({
    required this.itemCount,
    this.initialIndex = WheelPickerController._defaultInitialIndex,
    List<WheelPickerController>? mounts,
  })  : _mounts = mounts ?? [],
        _scrollController = FixedExtentScrollController(initialItem: initialIndex),
        _current = initialIndex;

  /// Caps index to be ranging from 0 to `itemCount` - 1
  int _capIndex(int index) => math.min(math.max(index, 0), itemCount - 1);

  /// Wether scroll controller is attached to a mounted widget.
  bool get _hasClients => _scrollController.hasClients;

  /// Attaches the controller's [_scrollController] to a [WheelPicker] widget instance.
  ///
  /// If [_scrollController] `initialItem` differs from [_current], it updates
  /// the scroll controller by replacing it with a new one and disposing of the previous one.
  ///
  /// * This method is intended for internal use by the [WheelPicker] widget.
  void _attach() {
    if (_scrollController.initialItem != _current) {
      _scrollController.dispose();
      _scrollController = FixedExtentScrollController(initialItem: _current);
    }
  }

  /// Updates the shift animation style when the controller is attached during `initState`
  /// or updated during `didUpdateWidget`.
  ///
  /// * This method is intended for internal use by the [WheelPicker] widget.
  void _updateShiftAnimationStyle(WheelShiftAnimationStyle shiftAnimationStyle) {
    _shiftAnimationStyle = shiftAnimationStyle;
  }

  /// Updates the controller with a new selected item index.
  ///
  /// Use this method to update the controller with the latest selected item based on the relative index from given index.
  ///
  /// Checks for optional cycle changes and calls [_shiftMounts] accordingly.
  ///
  /// * This method is intended for internal use by the [WheelPicker] widget.
  void _update(int index) {
    if (!_hasClients) return;
    _current = index % itemCount;
    final currentCycle = (index / itemCount).floor();
    if (_previousCycle != currentCycle) {
      final step = currentCycle > _previousCycle ? VerticalDirection.down : VerticalDirection.up;
      _shiftMounts(step);
      _previousCycle = currentCycle;
    }
  }

  /// Shifts mounted controllers in the specified direction.
  ///
  /// Use this method to shift attached controllers based on the given `direction`.
  ///
  /// * This method is intended for use by the controller itself.
  void _shiftMounts(VerticalDirection direction) {
    final shiftMethod = direction == VerticalDirection.down
        ? (WheelPickerController mount) => mount.shiftDown()
        : (WheelPickerController mount) => mount.shiftUp();

    for (final mount in _mounts) {
      shiftMethod(mount);
    }
  }

  /// Shifts the wheel up by one item.
  ///
  /// If the wheel is not looping and already at the top, this does nothing.
  Future<void> shiftUp() async {
    return await shiftBy(-1);
  }

  /// Shifts the wheel down by one item.
  ///
  /// If the wheel is not looping and already at the bottom, this does nothing.
  Future<void> shiftDown() async {
    return await shiftBy(1);
  }

  /// Shifts the wheel by a specified number of items.
  ///
  /// Parameters:
  /// - `steps`: The number of items to shift. A positive value shifts down, and a negative value shifts up.
  Future<void> shiftBy(int steps) async {
    if (!_hasClients) return;
    return await _shiftController(
      this,
      steps: steps,
      shiftAnimationStyle: _shiftAnimationStyle,
      relativeToCurrent: true,
    );
  }

  /// Shifts the wheel to the specified index.
  ///
  /// Parameters:
  /// - `index`: The item number to jump to ranging from 0 to `itemCount` - 1.
  Future<void> shiftTo(int index) async {
    if (!_hasClients) return;
    return await _shiftController(
      this,
      steps: _capIndex(index),
      shiftAnimationStyle: _shiftAnimationStyle,
      relativeToCurrent: false,
    );
  }

  /// Sets the current item to the specified index.
  ///
  /// Parameters:
  /// - `index`: The item number to jump to ranging from 0 to `itemCount` - 1
  Future<void> setCurrent(int index) async {
    if (!_hasClients) return;
    _jumpController(this, _capIndex(index));
  }

  /// The current selected item index.
  ///
  /// Returns:
  /// - The current selected item index if the controller has clients (attached).
  /// - `-1` if the controller has no clients (not attached).
  int get selected => _hasClients ? _current : -1;

  /// Disposes of the controller and its resources.
  ///
  /// Avoid using the controller after disposing it to prevent unexpected behavior.
  void dispose() => _scrollController.dispose();
}

/// Shifts the controller's scroll position by a specified number of items with animation.
///
/// Parameters:
/// - `controller`: The controller managing the scroll.
/// - `steps`: The number of items to shift. A positive value shifts down, and a negative value shifts up.
/// - `shiftAnimationStyle`: The animation style used for the shift.
///
/// This method ensures the controller has clients before performing the shift animation.
///
/// * Note that this is only supposed to be in the controller scope itself.
Future<void> _shiftController(
  WheelPickerController controller, {
  required int steps,
  required WheelShiftAnimationStyle shiftAnimationStyle,
  required bool relativeToCurrent,
}) async {
  if (!controller._hasClients) return;
  return await controller._scrollController.animateToItem(
    (relativeToCurrent ? controller._scrollController.selectedItem : 0) + steps,
    duration: shiftAnimationStyle.duration,
    curve: shiftAnimationStyle.curve,
  );
}

/// Jumps the controller's scroll position to the item at the given index.
/// Parameters:
/// - `controller`: The controller managing the scroll.
/// - `index`: The item number to jump to ranging from 0 to `itemCount` - 1.
///
/// This method ensures the controller has clients before jumping.
///
/// * Note that this is only supposed to be in the controller scope itself.
Future<void> _jumpController(
  WheelPickerController controller,
  int index,
) async {
  if (!controller._hasClients) return;
  controller._scrollController.jumpToItem(index);
}
