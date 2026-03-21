import 'package:freezed_annotation/freezed_annotation.dart';

part 'mosque.freezed.dart';
part 'mosque.g.dart';

@freezed
class Mosque with _$Mosque {
  const factory Mosque({
    required String placeId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    double? rating,
    required int distanceMeters,
  }) = _Mosque;

  factory Mosque.fromJson(Map<String, dynamic> json) =>
      _$MosqueFromJson(json);
}
