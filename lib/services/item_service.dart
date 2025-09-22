import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class ItemService {
  static final _items = FirebaseFirestore.instance.collection('items');


  static Stream<List<Item>> itemsStream(ItemType type) {
    return _items
        .where('type', isEqualTo: type.name)
        .where('handover', isEqualTo: false)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => Item.fromMap(doc.id, doc.data()))
        .toList());
  }

  static Stream<List<Item>> potentialMatches({
    required ItemType oppositeType,
    required String category,
    required bool excludeHandover,
    String? location,
    String? excludeId,
    String? name,
  })
  {
    Query<Map<String, dynamic>> query = _items
        .where('type', isEqualTo: oppositeType.name)
        .where('category', isEqualTo: category);

    if (excludeHandover) {
      query = query.where('handover', isEqualTo: false);
    }
    if (location != null) {
      query = query.where('location', isEqualTo: location);
    }

    return query.snapshots().map((snap) {
      Iterable<Item> items = snap.docs
          .where((doc) => doc.id != excludeId)
          .map((doc) => Item.fromMap(doc.id, doc.data()));

      if (name != null && name.trim().isNotEmpty) {
        final searchName = name.trim().toLowerCase();
        items = items.where((item) =>
        item.name.toLowerCase().contains(searchName) ||
            searchName.contains(item.name.toLowerCase())
        );
      }

      return items.toList();
    });
  }

  static Future<void> updateHandover(String id, bool value) =>
      _items.doc(id).update({'handover': value});

  static Future<void> updateItem(Item item) async {
    await _items.doc(item.id).update({
      'name': item.name,
      'location': item.location,
      'description': item.description,
      'dateIssueCreated': item.dateIssueCreated.toIso8601String(),
      'category': item.category.name,
      'type': item.type.name,
      'imageUrl': item.imageUrl,
      'handover': item.handover,
      'createdBy': item.createdBy,
    });
  }

  static Future<void> deleteItem(String id) =>
      _items.doc(id).delete();

  static Future<void> addItem(Item item) async {
    await _items.add({
      'name': item.name,
      'category': item.category.name,
      'description': item.description,
      'dateIssueCreated': item.dateIssueCreated.toIso8601String(),
      'location': item.location,
      'type': item.type.name,
      'imageUrl': item.imageUrl,
      'handover': item.handover,
      'createdBy': item.createdBy,
    });
  }
}