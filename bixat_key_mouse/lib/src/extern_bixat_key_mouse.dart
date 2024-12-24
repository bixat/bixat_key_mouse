import 'dart:ffi';
import 'dart:io' show Platform, Directory;
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

const _libname = "bixat_key_mouse/native";
const _nativeName = "libbixat_key_mouse_rust";

// Define the Dart bindings for the Rust functions
typedef MoveMouseAbsC = Void Function(Int32 x, Int32 y);
typedef MoveMouseAbsDart = void Function(int x, int y);

typedef MoveMouseRelC = Void Function(Int32 x, Int32 y);
typedef MoveMouseRelDart = void Function(int x, int y);

typedef PressMouseButtonC = Void Function(Int32 button);
typedef PressMouseButtonDart = void Function(int button);

typedef ReleaseMouseButtonC = Void Function(Int32 button);
typedef ReleaseMouseButtonDart = void Function(int button);

typedef EnterTextC = Void Function(Pointer<Utf8> text);
typedef EnterTextDart = void Function(Pointer<Utf8> text);

typedef SimulateKeyPressC = Void Function(Pointer<Utf8> key);
typedef SimulateKeyPressDart = void Function(Pointer<Utf8> key);

typedef ReleaseKeyC = Void Function(Pointer<Utf8> key);
typedef ReleaseKeyDart = void Function(Pointer<Utf8> key);

class ExternBixatKeyMouse {
  static String getLibraryPath() {
    var libraryPath =
        path.join(Directory.current.path, _libname, '$_nativeName.so');
    if (Platform.isMacOS) {
      libraryPath =
          path.join(Directory.current.path, _libname, '$_nativeName.dylib');
    } else if (Platform.isWindows) {
      libraryPath = path.join(
          Directory.current.path, _libname, 'Debug', '$_nativeName.dll');
    }
    return libraryPath;
  }

  static final DynamicLibrary _myRustLib =
      DynamicLibrary.open(getLibraryPath());

  // Define the Dart bindings for the Rust functions
  static final MoveMouseAbsDart moveMouseAbs = _myRustLib
      .lookup<NativeFunction<MoveMouseAbsC>>('move_mouse_abs')
      .asFunction();

  static final MoveMouseRelDart moveMouseRel = _myRustLib
      .lookup<NativeFunction<MoveMouseRelC>>('move_mouse_rel')
      .asFunction();

  static final PressMouseButtonDart pressMouseButton = _myRustLib
      .lookup<NativeFunction<PressMouseButtonC>>('press_mouse_button')
      .asFunction();

  static final ReleaseMouseButtonDart releaseMouseButton = _myRustLib
      .lookup<NativeFunction<ReleaseMouseButtonC>>('release_mouse_button')
      .asFunction();

  static final EnterTextDart enterText =
      _myRustLib.lookup<NativeFunction<EnterTextC>>('enter_text').asFunction();

  static final SimulateKeyPressDart simulateKeyPress = _myRustLib
      .lookup<NativeFunction<SimulateKeyPressC>>('simulate_key')
      .asFunction();

  static final ReleaseKeyDart releaseKey = _myRustLib
      .lookup<NativeFunction<ReleaseKeyC>>('release_key')
      .asFunction();
}
