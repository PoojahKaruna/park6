import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MyLocation {
  MyLocation(this.lat, this.long);

  double lat, long;
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapView> {
  bool _currentLocationEnabled = false;
  late Position userLocation;
  late final MapController mapController;
  late AlignOnUpdate _alignPositionOnUpdate;
  late final StreamController<double?> _alignPositionStreamController;

  List<MyLocation> locations = [
    MyLocation(43.876890, -79.048170),
    MyLocation(43.877350, -79.048393),
    MyLocation(43.876419, -79.047569)
  ];

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _alignPositionOnUpdate = AlignOnUpdate.always;
    _alignPositionStreamController = StreamController<double?>();
    _locateUser();
  }

  @override
  void dispose() {
    _alignPositionStreamController.close();
    super.dispose();
  }

  Future<void> _locateUser() async {
    try {
      userLocation = await Geolocator.getCurrentPosition();
      mapController.move(
          LatLng(userLocation.latitude!, userLocation.longitude!), 15.0);
    } catch (e) {
      if (kDebugMode) {
        print('Error locating user: $e');
      }
    }
  }

  Object _buildCenterWidget() {
    if (_currentLocationEnabled && userLocation != null) {
      // Ensure non-null doubles and construct LatLng directly
      return LatLng(
        _ensureDouble(userLocation?.latitude!),
        _ensureDouble(userLocation?.longitude!),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  double _ensureDouble(double? value) {
    return value ?? 0.0; // If value is null, use a default of 0.0
  }

  Widget _buildMarkerWidget() {
    if (_currentLocationEnabled && userLocation != null) {
      return Container(
        child: const Icon(Icons.location_on, color: Colors.blue),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialZoom: 9.2, // Default zoom level if location not available
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          tileProvider: CancellableNetworkTileProvider(),
        ),
        CurrentLocationLayer(
          alignPositionStream: _alignPositionStreamController.stream,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FloatingActionButton(
              onPressed: () {
                // Align the location marker to the center of the map widget
                // on location update until user interact with the map.
                setState(
                  () => _alignPositionOnUpdate = AlignOnUpdate.never,
                );
                // Align the location marker to the center of the map widget
                // and zoom the map to level 18.
                _alignPositionStreamController.add(18);
              },
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
        ),
        ...locations
            .map<Widget>(
              (loc) => LocationMarkerLayer(
                position: LocationMarkerPosition(
                  latitude: loc.lat,
                  longitude: loc.long,
                  accuracy: 0,
                ),
                style: LocationMarkerStyle(
                  marker: const DefaultLocationMarker(
                    child: Icon(
                      Icons.pin_drop,
                      color: Colors.red,
                    ),
                  ),
                  markerSize: const Size.square(40),
                  accuracyCircleColor: Colors.green.withOpacity(0.1),
                  headingSectorColor: Colors.green.withOpacity(0.8),
                  headingSectorRadius: 120,
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
