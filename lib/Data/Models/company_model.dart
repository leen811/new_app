import 'package:equatable/equatable.dart';

class CompanyStep1 extends Equatable {
  final String name;
  final String typeId;
  final String sectorId;
  final String description;

  const CompanyStep1({
    this.name = '',
    this.typeId = '',
    this.sectorId = '',
    this.description = '',
  });

  CompanyStep1 copyWith({String? name, String? typeId, String? sectorId, String? description}) => CompanyStep1(
        name: name ?? this.name,
        typeId: typeId ?? this.typeId,
        sectorId: sectorId ?? this.sectorId,
        description: description ?? this.description,
      );

  factory CompanyStep1.fromJson(Map<String, dynamic> json) => CompanyStep1(
        name: json['name'] as String? ?? '',
        typeId: json['typeId'] as String? ?? '',
        sectorId: json['sectorId'] as String? ?? '',
        description: json['description'] as String? ?? '',
      );
  Map<String, dynamic> toJson() => {
        'name': name,
        'typeId': typeId,
        'sectorId': sectorId,
        'description': description,
      };

  @override
  List<Object?> get props => [name, typeId, sectorId, description];
}

class CompanyStep2 extends Equatable {
  final String email;
  final String phone; // +966 masked
  final String address;
  final String countryCode;
  final String city;

  const CompanyStep2({
    this.email = '',
    this.phone = '',
    this.address = '',
    this.countryCode = '',
    this.city = '',
  });

  CompanyStep2 copyWith({String? email, String? phone, String? address, String? countryCode, String? city}) => CompanyStep2(
        email: email ?? this.email,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        countryCode: countryCode ?? this.countryCode,
        city: city ?? this.city,
      );

  factory CompanyStep2.fromJson(Map<String, dynamic> json) => CompanyStep2(
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        address: json['address'] as String? ?? '',
        countryCode: json['countryCode'] as String? ?? '',
        city: json['city'] as String? ?? '',
      );
  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'address': address,
        'countryCode': countryCode,
        'city': city,
      };

  @override
  List<Object?> get props => [email, phone, address, countryCode, city];
}


