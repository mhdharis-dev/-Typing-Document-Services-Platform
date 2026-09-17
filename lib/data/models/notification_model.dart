class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String type; // 'request', 'alert', 'system'
  final String? relatedRequestId;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.type = 'system',
    this.relatedRequestId,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? type,
    String? relatedRequestId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      relatedRequestId: relatedRequestId ?? this.relatedRequestId,
    );
  }
}
