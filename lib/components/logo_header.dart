import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  final String title;

  const LogoHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/logo.png",
          height: 150,
        ),
        SizedBox(height: 8),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

