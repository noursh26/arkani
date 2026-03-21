import 'package:freezed_annotation/freezed_annotation.dart';

part 'adhkar_category.freezed.dart';
part 'adhkar_category.g.dart';

@freezed
class AdhkarCategory with _$AdhkarCategory {
  const factory AdhkarCategory({
    required int id,
    required String name,
    required String slug,
    required String icon,
    required int adhkarCount,
  }) = _AdhkarCategory;

  factory AdhkarCategory.fromJson(Map<String, dynamic> json) =>
      _$AdhkarCategoryFromJson(json);
}

@freezed
class Dhikr with _$Dhikr {
  const factory Dhikr({
    required int id,
    required String text,
    String? source,
    required int count,
    required int order,
  }) = _Dhikr;

  factory Dhikr.fromJson(Map<String, dynamic> json) =>
      _$DhikrFromJson(json);
}

@freezed
class AdhkarCollection with _$AdhkarCollection {
  const factory AdhkarCollection({
    required AdhkarCategory category,
    required List<Dhikr> adhkar,
  }) = _AdhkarCollection;

  factory AdhkarCollection.fromJson(Map<String, dynamic> json) =>
      _$AdhkarCollectionFromJson(json);
}
