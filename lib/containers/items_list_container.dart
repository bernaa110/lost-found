import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/sort_filter_bottom_sheet.dart';
import '../models/item.dart';
import '../components/item_card.dart';
import '../screens/item_details_screen.dart';

class ItemsListContainer extends StatelessWidget {
  final ItemType itemType;
  final Category? filterCategory;
  final DateTime? filterDate;
  final String? filterName;
  final NameSortMode nameSort;
  final DateSortMode dateSort;
  final AsyncValue<List<Item>> itemsAsyncValue;

  const ItemsListContainer({
    super.key,
    required this.itemType,
    this.filterCategory,
    this.filterDate,
    this.filterName,
    required this.nameSort,
    required this.dateSort,
    required this.itemsAsyncValue,
  });

  @override
  Widget build(BuildContext context) {
    return itemsAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
          child: Text(
            'Грешка: $error',
            style: const TextStyle(color: Colors.red),
          )),
      data: (items) {
        if (items.isEmpty) {
          return const Center(
            child: Text(
              'Нема пронајдени предмети.',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 72, top: 6),
          itemCount: items.length,
          itemBuilder: (_, idx) => ItemCard(
            item: items[idx],
            onDetails: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ItemDetailsScreen(item: items[idx]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}