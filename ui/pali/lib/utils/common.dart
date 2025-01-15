import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
// import 'package:system_info2/system_info2.dart';

String formatDuration(Duration duration) {
  // Extract minutes and seconds from the duration
  int minutes = duration.inMinutes; // Total minutes
  int seconds = duration.inSeconds % 60; // Remaining seconds after full minutes

  // Format as "mm:ss"
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

Pointer<Char> stringToPointerChar(String string) {
  final units = utf8.encode(string);
  final Pointer<Uint8> result = calloc<Uint8>(units.length + 1);
  final Uint8List nativeString = result.asTypedList(units.length + 1);
  nativeString.setAll(0, units);
  nativeString[units.length] = 0; // Null-terminate
  return result.cast<Char>();
}

/// Returns an empty string if [pointerChar] is [nullptr].
String pointerCharToString(Pointer<Char> pointerChar) {
  if (pointerChar == nullptr) {
    return '';
  }
  try {
    return pointerChar.cast<Utf8>().toDartString();
  } catch (e) {
    // Prevent ex. FormatException: Unexpected extension byte (at offset 8)
    return '';
  }
}

const int megaByte = 1024 * 1024;

bool checkSufficientMemory() {
  return true;
  // return SysInfo.getFreeVirtualMemory() ~/ megaByte >= 2000;
}
