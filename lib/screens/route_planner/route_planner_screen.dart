import 'package:flutter/material.dart';
import '../../services/storage/hive_service.dart';
import '../../services/data/bus_data_service.dart';

class RoutePlannerScreen extends StatefulWidget {
  const RoutePlannerScreen({super.key});

  @override
  State<RoutePlannerScreen> createState() => _RoutePlannerScreenState();
}

class _RoutePlannerScreenState extends State<RoutePlannerScreen> {
  String? _originStopId;
  String? _destinationStopId;
  List<RouteSegment> _routeSegments = [];
  bool _isLoading = false;

  Future<void> _planRoute() async {
    if (_originStopId == null || _destinationStopId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final segments = await BusDataService.instance.planRoute(_originStopId!, _destinationStopId!);
      setState(() {
        _routeSegments = segments;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error planning route: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final stops = HiveService.getAllBusStops();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Planner'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                    ),
                    value: _originStopId,
                    items: stops
                        .map((stop) => DropdownMenuItem(
                              value: stop.id,
                              child: Text('${stop.name} (${stop.code})'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _originStopId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                    ),
                    value: _destinationStopId,
                    items: stops
                        .map((stop) => DropdownMenuItem(
                              value: stop.id,
                              child: Text('${stop.name} (${stop.code})'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _destinationStopId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _originStopId != null && _destinationStopId != null
                          ? _planRoute
                          : null,
                      child: const Text('Plan Route'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _routeSegments.isEmpty
                    ? const Center(
                        child: Text('Plan a route to see directions'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _routeSegments.length,
                        itemBuilder: (context, index) {
                          final segment = _routeSegments[index];
                          
                          return Card(
                            child: ListTile(
                              leading: Icon(
                                segment.type == 'bus' 
                                    ? Icons.directions_bus
                                    : segment.type == 'walk'
                                        ? Icons.directions_walk
                                        : Icons.transfer_within_a_station,
                              ),
                              title: Text(segment.instructions),
                              subtitle: Text('${segment.estimatedDuration} minutes'),
                              trailing: segment.routeNumber != null
                                  ? CircleAvatar(
                                      radius: 16,
                                      child: Text(
                                        segment.routeNumber!,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

