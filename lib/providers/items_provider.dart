import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/sort_filter_bottom_sheet.dart';
import '../models/item.dart';
import '../services/item_service.dart';

class ItemsFilterParams {
  final ItemType type;
  final Category? category;
  final DateTime? date;
  final String? name;
  final NameSortMode nameSort;
  final DateSortMode dateSort;

  ItemsFilterParams({
    required this.type,
    this.category,
    this.date,
    this.name,
    this.nameSort = NameSortMode.az,
    this.dateSort = DateSortMode.desc,
  });

  @override
  bool operator ==(Object other) {
    return other is ItemsFilterParams &&
        other.type == type &&
        other.category == category &&
        other.date == date &&
        other.name == name &&
        other.nameSort == nameSort &&
        other.dateSort == dateSort;
  }

  @override
  int get hashCode =>
      type.hashCode ^
      category.hashCode ^
      date.hashCode ^
      (name?.hashCode ?? 0) ^
      nameSort.hashCode ^
      dateSort.hashCode;
}

final itemsListProvider = StreamProvider.family<List<Item>, ItemsFilterParams>(
      (ref, params) {
    return ItemService.itemsStream(params.type).map((items) {
      var filteredItems = items;

      if (params.category != null) {
        filteredItems = filteredItems.where((e) => e.category == params.category).toList();
      }
      if (params.date != null) {
        filteredItems = filteredItems.where((e) => !e.dateIssueCreated.isBefore(params.date!)).toList();
      }
      if (params.name != null && params.name!.trim().isNotEmpty) {
        final query = params.name!.trim().toLowerCase();
        filteredItems = filteredItems.where((e) => e.name.toLowerCase().contains(query)).toList();
      }

      filteredItems.sort((a, b) {
        int cmp;
        if (params.nameSort == NameSortMode.az) {
          cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        } else {
          cmp = b.name.toLowerCase().compareTo(a.name.toLowerCase());
        }

        if (cmp == 0) {
          if (params.dateSort == DateSortMode.asc) {
            return a.dateIssueCreated.compareTo(b.dateIssueCreated);
          } else {
            return b.dateIssueCreated.compareTo(a.dateIssueCreated);
          }
        }
        return cmp;
      });

      return filteredItems;
    });
  },
);
