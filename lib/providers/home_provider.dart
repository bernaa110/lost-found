import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/sort_filter_bottom_sheet.dart';
import '../models/item.dart';

class HomeScreenState {
  final ItemType selectedTab;
  final Category? filterCategory;
  final DateTime? filterDate;
  final String? filterName;
  final NameSortMode nameSort;
  final DateSortMode dateSort;

  HomeScreenState({
    this.selectedTab = ItemType.LOST,
    this.filterCategory,
    this.filterDate,
    this.filterName,
    this.nameSort = NameSortMode.az,
    this.dateSort = DateSortMode.desc,
  });

  HomeScreenState copyWith({
    ItemType? selectedTab,
    Category? filterCategory,
    DateTime? filterDate,
    String? filterName,
    NameSortMode? nameSort,
    DateSortMode? dateSort,
    bool resetFilters = false,
  }) {
    if (resetFilters) {
      return HomeScreenState(
        selectedTab: selectedTab ?? this.selectedTab,
        filterCategory: null,
        filterDate: null,
        filterName: null,
        nameSort: NameSortMode.az,
        dateSort: DateSortMode.desc,
      );
    }
    return HomeScreenState(
      selectedTab: selectedTab ?? this.selectedTab,
      filterCategory: filterCategory ?? this.filterCategory,
      filterDate: filterDate ?? this.filterDate,
      filterName: filterName ?? this.filterName,
      nameSort: nameSort ?? this.nameSort,
      dateSort: dateSort ?? this.dateSort,
    );
  }
}

class HomeScreenNotifier extends StateNotifier<HomeScreenState> {
  HomeScreenNotifier() : super(HomeScreenState());

  void setSelectedTab(ItemType tab) {
    state = state.copyWith(selectedTab: tab);
  }

  void setFilters({
    Category? category,
    DateTime? date,
    String? name,
    NameSortMode? nameSort,
    DateSortMode? dateSort,
    bool resetFilters = false
  }) {
    state = state.copyWith(
      filterCategory: category,
      filterDate: date,
      filterName: name,
      nameSort: nameSort,
      dateSort: dateSort,
      resetFilters: resetFilters
    );
  }
}

final homeScreenProvider =
StateNotifierProvider<HomeScreenNotifier, HomeScreenState>(
      (ref) => HomeScreenNotifier(),
);