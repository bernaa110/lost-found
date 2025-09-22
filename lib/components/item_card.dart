import 'package:flutter/material.dart';
import '../models/item.dart';
import '../utils/date_formatter.dart';
import '../theme/app_colors.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onDetails;

  const ItemCard({super.key, required this.item, required this.onDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.black12 ,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)
              ),
            ),
            alignment: Alignment.center,
            child: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                ? ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: Image.network(
                item.imageUrl!,
                fit: BoxFit.cover,
                height: 140,
                width: double.infinity,
              ),
            )
                : Icon(Icons.image_outlined, color: Colors.black54, size: 54),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 22, 13, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.category.displayName} • ${formatDate(item.dateIssueCreated)}',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: kLogoDarkBlue),
                ),
                const SizedBox(height: 18),
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 9),
                Text(item.location, style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic)),
                const SizedBox(height: 9),
                ElevatedButton(
                  onPressed: onDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEBEBEB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                  ),
                  child: const Text(
                    'Детали',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}