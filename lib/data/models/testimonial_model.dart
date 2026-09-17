class TestimonialModel {
  final String id;
  final String customerName;
  final String customerRole;
  final String review;
  final double rating;
  final bool isEnabled;

  const TestimonialModel({
    required this.id,
    required this.customerName,
    required this.customerRole,
    required this.review,
    this.rating = 5.0,
    this.isEnabled = true,
  });

  TestimonialModel copyWith({
    String? id,
    String? customerName,
    String? customerRole,
    String? review,
    double? rating,
    bool? isEnabled,
  }) {
    return TestimonialModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerRole: customerRole ?? this.customerRole,
      review: review ?? this.review,
      rating: rating ?? this.rating,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
