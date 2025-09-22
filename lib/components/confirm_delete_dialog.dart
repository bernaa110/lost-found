import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        "Избриши предмет",
        style: TextStyle(color: kLogoDarkBlue),
      ),
      content: const Text(
        "Дали сте сигурни дека сакате да го избришете предметот?",
        style: TextStyle(color: kLogoDarkBlue),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            "Откажи",
            style: TextStyle(color: kLogoLightBlue),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            "Избриши",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
