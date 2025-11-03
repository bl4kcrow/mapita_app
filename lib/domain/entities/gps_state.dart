class GpsState {
  const GpsState({
    required this.isGpsEnabled,
    required this.isPermissionGranted,
  });

  final bool isGpsEnabled;
  final bool isPermissionGranted;

  bool get isAllGranted => isGpsEnabled && isPermissionGranted;

  GpsState copyWith({bool? isGpsEnabled, bool? isPermissionGranted}) =>
      GpsState(
        isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
        isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      );

  @override
  String toString() {
    return '{ isGpsEnabled: $isGpsEnabled, isGpsPermissionGranted: $isPermissionGranted }';
  }
}
