class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String status; // 'Active' or 'Inactive'
  final String iconName;
  final int serviceCount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.status = 'Active',
    this.iconName = 'folder',
    this.serviceCount = 0,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    String? iconName,
    int? serviceCount,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      iconName: iconName ?? this.iconName,
      serviceCount: serviceCount ?? this.serviceCount,
    );
  }
}
