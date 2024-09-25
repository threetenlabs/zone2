import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String confirmText;
  final String cancelText;
  final double? width;
  final TextStyle? textStyle;

  const AppDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.onConfirm,
      required this.onCancel,
      this.confirmText = 'Confirm',
      this.cancelText = 'Cancel',
      this.width = null,
      this.textStyle = null});

  @override
  Widget build(BuildContext context) {
    // get theme from context
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: EdgeInsets.zero,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.brightness == Brightness.dark ? Colors.white : Colors.black)),
              const SizedBox(height: 20),
              Text(content,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: theme.brightness == Brightness.dark ? Colors.white : Colors.black)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: onCancel,
                    child: Text(cancelText),
                  ),
                  ElevatedButton(
                    onPressed: onConfirm,
                    child: Text(confirmText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
