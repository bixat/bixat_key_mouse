enum KeyModifier {
  shift,
  control,
  alt,
  meta,
  command,
  windows,
  superKey,
  backspace,
  tab,
  enter,
  escape,
  space,
  pageUp,
  pageDown,
  end,
  home,
  leftArrow,
  upArrow,
  rightArrow,
  downArrow,
  insert,
  delete,
  f1,
  f2,
  f3,
  f4,
  f5,
  f6,
  f7,
  f8,
  f9,
  f10,
  f11,
  f12,
  numLock,
  scrollLock,
  capsLock,
  printScreen,
  pause,
  clear,
  menu;

  @override
  String toString() {
    final name = super.toString().split('.').last;
    return name[0].toUpperCase() + name.substring(1);
  }
}

enum MouseButton {
  left,
  middle,
  right,
  back,
  forward,
  scrollUp,
  scrollDown,
  scrollLeft,
  scrollRight,
}
