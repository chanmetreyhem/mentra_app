import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mentra_app/features/ble_device/data/constants/ble_config.dart';
import 'package:mentra_app/features/ble_device/domain/entities/ble_device.dart';
import 'package:permission_handler/permission_handler.dart';
class BleDataSource {
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _characteristic;
  StreamSubscription<List<int>>? _notificationSubscription;
  
  final _responseController = StreamController<String>.broadcast();
  Stream<String> get responseStream => _responseController.stream;
  // Check Bluetooth availability
  Future<bool> isBluetoothAvailable() async {
    return await FlutterBluePlus.isSupported;
  }
  Future<bool> isBluetoothEnabled() async {
    final state = await FlutterBluePlus.adapterState.first;
    return state == BluetoothAdapterState.on;
  }
  // Request permissions
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final bluetoothScan = await Permission.bluetoothScan.request();
      final bluetoothConnect = await Permission.bluetoothConnect.request();
      final location = await Permission.locationWhenInUse.request();
      return bluetoothScan.isGranted &&
          bluetoothConnect.isGranted &&
          location.isGranted;
    } else if (Platform.isIOS) {
      final bluetooth = await Permission.bluetooth.request();
      return bluetooth.isGranted;
    }
    return false;
  }
  // Scan for devices
  Stream<List<BleDevice>> scanForDevices() async* {
    debugPrint('Starting BLE scan...');
    await FlutterBluePlus.startScan(
      timeout: BleConfig.scanTimeout,
      androidUsesFineLocation: true,
    );
    yield* FlutterBluePlus.scanResults.map((results) {
      debugPrint('Found ${results.length} devices');
      
      // Filter devices by name prefix
      final devices = results
          .where((r) => r.device.platformName
              .toLowerCase()
              .startsWith(BleConfig.deviceNamePrefix))
          .map((r) => BleDevice(
                id: r.device.remoteId.str,
                name: r.device.platformName,
                rssi: r.rssi,
              ))
          .toList();
      
      return devices;
    });
  }
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }
  // Connect to device
  Future<void> connect(String deviceId) async {
    await stopScan();
    final device = BluetoothDevice.fromId(deviceId);
    await device.connect(
      timeout: BleConfig.connectionTimeout,
      mtu: Platform.isAndroid ? 512 : null,license: License.free
    );
    _connectedDevice = device;
    // Discover services and find our characteristic
    await _discoverServices();
    // Enable notifications to receive responses
    await _enableNotifications();
  }
  Future<void> _discoverServices() async {
    if (_connectedDevice == null) return;
    final services = await _connectedDevice!.discoverServices();
    for (final service in services) {
      if (service.uuid.toString().toLowerCase() ==
          BleConfig.serviceUuid.toLowerCase()) {
        for (final characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toLowerCase() ==
              BleConfig.characteristicUuid.toLowerCase()) {
            _characteristic = characteristic;
            debugPrint('Found characteristic: ${characteristic.uuid}');
            return;
          }
        }
      }
    }
    throw Exception('Required characteristic not found');
  }
  Future<void> _enableNotifications() async {
    if (_characteristic == null) return;
    await _characteristic!.setNotifyValue(true);
    _notificationSubscription = _characteristic!.onValueReceived.listen((value) {
      final response = ascii.decode(value);
      debugPrint('BLE Response: $response');
      _responseController.add(response);
    });
  }
  // Send command
  Future<void> sendCommand(String command) async {
    if (_characteristic == null) {
      throw Exception('Not connected to a device');
    }
    final encodedCommand = BleConfig.encodeCommand(command);
    debugPrint('Sending command: CMD=$command#');
    await _characteristic!.write(
      encodedCommand,
      withoutResponse: false,
    );
  }
  // Disconnect
  Future<void> disconnect() async {
    await _notificationSubscription?.cancel();
    _notificationSubscription = null;
    await _connectedDevice?.disconnect();
    _connectedDevice = null;
    _characteristic = null;
  }
  // Connection state
  bool get isConnected => _connectedDevice != null && _characteristic != null;
  Stream<BluetoothConnectionState>? watchConnectionState() {
    return _connectedDevice?.connectionState;
  }
  Future<void> dispose() async {
    await disconnect();
    await _responseController.close();
  }
}