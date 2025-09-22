import 'package:flutter/material.dart';
import '../models/item.dart';
import '../theme/app_colors.dart';

enum NameSortMode { az, za }
enum DateSortMode { asc, desc }

class SortFilterBottomSheet extends StatefulWidget {
  final Category? initialCategory;
  final DateTime? initialDate;
  final String? initialName;
  final NameSortMode initialNameSort;
  final DateSortMode initialDateSort;
  final void Function({
  Category? category,
  DateTime? date,
  String? name,
  required NameSortMode nameSort,
  required DateSortMode dateSort,
  required bool resetFilters
  }) onApply;

  const SortFilterBottomSheet({
    super.key,
    this.initialCategory,
    this.initialDate,
    this.initialName,
    required this.initialNameSort,
    required this.initialDateSort,
    required this.onApply,
  });

  @override
  State<SortFilterBottomSheet> createState() => _SortFilterBottomSheetState();
}

class _SortFilterBottomSheetState extends State<SortFilterBottomSheet> {
  Category? _category;
  DateTime? _date;
  String? _name;
  late NameSortMode _nameSort;
  late DateSortMode _dateSort;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    _date = widget.initialDate;
    _name = widget.initialName;
    _nameSort = widget.initialNameSort;
    _dateSort = widget.initialDateSort;
  }

  void _reset() {
    setState(() {
      _category = null;
      _date = null;
      _name = null;
      _nameSort = NameSortMode.az;
      _dateSort = DateSortMode.desc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Филтрирај по",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kLogoDarkBlue)),
              const SizedBox(height: 16),
              DropdownButtonFormField<Category>(
                value: _category,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Категорија',
                  labelStyle: const TextStyle(color: Colors.black54),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: kLogoLightBlue),
                  ),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                dropdownColor: Colors.white,
                items: [
                  const DropdownMenuItem<Category>(
                    value: null,
                    child: Text('-', style: TextStyle(color: Colors.black38)),
                  ),
                  ...Category.values
                      .map((cat) => DropdownMenuItem<Category>(
                    value: cat,
                    child: Text(cat.displayName, style: const TextStyle(color: Colors.black87)),
                  ))
                      .toList(),
                ],
                onChanged: (val) => setState(() => _category = val),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date ?? now,
                    firstDate: DateTime(now.year - 3),
                    lastDate: DateTime(now.year + 1),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
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
                    ),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Датум',
                    labelStyle: TextStyle(color: Colors.black54),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kLogoLightBlue),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _date != null
                        ? "${_date!.day.toString().padLeft(2, '0')}.${_date!.month.toString().padLeft(2, '0')}.${_date!.year}"
                        : "Избери датум",
                    style: TextStyle(
                      color: _date != null ? Colors.black87 : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Име',
                  labelStyle: TextStyle(color: Colors.black54),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kLogoLightBlue),
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _name = v),
              ),
              const SizedBox(height: 20),
              const Text("Сортирај по име", style: TextStyle(fontWeight: FontWeight.bold, color: kLogoDarkBlue)),
              Wrap(
                spacing: 15,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<NameSortMode>(
                        value: NameSortMode.az,
                        groupValue: _nameSort,
                        activeColor: kLogoLightBlue,
                        onChanged: (val) => setState(() => _nameSort = val!),
                      ),
                      const Text("A-Ш", style: TextStyle(color: kLogoDarkBlue)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<NameSortMode>(
                        value: NameSortMode.za,
                        groupValue: _nameSort,
                        activeColor: kLogoLightBlue,
                        onChanged: (val) => setState(() => _nameSort = val!),
                      ),
                      const Text("Ш-A", style: TextStyle(color: kLogoDarkBlue)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text("Сортирај по датум", style: TextStyle(fontWeight: FontWeight.bold, color: kLogoDarkBlue)),
              Wrap(
                spacing: 15,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<DateSortMode>(
                        value: DateSortMode.asc,
                        groupValue: _dateSort,
                        activeColor: kLogoLightBlue,
                        onChanged: (val) => setState(() => _dateSort = val!),
                      ),
                      const Text("растечки", style: TextStyle(color: kLogoDarkBlue)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<DateSortMode>(
                        value: DateSortMode.desc,
                        groupValue: _dateSort,
                        activeColor: kLogoLightBlue,
                        onChanged: (val) => setState(() => _dateSort = val!),
                      ),
                      const Text("опаѓачки", style: TextStyle(color: kLogoDarkBlue)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.check, color: Colors.white),
                      label: const Text("Филтрирај",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kLogoDarkBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: () {
                        widget.onApply(
                          category: _category,
                          date: _date,
                          name: _name,
                          nameSort: _nameSort,
                          dateSort: _dateSort,
                          resetFilters: false
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 13),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey[900],
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: () {
                      _reset();
                      widget.onApply(
                        category: null,
                        date: null,
                        name: null,
                        nameSort: NameSortMode.az,
                        dateSort: DateSortMode.desc,
                        resetFilters: true
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text("Ресетирај"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
