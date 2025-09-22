import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_found_app/theme/app_colors.dart';
import 'profile_menu_bubble.dart';

class ProfileMenuButton extends StatefulWidget {
  final VoidCallback onSignOut;
  const ProfileMenuButton({super.key, required this.onSignOut});

  @override
  State<ProfileMenuButton> createState() => _ProfileMenuButtonState();
}

class _ProfileMenuButtonState extends State<ProfileMenuButton> {
  OverlayEntry? _overlayEntry;

  void _showMenu() {
    final RenderBox iconBox = context.findRenderObject() as RenderBox;
    final Offset iconPosition = iconBox.localToGlobal(Offset.zero);
    final Size iconSize = iconBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _hideMenu,
          child: Stack(
            children: [
              Positioned(
                left: iconPosition.dx - 200,
                top: iconPosition.dy + iconSize.height + 8,
                child: Material(
                  color: Colors.transparent,
                  child: ProfileMenuBubble(
                    displayName: FirebaseAuth.instance.currentUser?.displayName ?? '',
                    email: FirebaseAuth.instance.currentUser?.email ?? '-',
                    onSignOut: () {
                      _hideMenu();
                      widget.onSignOut();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showMenu,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Icon(Icons.person, size: 25, color: kLogoLightBlue),
      ),
    );
  }
}