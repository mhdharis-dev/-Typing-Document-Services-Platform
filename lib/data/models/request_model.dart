class RequestDocument {
  final String id;
  final String fileName;
  final String fileType;
  final String fileSize;
  final DateTime uploadedAt;
  final String status; // 'Verified', 'Pending', 'Rejected'

  const RequestDocument({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
    this.status = 'Pending',
  });
}

class TimelineStep {
  final String title;
  final String description;
  final DateTime? timestamp;
  final bool isCompleted;

  const TimelineStep({
    required this.title,
    required this.description,
    this.timestamp,
    required this.isCompleted,
  });
}

class InternalNote {
  final String id;
  final String author;
  final String note;
  final DateTime createdAt;

  const InternalNote({
    required this.id,
    required this.author,
    required this.note,
    required this.createdAt,
  });
}

class RequestModel {
  final String id;
  final String serviceId;
  final String serviceName;
  final String categoryName;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String preferredContact; // 'WhatsApp', 'Phone', 'Email'
  final String message;
  final List<RequestDocument> documents;
  final String status; // 'Submitted', 'Reviewing', 'Documents Required', 'Processing', 'Completed', 'Cancelled'
  final DateTime submittedAt;
  final DateTime updatedAt;
  final List<TimelineStep> timeline;
  final List<InternalNote> internalNotes;

  const RequestModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.categoryName,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.preferredContact,
    required this.message,
    required this.documents,
    required this.status,
    required this.submittedAt,
    required this.updatedAt,
    required this.timeline,
    required this.internalNotes,
  });

  RequestModel copyWith({
    String? id,
    String? serviceId,
    String? serviceName,
    String? categoryName,
    String? customerId,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? preferredContact,
    String? message,
    List<RequestDocument>? documents,
    String? status,
    DateTime? submittedAt,
    DateTime? updatedAt,
    List<TimelineStep>? timeline,
    List<InternalNote>? internalNotes,
  }) {
    return RequestModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      categoryName: categoryName ?? this.categoryName,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      preferredContact: preferredContact ?? this.preferredContact,
      message: message ?? this.message,
      documents: documents ?? this.documents,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      timeline: timeline ?? this.timeline,
      internalNotes: internalNotes ?? this.internalNotes,
    );
  }
}
