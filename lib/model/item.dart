final String tableItems = 'items';

class ItemsFields {
  static final List<String> values = [id, name, isImportant, time];

  static final String id = '_id';
  static final String name = 'name';
  static final String isImportant = "isImportant";
  static final String time = "time";
}

class Item {
  final int? id;
  final String name;
  final bool isImportant;
  final DateTime createdTime;

  Item({
    this.id,
    required this.name,
    required this.isImportant,
    required this.createdTime,
  });

  Item copy({
    int? id,
    String? name,
    bool? isImportant,
    DateTime? createdTime,
  }) =>
      Item(
        id: id ?? this.id,
        name: name ?? this.name,
        isImportant: isImportant ?? this.isImportant,
        createdTime: createdTime ?? this.createdTime,
      );

  static Item fromJson(Map<String, Object?> json) => Item(
      id: json[ItemsFields.id] as int?,
      name: json[ItemsFields.name] as String,
      isImportant: json[ItemsFields.isImportant] == 1, // истина или ложь
      createdTime: DateTime.parse(json[ItemsFields.time] as String));
  // json -> dart format

  Map<String, Object?> toJson() => {
        ItemsFields.id: id,
        ItemsFields.name: name,
        ItemsFields.isImportant: isImportant ? 1 : 0,
        ItemsFields.time: createdTime.toIso8601String(),
      };
}
