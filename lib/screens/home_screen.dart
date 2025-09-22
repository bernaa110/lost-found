import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/profile_menu_button.dart';
import '../screens/item_form_modal.dart';
import '../theme/app_colors.dart';
import 'index_screen.dart';
import '../components/sort_filter_bottom_sheet.dart';
import '../containers/items_list_container.dart';
import '../providers/home_provider.dart';
import '../models/item.dart';
import '../providers/items_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    final homeState = ref.read(homeScreenProvider);
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: homeState.selectedTab == ItemType.LOST ? 0 : 1,
    );
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        ref.read(homeScreenProvider.notifier).setSelectedTab(
          tabController.index == 0 ? ItemType.LOST : ItemType.FOUND,
        );
      }
    });
  }

  void _openSortFilterModal(BuildContext context, HomeScreenState homeState) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (_) => SortFilterBottomSheet(
        initialCategory: homeState.filterCategory,
        initialDate: homeState.filterDate,
        initialName: homeState.filterName,
        initialNameSort: homeState.nameSort,
        initialDateSort: homeState.dateSort,
        onApply: ({
          Category? category,
          DateTime? date,
          String? name,
          required NameSortMode nameSort,
          required DateSortMode dateSort,
          required bool resetFilters
        }) {
          ref.read(homeScreenProvider.notifier).setFilters(
            category: category,
            date: date,
            name: name,
            nameSort: nameSort,
            dateSort: dateSort,
            resetFilters: resetFilters
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeScreenProvider);

    final lostItemsAsync = ref.watch(itemsListProvider(ItemsFilterParams(
      type: ItemType.LOST,
      category: homeState.filterCategory,
      date: homeState.filterDate,
      name: homeState.filterName,
      nameSort: homeState.nameSort,
      dateSort: homeState.dateSort,
    )));

    final foundItemsAsync = ref.watch(itemsListProvider(ItemsFilterParams(
      type: ItemType.FOUND,
      category: homeState.filterCategory,
      date: homeState.filterDate,
      name: homeState.filterName,
      nameSort: homeState.nameSort,
      dateSort: homeState.dateSort,
    )));

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 12, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => tabController.animateTo(0),
                      child: Text(
                        "Изгубено",
                        style: homeState.selectedTab == ItemType.LOST
                            ? const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kLogoDarkBlue)
                            : const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    GestureDetector(
                      onTap: () => tabController.animateTo(1),
                      child: Text(
                        "Најдено",
                        style: homeState.selectedTab == ItemType.FOUND
                            ? const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kLogoDarkBlue)
                            : const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.filter_alt_rounded,
                          color: kLogoLightBlue, size: 28),
                      tooltip: "Филтрирај/Сортирај",
                      onPressed: () => _openSortFilterModal(context, homeState),
                    ),
                    ProfileMenuButton(
                      onSignOut: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const IndexScreen()),
                                (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ItemsListContainer(
            itemType: ItemType.LOST,
            filterCategory: homeState.filterCategory,
            filterDate: homeState.filterDate,
            filterName: homeState.filterName,
            nameSort: homeState.nameSort,
            dateSort: homeState.dateSort,
            itemsAsyncValue: lostItemsAsync,
          ),
          ItemsListContainer(
            itemType: ItemType.FOUND,
            filterCategory: homeState.filterCategory,
            filterDate: homeState.filterDate,
            filterName: homeState.filterName,
            nameSort: homeState.nameSort,
            dateSort: homeState.dateSort,
            itemsAsyncValue: foundItemsAsync,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final preselectedType = homeState.selectedTab == ItemType.LOST
              ? ItemType.LOST
              : ItemType.FOUND;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ItemFormModal(preselectedType: preselectedType),
              fullscreenDialog: true,
            ),
          );
        },
        tooltip: 'Додај нов предмет',
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[700],
        elevation: 4,
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
