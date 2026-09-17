class BlogModel {
  final String id;
  final String title;
  final String shortDescription;
  final String content;
  final String category;
  final String author;
  final DateTime publishDate;
  final String status; // 'Published' or 'Draft'

  const BlogModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.content,
    required this.category,
    required this.author,
    required this.publishDate,
    this.status = 'Published',
  });

  BlogModel copyWith({
    String? id,
    String? title,
    String? shortDescription,
    String? content,
    String? category,
    String? author,
    DateTime? publishDate,
    String? status,
  }) {
    return BlogModel(
      id: id ?? this.id,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      content: content ?? this.content,
      category: category ?? this.category,
      author: author ?? this.author,
      publishDate: publishDate ?? this.publishDate,
      status: status ?? this.status,
    );
  }
}
