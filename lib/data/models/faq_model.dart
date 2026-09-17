class FaqModel {
  final String id;
  final String question;
  final String answer;
  final String category;
  final bool isEnabled;

  const FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.isEnabled = true,
  });

  FaqModel copyWith({
    String? id,
    String? question,
    String? answer,
    String? category,
    bool? isEnabled,
  }) {
    return FaqModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
