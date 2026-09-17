class SettingsModel {
  final String businessName;
  final String phone;
  final String whatsapp;
  final String email;
  final String address;
  final String workingHours;
  final String instagramUrl;
  final String facebookUrl;
  final String linkedinUrl;
  final String youtubeUrl;

  const SettingsModel({
    required this.businessName,
    required this.phone,
    required this.whatsapp,
    required this.email,
    required this.address,
    required this.workingHours,
    required this.instagramUrl,
    required this.facebookUrl,
    required this.linkedinUrl,
    required this.youtubeUrl,
  });

  SettingsModel copyWith({
    String? businessName,
    String? phone,
    String? whatsapp,
    String? email,
    String? address,
    String? workingHours,
    String? instagramUrl,
    String? facebookUrl,
    String? linkedinUrl,
    String? youtubeUrl,
  }) {
    return SettingsModel(
      businessName: businessName ?? this.businessName,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      address: address ?? this.address,
      workingHours: workingHours ?? this.workingHours,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
    );
  }
}
