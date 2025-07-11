import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bus_provider.dart';
import '../../services/storage/hive_service.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
      ),
      body: Consumer<BusProvider>(
        builder: (context, busProvider, child) {
          return Column(
            children: [
              // Stop selector
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Bus Stop',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Choose a bus stop',
                        ),
                        value: busProvider.selectedStop?.id,
                        items: HiveService.getAllBusStops()
                            .map((stop) => DropdownMenuItem(
                                  value: stop.id,
                                  child: Text('${stop.name} (${stop.code})'),
                                ))
                            .toList(),
                        onChanged: (stopId) {
                          if (stopId != null) {
                            final stop = HiveService.getBusStop(stopId);
                            if (stop != null) {
                              busProvider.selectStop(stop);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              // Arrivals list
              Expanded(
                child: busProvider.selectedStop == null
                    ? const Center(
                        child: Text('Select a bus stop to view arrivals'),
                      )
                    : busProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : busProvider.arrivals.isEmpty
                            ? const Center(
                                child: Text('No upcoming arrivals'),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: busProvider.arrivals.length,
                                itemBuilder: (context, index) {
                                  final arrival = busProvider.arrivals[index];
                                  final route = HiveService.getBusRoute(arrival.routeId);
                                  
                                  return Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: route != null 
                                            ? Color(int.parse(route.color.replaceFirst('#', '0xFF')))
                                            : Colors.blue,
                                        child: Text(
                                          route?.routeNumber ?? '?',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(route?.routeName ?? 'Unknown Route'),
                                      subtitle: Text(
                                        'Scheduled: ${arrival.scheduledTime.hour.toString().padLeft(2, '0')}:${arrival.scheduledTime.minute.toString().padLeft(2, '0')}',
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${arrival.minutesUntilArrival} min',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          if (arrival.status != 'on_time')
                                            Text(
                                              arrival.status.toUpperCase(),
                                              style: TextStyle(
                                                color: arrival.status == 'delayed' 
                                                    ? Colors.red 
                                                    : Colors.green,
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          );
        },
      ),
    );
  }
}

