import 'dart:convert';
class BleConfig {
  // Replace with your device's actual UUIDs
  static const String serviceUuid = '4fafc201-1fb5-459e-8fcc-xxxxxxxxxx';
  static const String characteristicUuid = 'beb5483e-36e1-4688-b7f5-eaxxxxxxxxxx';
  
  // Device name prefix for filtering scan results
  static const String deviceNamePrefix = 'mydevice_';
  
  // Timeouts
  static const Duration scanTimeout = Duration(seconds: 15);
  static const Duration connectionTimeout = Duration(seconds: 10);
  
  // Encode command to bytes
  static List<int> encodeCommand(String command) {
    return ascii.encode('CMD=$command#');
  }
}