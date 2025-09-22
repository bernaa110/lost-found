import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/potentional_matches_accordion.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import '../services/user_service.dart';
import '../components/email_contact_modal.dart';
import '../components/confirm_delete_dialog.dart';
import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';
import 'item_form_modal.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Item item;
  const ItemDetailsScreen({super.key, required this.item});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late Item _item;
  late bool _handover;
  bool _updatingHandover = false;
  bool _emailLoading = false;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _handover = _item.handover;
  }

  Future<void> _updateHandover(bool value) async {
    setState(() => _updatingHandover = true);
    await ItemService.updateHandover(_item.id, value);
    setState(() {
      _handover = value;
      _item = _item.copyWith(handover: value);
      _updatingHandover = false;
    });
  }

  Future<void> _showContactDialog(BuildContext context) async {
    setState(() => _emailLoading = true);
    final email = await UserService.fetchUserEmail(_item.createdBy);
    setState(() => _emailLoading = false);
    showDialog(
      context: context,
      builder: (_) => EmailContactModal(
        email: email ?? 'unknown@email.com',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isOwner = user != null && user.uid == _item.createdBy;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: kLogoDarkBlue),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: _ItemDetailsContent(
              item: _item,
              handover: _handover,
              updatingHandover: _updatingHandover,
              isOwner: isOwner,
              onEdit: () async {
                final updatedItem = await Navigator.of(context).push<Item>(
                  MaterialPageRoute(
                    builder: (_) => ItemFormModal(initialItem: _item),
                    fullscreenDialog: true,
                  ),
                );
                if (updatedItem != null) {
                  setState(() {
                    _item = updatedItem;
                    _handover = updatedItem.handover;
                  });
                }
              },
              onDelete: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => const ConfirmDeleteDialog(),
                );
                if (result == true) {
                  await ItemService.deleteItem(_item.id);
                  if (context.mounted) Navigator.of(context).pop();
                }
              },
              onContact: () => _showContactDialog(context),
              onToggleHandover: _updateHandover,
              loadingContact: _emailLoading,
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemDetailsContent extends StatelessWidget {
  final Item item;
  final bool handover;
  final bool updatingHandover;
  final bool isOwner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onContact;
  final ValueChanged<bool> onToggleHandover;
  final bool loadingContact;

  const _ItemDetailsContent({
    required this.item,
    required this.handover,
    required this.updatingHandover,
    required this.isOwner,
    required this.onEdit,
    required this.onDelete,
    required this.onContact,
    required this.onToggleHandover,
    required this.loadingContact,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ItemHeader(item: item),
        const SizedBox(height: 15),
        _ItemImage(item: item),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 1),
          child: Text(
            item.location,
            style: const TextStyle(color: Colors.black54, fontSize: 15),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            '${item.category.displayName} • ${formatDate(item.dateIssueCreated)}',
            style: const TextStyle(
              color: kLogoDarkBlue,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            item.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
              color: Colors.black,
              height: 1.12,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 6),
          child: Text(
            item.description,
            style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.20),
          ),
        ),
        const SizedBox(height: 20),
        if (isOwner) ...[
          Row(
            children: [
              OutlinedButton(
                onPressed: onEdit,
                style: OutlinedButton.styleFrom(
                  foregroundColor: kLogoDarkBlue,
                  backgroundColor: const Color(0xFFF2F2F2),
                  side: const BorderSide(color: Color(0xFFF2F2F2), width: 1.2),
                ),

                child: const Text("Промени", style: TextStyle(color: Colors.black)
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: onDelete,
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2F2F2),
                  side: const BorderSide(color: Color(0xFFF2F2F2), width: 1.2),
                  foregroundColor: Colors.red,
                ),
                child: const Text("Избриши"),
              ),
            ],
          ),
          const SizedBox(height: 12,),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 6),
          child: Row(
            children: [
              const Text('Предадено', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21, color: kLogoDarkBlue)),
              const Spacer(),
              Switch(
                value: handover,
                onChanged: updatingHandover ? null : onToggleHandover,
                activeColor: kLogoLightBlue,
                trackColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) => const Color(0xFFF2F2F2),
                ),
                splashRadius: 0,
              ),
            ],
          ),
         ),
        ]
            else ...[
              OutlinedButton(
                onPressed: onContact,
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2F2F2),
                  foregroundColor: kLogoDarkBlue,
                  side: const BorderSide(color: Color(0xFFF2F2F2), width: 1.2),
                ),
              child: const Text("Контактирај", style: TextStyle(color: Colors.black)),
              ),
            ],
          PotentialMatchesAccordion(item: item),
        ],
      );
    }
}

class _ItemImage extends StatelessWidget {
  final Item item;
  const _ItemImage({required this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: Colors.black54.withOpacity(0.13),
        borderRadius: BorderRadius.circular(9),
      ),
      alignment: Alignment.center,
      child: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
          ? ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.network(
          item.imageUrl!,
          fit: BoxFit.cover,
          height: 170,
          width: double.infinity,
        ),
      )
          : Icon(Icons.image_outlined, color: Colors.black54, size: 56),
    );
  }
}

class _ItemHeader extends StatelessWidget {
  final Item item;
  const _ItemHeader({required this.item});
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

