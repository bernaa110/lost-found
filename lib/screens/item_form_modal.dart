import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/form_fields.dart';
import '../components/image_picker_button.dart';
import '../models/item.dart';
import '../providers/item_form_provider.dart';
import '../theme/app_colors.dart';

class ItemFormModal extends ConsumerWidget {
  final Item? initialItem;
  final ItemType? preselectedType;

  const ItemFormModal({super.key, this.initialItem, this.preselectedType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(itemFormProvider);
    final formNotifier = ref.read(itemFormProvider.notifier);
    final formKey = GlobalKey<FormState>();
    final bool isEdit = initialItem != null;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEdit ? "Измени предмет" : "Пријави предмет",
                      style: const TextStyle(
                        fontSize: 20,
                        color: kLogoLightBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Затвори',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildNameInput(formState.nameController),
                      const SizedBox(height: 14),
                      buildLocationInput(formState.locationController),
                      const SizedBox(height: 14),
                      buildDatePicker(context, formState.selectedDate, (picked) {
                        formNotifier.setDate(picked);
                      }),
                      const SizedBox(height: 14),
                      buildDescriptionInput(formState.descriptionController),
                      const SizedBox(height: 10),
                      buildCategoryDropdown(formState.selectedCategory, (cat) {
                        formNotifier.setCategory(cat);
                      }),
                      const SizedBox(height: 18),
                      ImagePickerButton(
                        onImageUploaded: (url) {
                          formNotifier.setImageUrl(url);
                        },
                        isUploading: formState.isUploading,
                        imageUrl: formState.imageUrl,
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Тип',
                        style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                      ),
                      buildTypeSelector(formState.selectedType, (type) {
                        formNotifier.setType(type);
                      }),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: formState.isUploading || formState.isSubmitting
                              ? null
                              : () async {
                            if (!formKey.currentState!.validate() ||
                                formState.selectedCategory == null ||
                                formState.selectedType == null ||
                                formState.selectedDate == null) return;

                            final String userId = FirebaseAuth.instance.currentUser!.uid;
                            await formNotifier.submit(initialItem, userId);
                            if (context.mounted) Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                          ),
                          child: formState.isSubmitting
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            isEdit ? "Зачувај промени" : "ПРИЈАВИ",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
