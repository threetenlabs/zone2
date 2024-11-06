import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';

class ScannedBarcodeLabel extends GetWidget<DiaryController> {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
  });

  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return Column(
            children: [
              Text(
                controller.barcode.value?.displayValue ?? 'Scan a barcode to add to your meal',
                overflow: TextOverflow.fade,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          );
        }

        return Text(
          scannedBarcodes.first.displayValue ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}
