import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentra_app/features/ble_device/data/datasources/ble_data_source.dart';
import 'package:mentra_app/features/ble_device/domain/entities/ble_device.dart';
import 'package:mentra_app/features/ble_device/presentation/providers/ble_state.dart' show BleState, BleStatus;

final bleProvider = NotifierProvider<BleNotifier, BleState>(BleNotifier.new);
class BleNotifier extends Notifier<BleState> {
  late BleDataSource _dataSource;
  StreamSubscription<List<BleDevice>>? _scanSubscription;
  StreamSubscription<String>? _responseSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  bool _isScanning = false;
  @override
  BleState build() {
    _dataSource = BleDataSource();
    
    ref.onDispose(() {
      _scanSubscription?.cancel();
      _responseSubscription?.cancel();
      _connectionSubscription?.cancel();
      _dataSource.dispose();
    });
    
    return const BleState();
  }
  Future<void> startScanning() async {
    if (_isScanning) return;
    _isScanning = true;
    // Request permissions first
    final hasPermissions = await _dataSource.requestPermissions();
    if (!hasPermissions) {
      state = state.copyWith(
        status: BleStatus.error,
        errorMessage: 'Bluetooth permissions not granted',
      );
      _isScanning = false;
      return;
    }
    // Check Bluetooth state
    if (!await _dataSource.isBluetoothEnabled()) {
      state = state.copyWith(
        status: BleStatus.error,
        errorMessage: 'Please enable Bluetooth',
      );
      _isScanning = false;
      return;
    }
    state = state.copyWith(
      status: BleStatus.scanning,
      discoveredDevices: [],
    );
    _scanSubscription = _dataSource.scanForDevices().listen(
      (devices) {
        state = state.copyWith(
          status: BleStatus.scanComplete,
          discoveredDevices: devices,
        );
      },
      onError: (error) {
        state = state.copyWith(
          status: BleStatus.error,
          errorMessage: error.toString(),
        );
        _isScanning = false;
      },
      onDone: () {
        _isScanning = false;
      },
    );
  }
  Future<void> connectToDevice(BleDevice device) async {
    state = state.copyWith(status: BleStatus.connecting);
    try {
      await _dataSource.connect(device.id);
      
      state = state.copyWith(
        status: BleStatus.connected,
        connectedDevice: device.copyWith(isConnected: true),
      );
      // Listen for responses
      _responseSubscription = _dataSource.responseStream.listen((response) {
        state = state.copyWith(
          latestResponse: response,
          responseHistory: [...state.responseHistory, response],
        );
      });
      // Watch connection state for auto-reconnect
      _watchConnectionState();
      // Send initial command
      await sendCommand('PING');
      
    } catch (e) {
      state = state.copyWith(
        status: BleStatus.error,
        errorMessage: 'Connection failed: $e',
      );
    }
  }
  void _watchConnectionState() {
    _connectionSubscription = _dataSource.watchConnectionState()?.listen((connectionState) {
      if (connectionState == BluetoothConnectionState.disconnected) {
        state = state.copyWith(
          status: BleStatus.disconnected,
          connectedDevice: null,
        );
        // Optionally implement auto-reconnect here
      }
    });
  }
  Future<void> sendCommand(String command) async {
    try {
      await _dataSource.sendCommand(command);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to send command: $e',
      );
    }
  }
  Future<void> disconnect() async {
    await _responseSubscription?.cancel();
    await _connectionSubscription?.cancel();
    await _dataSource.disconnect();
    
    state = state.copyWith(
      status: BleStatus.disconnected,
      connectedDevice: null,
    );
  }
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}