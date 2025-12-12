import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentra_app/features/ble_device/presentation/providers/ble_provider.dart';
import 'package:mentra_app/features/ble_device/presentation/providers/ble_state.dart';

class BleScreen extends ConsumerWidget {
  const BleScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleState = ref.watch(bleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('BLE Device')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Error banner
              if (bleState.errorMessage != null)
                _buildErrorBanner(bleState.errorMessage!, ref),
              // Main content
              Expanded(child: _buildContent(bleState, ref)),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildErrorBanner(String message, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
          IconButton(
            onPressed: () => ref.read(bleProvider.notifier).clearError(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
  Widget _buildContent(BleState state, WidgetRef ref) {
    switch (state.status) {
      case BleStatus.initial:
      case BleStatus.disconnected:
        return _buildInitialView(ref);
      
      case BleStatus.scanning:
      case BleStatus.scanComplete:
        return _buildScanningView(state, ref);
      
      case BleStatus.connecting:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Connecting...'),
            ],
          ),
        );
      
      case BleStatus.connected:
        return _buildConnectedView(state, ref);
      
      case BleStatus.error:
        return _buildInitialView(ref);
    }
  }
  Widget _buildInitialView(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bluetooth, size: 80, color: Colors.grey),
          const SizedBox(height: 24),
          const Text('Tap to scan for nearby devices'),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => ref.read(bleProvider.notifier).startScanning(),
            child: const Text('Scan for Devices'),
          ),
        ],
      ),
    );
  }
  Widget _buildScanningView(BleState state, WidgetRef ref) {
    final isScanning = state.status == BleStatus.scanning;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Available Devices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (isScanning) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ),
        const SizedBox(height: 8),
        Text('${state.discoveredDevices.length} device(s) found'),
        const SizedBox(height: 16),
        
        Expanded(
          child: ListView.builder(
            itemCount: state.discoveredDevices.length,
            itemBuilder: (context, index) {
              final device = state.discoveredDevices[index];
              return ListTile(
                leading: const Icon(Icons.bluetooth),
                title: Text(device.name),
                subtitle: Text('Signal: ${device.rssi} dBm'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => ref.read(bleProvider.notifier).connectToDevice(device),
              );
            },
          ),
        ),
        
        if (!isScanning)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => ref.read(bleProvider.notifier).startScanning(),
              child: const Text('Scan Again'),
            ),
          ),
      ],
    );
  }
  Widget _buildConnectedView(BleState state, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Connection status card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bluetooth_connected, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.connectedDevice?.name ?? 'Unknown')),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Connected', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => ref.read(bleProvider.notifier).disconnect(),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Disconnect'),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Response display
        const Text('Response', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              state.latestResponse ?? 'Waiting for response...',
              style: const TextStyle(color: Colors.green, fontFamily: 'monospace'),
            ),
          ),
        ),
      ],
    );
  }
}