class Profile {
  String full_name;
  String phone;
  String address;
  String photo;

  Profile({
    required this.full_name,
    required this.phone,
    required this.address,
    required this.photo,
  });

  // Tạo phương thức từ JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      full_name: json['full_name'],
      phone: json['phone'],
      address: json['address'],
      photo: json['avatar_url'],
    );
  }

  // Chuyển đổi Profile thành JSON
  Map<String, dynamic> toJson() {
    return {
      'full_name': full_name,
      'phone': phone,
      'address': address,
      'avatar_url': photo,
    };
  }

  Profile copyWith({
    String? full_name,
    String? phone,
    String? address,
    String? photo,
  }) {
    return Profile(
      full_name: full_name ?? this.full_name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photo: photo ?? this.photo,
    );
  }
}
