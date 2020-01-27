import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:flutter/services.dart';

Future<UI.Image> loadUiImage(String imageAssetPath) async {
  final ByteData data =
      await rootBundle.load('packages/challenges/' + imageAssetPath);
  final Completer<UI.Image> completer = Completer();
  UI.decodeImageFromList(Uint8List.view(data.buffer), (UI.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}
