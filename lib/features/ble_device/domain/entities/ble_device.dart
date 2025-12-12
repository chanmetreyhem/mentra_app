class BleDevice {
  final String id;
  final String name;
  final int rssi;
  final bool isConnected;
  const BleDevice({
    required this.id,
    required this.name,
    required this.rssi,
    this.isConnected = false,
  });
  BleDevice copyWith({String? id, String? name, int? rssi, bool? isConnected}) {
    return BleDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      rssi: rssi ?? this.rssi,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
