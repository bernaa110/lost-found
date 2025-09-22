import 'package:flutter/material.dart';

class CasButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CasButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Color(0xFFF2F3F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Image.asset(
              "assets/cas_icon.png",
              width: 23,
              height: 23,
            ),
            SizedBox(width: 12),
            Text(
              "Central Authentication System",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}