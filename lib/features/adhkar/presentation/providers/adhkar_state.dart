import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/adhkar_category.dart';

part 'adhkar_state.freezed.dart';

@freezed
class AdhkarState with _$AdhkarState {
  const factory AdhkarState({
    @Default(false) bool isLoadingCategories,
    @Default(false) bool isLoadingAdhkar,
    @Default(false) bool isOffline,
    @Default([]) List<AdhkarCategory> categories,
    AdhkarCollection? currentCollection,
    AdhkarCategory? selectedCategory,
    String? error,
  }) = _AdhkarState;
}
