import 'package:flutter/material.dart';
import '../models/item.dart';
import '../screens/item_details_screen.dart';
import '../services/item_service.dart';
import '../components/item_card.dart';
import '../theme/app_colors.dart';

class PotentialMatchesAccordion extends StatefulWidget {
  final Item item;
  const PotentialMatchesAccordion({super.key, required this.item});

  @override
  State<PotentialMatchesAccordion> createState() => _PotentialMatchesAccordionState();
}

class _PotentialMatchesAccordionState extends State<PotentialMatchesAccordion> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final ItemType oppositeType =
    widget.item.type == ItemType.LOST ? ItemType.FOUND : ItemType.LOST;

    return Column(
      children: [
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: kLogoDarkBlue),
              const SizedBox(width: 4),
              Text(
                "Потенцијални совпаѓања",
                style: TextStyle(
                  color: kLogoDarkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const Spacer(),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _expanded
              ? Padding(
            padding: const EdgeInsets.only(top: 12),
            child: StreamBuilder<List<Item>>(
              stream: ItemService.potentialMatches(
                oppositeType: oppositeType,
                category: widget.item.category.name,
                excludeHandover: true,
                excludeId: widget.item.id,
                name: widget.item.name,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                if (snapshot.hasError) {
                  return Text('Грешка: не може да се вчитаат совпаѓања.',
                      style: TextStyle(color: Colors.red));
                }
                final matches = snapshot.data ?? [];
                if (matches.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 18),
                    child: Text(
                      "Нема совпаѓања за овој предмет.",
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic),
                    ),
                  );
                }
                return Column(
                  children: matches
                      .take(3)
                      .map((match) => ItemCard(
                    item: match,
                    onDetails: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ItemDetailsScreen(item: match),
                        ),
                      );
                    },
                  ))
                      .toList(),
                );
              },
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
