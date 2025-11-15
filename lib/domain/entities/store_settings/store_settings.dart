import 'package:equatable/equatable.dart';

class StoreSettings extends Equatable {
  final String storeId;
  final String storeName;
  final String logoUrl;
  final String logoPosition;
  final String primaryColor;
  final String secondaryColor;
  final String description;
  final String phone;
  final String email;

  const StoreSettings({
    required this.storeId,
    required this.storeName,
    required this.logoUrl,
    this.logoPosition = 'center',
    this.primaryColor = '#FF6B6B',
    this.secondaryColor = '#4ECDC4',
    this.description = '',
    this.phone = '',
    this.email = '',
  });

  factory StoreSettings.fromJson(Map<String, dynamic> json) {
    return StoreSettings(
      storeId: json['storeId'] ?? '',
      storeName: json['storeName'] ?? 'Minha Loja',
      logoUrl: json['logoUrl'] ?? '',
      logoPosition: json['logoPosition'] ?? 'center',
      primaryColor: json['primaryColor'] ?? '#FF6B6B',
      secondaryColor: json['secondaryColor'] ?? '#4ECDC4',
      description: json['description'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'storeName': storeName,
      'logoUrl': logoUrl,
      'logoPosition': logoPosition,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'description': description,
      'phone': phone,
      'email': email,
    };
  }

  @override
  List<Object?> get props => [
        storeId,
        storeName,
        logoUrl,
        logoPosition,
        primaryColor,
        secondaryColor,
        description,
        phone,
        email,
      ];
}
