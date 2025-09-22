import 'package:flutter/material.dart';
import '../models/item.dart';
import '../theme/app_colors.dart';

Widget buildNameInput(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      labelText: 'Име',
      labelStyle: TextStyle(color: Colors.black54),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kLogoLightBlue),
      ),
      border: OutlineInputBorder(),
    ),
    validator: (val) => (val == null || val.isEmpty) ? 'Внеси име' : null,
  );
}

Widget buildLocationInput(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      labelText: 'Локација',
      labelStyle: TextStyle(color: Colors.black54),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kLogoLightBlue),
      ),
      border: OutlineInputBorder(),
    ),
    validator: (val) => (val == null || val.isEmpty) ? 'Внеси локација' : null,
  );
}

Widget buildDescriptionInput(TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      TextFormField(
        controller: controller,
        maxLines: 5,
        maxLength: 500,
        decoration: const InputDecoration(
          labelText: 'Опис',
          labelStyle: TextStyle(color: Colors.black54),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kLogoLightBlue),
          ),
          border: OutlineInputBorder(),
          counterText: '',
        ),
        validator: (val) => (val == null || val.isEmpty) ? 'Внеси опис' : null,
      ),
    ],
  );
}

Widget buildCategoryDropdown(Category? selected, ValueChanged<Category?> onChanged) {
  return DropdownButtonFormField<Category>(
    value: selected,
    isExpanded: true,
    decoration: const InputDecoration(
      labelText: 'Категорија',
      labelStyle: TextStyle(color: Colors.black54),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kLogoLightBlue),
      ),
      border: OutlineInputBorder(),
    ),
    dropdownColor: Colors.grey[200],
    items: Category.values
        .map((cat) => DropdownMenuItem<Category>(
      value: cat,
      child: Text(
        cat.displayName,
        style: const TextStyle(color: Colors.black54),
      ),
    ))
        .toList(),
    validator: (val) => (val == null) ? 'Избери категорија' : null,
    onChanged: onChanged,
  );
}

Widget buildTypeSelector(ItemType? selected, ValueChanged<ItemType> onChanged) {
  return Row(
    children: [
      Checkbox(
        value: selected == ItemType.LOST,
        activeColor: kLogoLightBlue,
        checkColor: Colors.white,
        onChanged: (v) {
          if (v == true) onChanged(ItemType.LOST);
        },
      ),
      const Text(
        'Изгубено',
        style: TextStyle(color: Colors.black54),
      ),
      const SizedBox(width: 16),
      Checkbox(
        value: selected == ItemType.FOUND,
        activeColor: kLogoLightBlue,
        checkColor: Colors.white,
        onChanged: (v) {
          if (v == true) onChanged(ItemType.FOUND);
        },
      ),
      const Text(
        'Најдено',
        style: TextStyle(color: Colors.black54),
      ),
    ],
  );
}

Widget buildDatePicker(BuildContext context, DateTime? selected, ValueChanged<DateTime> onChanged) {
  return InkWell(
    onTap: () async {
      final now = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: selected ?? now,
        firstDate: DateTime(now.year - 3),
        lastDate: DateTime(now.year + 1),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: kLogoLightBlue,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: kLogoLightBlue,
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) onChanged(picked);
    },
    child: InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Датум',
        labelStyle: TextStyle(color: Colors.black54),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kLogoLightBlue),
        ),
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today, color: kLogoLightBlue),
      ),
      child: Text(
        selected != null
            ? "${selected.day.toString().padLeft(2, '0')}.${selected.month.toString().padLeft(2, '0')}.${selected.year}"
            : "Избери датум",
        style: TextStyle(
          color: selected != null ? Colors.black87 : Colors.grey[400],
          fontSize: 16,
        ),
      ),
    ),
  );
}
