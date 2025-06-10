import 'package:flutter/material.dart';
import 'dart:async';

class SuccessDialog extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback? onClose;
  final int autoDismissSeconds;
  final VoidCallback? onDismiss;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.onClose,
    this.autoDismissSeconds = 2,
    this.onDismiss,
  });

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Auto dismiss after specified seconds
    if (widget.autoDismissSeconds > 0) {
      _timer = Timer(Duration(seconds: widget.autoDismissSeconds), _handleDismiss);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleDismiss() {
    if (mounted) {
      Navigator.of(context).pop();
      if (widget.onDismiss != null) {
        widget.onDismiss!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFAFDCDD),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  if (widget.onClose != null) {
                    widget.onClose!();
                  }
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black87,
                  size: 24,
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.check_circle,
                  color: const Color(0xFF8EE08B),
                  size: 60,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Title
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Message
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Helper function to show the success dialog
Future<void> showSuccessDialog({
  required BuildContext context,
  required String title,
  required String message,
  VoidCallback? onClose,
  int autoDismissSeconds = 2,
  VoidCallback? onDismiss,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SuccessDialog(
        title: title,
        message: message,
        onClose: onClose,
        autoDismissSeconds: autoDismissSeconds,
        onDismiss: onDismiss,
      );
    },
  );
} 