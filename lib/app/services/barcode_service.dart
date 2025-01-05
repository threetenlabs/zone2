// lib/app/services/barcode_service.dart
import 'dart:async';

import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeService {
  late MobileScannerController scannerController;
  StreamSubscription<Object?>? scannerSubscription;

  void initializeScanner(Function(BarcodeCapture) handleBarcode) {
    scannerController = MobileScannerController();
    scannerSubscription = scannerController.barcodes.listen(handleBarcode);
  }

  void dispose() {
    scannerSubscription?.cancel();
    scannerController.dispose();
  }
}
