class BixatKeyMouse {
  static void moveMouseAbs({required int x, required int y}) =>
      moveMouseAbs(x: x, y: y);

  static void moveMouseRel({required int x, required int y}) =>
      moveMouseRel(x: x, y: y);

  static void pressMouseButton({required int button}) =>
      pressMouseButton(button: button);

  static void releaseMouseButton({required int button}) =>
      releaseMouseButton(button: button);

  static void enterText({required String text}) => enterText(text: text);

  static void simulateKey({required String key}) => simulateKey(key: key);

  static void releaseKey({required String key}) => releaseKey(key: key);
}
