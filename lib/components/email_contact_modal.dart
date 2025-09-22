import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';

class EmailContactModal extends StatelessWidget {
  final String email;
  const EmailContactModal({super.key, required this.email});

  Future<void> _sendEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Lost & Found контакт',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Не може да се отвори емаил клиент.")),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Контактирај го пријавувачот"),
      content: Text("Email: $email"),
      actions: [
        TextButton(
          onPressed: () => _sendEmail(context),
          child: const Text(
            "Испрати Email",
            style: TextStyle(color: kLogoDarkBlue),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            "Откажи",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}