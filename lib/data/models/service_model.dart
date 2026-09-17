class ServiceModel {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String shortDescription;
  final String fullDescription;
  final List<String> requirements;
  final List<String> process;
  final String estimatedTime;
  final double price;
  final String pricePrefix;
  final bool isPopular;
  final bool isActive;
  final String iconName;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.shortDescription,
    required this.fullDescription,
    required this.requirements,
    required this.process,
    required this.estimatedTime,
    required this.price,
    this.pricePrefix = 'Starting from',
    this.isPopular = false,
    this.isActive = true,
    this.iconName = 'description',
  });

  ServiceModel copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? categoryName,
    String? shortDescription,
    String? fullDescription,
    List<String>? requirements,
    List<String>? process,
    String? estimatedTime,
    double? price,
    String? pricePrefix,
    bool? isPopular,
    bool? isActive,
    String? iconName,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      requirements: requirements ?? this.requirements,
      process: process ?? this.process,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      price: price ?? this.price,
      pricePrefix: pricePrefix ?? this.pricePrefix,
      isPopular: isPopular ?? this.isPopular,
      isActive: isActive ?? this.isActive,
      iconName: iconName ?? this.iconName,
    );
  }
}
