class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final String role;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    this.role = 'Traveler',
  });

  String get fullName => '$firstName $lastName'.trim();

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatarUrl: json['avatar_url'],
      role: json['role'] ?? 'Traveler',
    );
  }

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'avatar_url': avatarUrl,
        'role': role,
        'updated_at': DateTime.now().toIso8601String(),
      };
}
