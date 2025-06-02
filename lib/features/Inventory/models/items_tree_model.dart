class ItemsTreeModel {
  final int id;
  final String code;
  final String name;
  final String type;
  final List<ItemsTreeItem> items;
  final List<ItemsTreeModel> children;

  ItemsTreeModel({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    this.items = const [],
    this.children = const [],
  });

  factory ItemsTreeModel.fromMap(Map<String, dynamic> map) {
    return ItemsTreeModel(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      type: map['type'],
      items: (map['items'] as List<dynamic>?)
              ?.map((e) => ItemsTreeItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      children: (map['children'] as List<dynamic>?)
              ?.map((e) => ItemsTreeModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ItemsTreeItem {
  final int id;
  final String code;
  final String name;
  final String type;

  ItemsTreeItem({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
  });

  factory ItemsTreeItem.fromMap(Map<String, dynamic> map) {
    return ItemsTreeItem(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      type: map['type'],
    );
  }
}
