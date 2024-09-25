import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

Future<Uint8List?> convertImageProviderToUint8List(ImageProvider imageProvider) async {
  final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
  final Completer<ui.Image> completer = Completer();
  late ImageStreamListener listener;
  listener = ImageStreamListener((ImageInfo image, bool synchronousCall) {
    final ui.Image img = image.image;
    completer.complete(img);
    stream.removeListener(listener);
  });
  stream.addListener(listener);
  return completer.future.then((img) => _imageToBytes(img));
}

Future<Uint8List?> _imageToBytes(ui.Image image) async {
  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) return null;
  return byteData.buffer.asUint8List();
}

extension ImageProviderExt on ImageProvider {
  Future<Uint8List?> toBytes() => convertImageProviderToUint8List(this);
}
