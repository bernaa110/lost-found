enum Category {
  MOBILE_PHONES("Мобилни телефони"),
  LAPTOPS("Лаптопи"),
  TABLETS("Таблети"),
  CAMERAS("Фотоапарати"),
  HEADPHONES("Слушалки"),
  SMARTWATCHES("Смарт часовници"),
  CHARGERS("Полначи"),
  USB_DRIVES("USB уреди"),
  KEYS("Клучеви"),
  WALLETS("Паричници"),
  GLASSES("Очила"),
  WATCHES("Рачни часовници"),
  JEWELRY("Накит"),
  ACCESSORIES("Додатоци"),
  CLOTHING("Облека"),
  BAGS("Торби"),
  DOCUMENTS("Документи"),
  BOOK("Книги"),
  OTHER("Друго");

  final String displayName;
  const Category(this.displayName);
}

enum ItemType { LOST, FOUND }

class Item {
  final String id;
  final String name;
  final Category category;
  final String description;
  final DateTime dateIssueCreated;
  final String location;
  final ItemType type;
  final String? imageUrl;
  final bool handover;
  final String createdBy;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.dateIssueCreated,
    required this.location,
    required this.type,
    this.imageUrl,
    required this.handover,
    required this.createdBy,
  });

  factory Item.fromMap(String id, Map<String, dynamic> data) {
    return Item(
      id: id,
      name: data['name'] ?? "",
      category: Category.values.firstWhere(
            (e) => e.name == data['category'],
        orElse: () => Category.BAGS,
      ),
      description: data['description'] ?? "",
      dateIssueCreated: DateTime.parse(data['dateIssueCreated']),
      location: data['location'] ?? "",
      type: ItemType.values.firstWhere(
            (e) => e.name == data['type'],
        orElse: () => ItemType.LOST,
      ),
      imageUrl: data['imageUrl'],
      handover: data['handover'] ?? false,
      createdBy: data['createdBy'] ?? "",
    );
  }

  Item copyWith({
    String? id,
    String? name,
    Category? category,
    String? description,
    DateTime? dateIssueCreated,
    String? location,
    ItemType? type,
    String? imageUrl,
    bool? handover,
    String? createdBy,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      dateIssueCreated: dateIssueCreated ?? this.dateIssueCreated,
      location: location ?? this.location,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      handover: handover ?? this.handover,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category.name,
      'description': description,
      'dateIssueCreated': dateIssueCreated.toIso8601String(),
      'location': location,
      'type': type.name,
      'imageUrl': imageUrl,
      'handover': handover,
      'createdBy': createdBy,
    };
  }
}