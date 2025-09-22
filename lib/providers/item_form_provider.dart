import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item.dart';
import '../services/item_service.dart';

class ItemFormState {
  final TextEditingController nameController;
  final TextEditingController locationController;
  final TextEditingController descriptionController;
  final Category? selectedCategory;
  final ItemType? selectedType;
  final DateTime? selectedDate;
  final String? imageUrl;
  final bool isUploading;
  final bool isSubmitting;

  ItemFormState({
    required this.nameController,
    required this.locationController,
    required this.descriptionController,
    this.selectedCategory,
    this.selectedType,
    this.selectedDate,
    this.imageUrl,
    this.isUploading = false,
    this.isSubmitting = false,
  });

  ItemFormState copyWith({
    TextEditingController? nameController,
    TextEditingController? locationController,
    TextEditingController? descriptionController,
    Category? selectedCategory,
    ItemType? selectedType,
    DateTime? selectedDate,
    String? imageUrl,
    bool? isUploading,
    bool? isSubmitting,
  }) {
    return ItemFormState(
      nameController: nameController ?? this.nameController,
      locationController: locationController ?? this.locationController,
      descriptionController: descriptionController ?? this.descriptionController,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedType: selectedType ?? this.selectedType,
      selectedDate: selectedDate ?? this.selectedDate,
      imageUrl: imageUrl ?? this.imageUrl,
      isUploading: isUploading ?? this.isUploading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class ItemFormNotifier extends StateNotifier<ItemFormState> {
  ItemFormNotifier([Item? initialItem, ItemType? preselectedType])
      : super(
    ItemFormState(
      nameController: TextEditingController(text: initialItem?.name ?? ''),
      locationController: TextEditingController(text: initialItem?.location ?? ''),
      descriptionController: TextEditingController(text: initialItem?.description ?? ''),
      selectedCategory: initialItem?.category,
      selectedType: initialItem?.type ?? preselectedType ?? ItemType.LOST,
      selectedDate: initialItem?.dateIssueCreated,
      imageUrl: initialItem?.imageUrl,
    ),
  );

  void setCategory(Category? cat) => state = state.copyWith(selectedCategory: cat);
  void setType(ItemType? type) => state = state.copyWith(selectedType: type);
  void setDate(DateTime? date) => state = state.copyWith(selectedDate: date);
  void setImageUrl(String? url) => state = state.copyWith(imageUrl: url, isUploading: url == null);
  void setUploading(bool uploading) => state = state.copyWith(isUploading: uploading);
  void setSubmitting(bool submitting) => state = state.copyWith(isSubmitting: submitting);

  Future<void> submit(Item? initialItem, String userId) async {
    if ([state.selectedCategory, state.selectedType, state.selectedDate].contains(null)) return;
    setSubmitting(true);
    final item = Item(
      id: initialItem?.id ?? '',
      name: state.nameController.text.trim(),
      location: state.locationController.text.trim(),
      description: state.descriptionController.text.trim(),
      category: state.selectedCategory!,
      dateIssueCreated: state.selectedDate!,
      type: state.selectedType!,
      imageUrl: state.imageUrl,
      handover: initialItem?.handover ?? false,
      createdBy: userId,
    );
    if (initialItem != null) {
      await ItemService.updateItem(item);
    } else {
      await ItemService.addItem(item);
    }
    setSubmitting(false);
  }
}

final itemFormProvider = StateNotifierProvider<ItemFormNotifier, ItemFormState>(
      (ref) => ItemFormNotifier(),
);