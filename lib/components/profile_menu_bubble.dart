import 'package:flutter/material.dart';

class ProfileMenuBubble extends StatelessWidget {
  final String displayName;
  final String email;
  final VoidCallback onSignOut;

  const ProfileMenuBubble({
    super.key,
    required this.displayName,
    required this.email,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 240,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.star, color: Colors.grey),
              title: Text(displayName, style: const TextStyle(fontWeight: FontWeight.w400)),
              subtitle: Text(email, style: const TextStyle(fontSize: 13)),
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.logout, size: 22),
              title: const Text('Одјави се'),
              onTap: onSignOut,
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            ),
          ],
        ),
      ),
    );
  }
}