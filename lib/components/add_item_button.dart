import 'package:flutter/material.dart';

class AddItemButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddItemButton({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: Colors.grey[200],
      elevation: 0.6,
      child: const Icon(Icons.add, color: Colors.grey, size: 34),
    );
  }
}