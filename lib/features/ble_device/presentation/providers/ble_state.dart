import 'package:mentra_app/features/ble_device/domain/entities/ble_device.dart';

enum BleStatus {
  initial,
  scanning,
  scanComplete,
  connecting,
  connected,
  disconnected,
  error,
}

class BleState {
  final BleStatus status;
  final List<BleDevice> discoveredDevices;
  final BleDevice? connectedDevice;
  final String? latestResponse;
  final List<String> responseHistory;
  final String? errorMessage;
  const BleState({
    this.status = BleStatus.initial,
    this.discoveredDevices = const [],
    this.connectedDevice,
    this.latestResponse,
    this.responseHistory = const [],
    this.errorMessage,
  });
  BleState copyWith({
    BleStatus? status,
    List<BleDevice>? discoveredDevices,
    BleDevice? connectedDevice,
    String? latestResponse,
    List<String>? responseHistory,
    String? errorMessage,
  }) {
    return BleState(
      status: status ?? this.status,
      discoveredDevices: discoveredDevices ?? this.discoveredDevices,
      connectedDevice: connectedDevice ?? this.connectedDevice,
      latestResponse: latestResponse ?? this.latestResponse,
      responseHistory: responseHistory ?? this.responseHistory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}