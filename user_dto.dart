import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/user_model.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const UserDto._();

  const factory UserDto({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? photoUrl,
    DateTime? createdAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
      createdAt: createdAt,
    );
  }
}
