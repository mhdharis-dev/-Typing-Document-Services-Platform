class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final DateTime joinedDate;
  final String status; // 'Active' or 'Disabled'
  final int requestCount;

  const CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.joinedDate,
    this.status = 'Active',
    this.requestCount = 0,
  });

  CustomerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? joinedDate,
    String? status,
    int? requestCount,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      joinedDate: joinedDate ?? this.joinedDate,
      status: status ?? this.status,
      requestCount: requestCount ?? this.requestCount,
    );
  }
}
