import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/location_util.dart';
import '../../domain/entities/mosque.dart';

part 'mosques_state.freezed.dart';

@freezed
class MosquesState with _$MosquesState {
  const factory MosquesState({
    @Default(false) bool isLoading,
    @Default(false) bool isOffline,
    @Default([]) List<Mosque> mosques,
    LocationData? currentLocation,
    Mosque? selectedMosque,
    @Default(false) bool isUsingDefaultLocation,
    @Default(false) bool isLocationDenied,
    String? error,
  }) = _MosquesState;
}
