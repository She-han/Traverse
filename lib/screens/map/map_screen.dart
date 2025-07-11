import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/bus_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().startTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traverse'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              context.read<LocationProvider>().getCurrentLocation();
            },
          ),
        ],
      ),
      body: Consumer2<LocationProvider, BusProvider>(
        builder: (context, locationProvider, busProvider, child) {
          if (locationProvider.currentPosition == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Getting your location...'),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Map placeholder
              Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Map View'),
                      Text('(Google Maps integration would go here)'),
                    ],
                  ),
                ),
              ),
              
              // Location info overlay
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Location',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Lat: ${locationProvider.currentPosition!.latitude.toStringAsFixed(6)}',
                        ),
                        Text(
                          'Lng: ${locationProvider.currentPosition!.longitude.toStringAsFixed(6)}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Nearby stops
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nearby Bus Stops',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (busProvider.nearbyStops.isEmpty)
                          const Text('Loading nearby stops...')
                        else
                          ...busProvider.nearbyStops.take(3).map(
                            (stop) => ListTile(
                              dense: true,
                              leading: const Icon(Icons.directions_bus),
                              title: Text(stop.name),
                              subtitle: Text(stop.code),
                              onTap: () => busProvider.selectStop(stop),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

