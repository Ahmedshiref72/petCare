import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialPosition;

  MapScreen({required this.initialPosition});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late LatLng currentMarkerPosition;
  late Marker marker;

  @override
  void initState() {
    super.initState();
    currentMarkerPosition = widget.initialPosition;
    // Initialize the marker
    marker = Marker(
      markerId: MarkerId("m1"),
      position: currentMarkerPosition,
      draggable: true,
      onDragEnd: (newPosition) {
        // Update the marker position and print the new position
        setState(() {
          currentMarkerPosition = newPosition;
          print(
              'Marker dragged to: ${newPosition.latitude}, ${newPosition.longitude}');
        });
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTap(LatLng position) {
    // Update the marker position when the map is tapped
    setState(() {
      currentMarkerPosition = position;
      marker = marker.copyWith(positionParam: position);
      print('Map tapped at: ${position.latitude}, ${position.longitude}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onTap: _onMapTap, // Set the onTap property for the GoogleMap
        initialCameraPosition: CameraPosition(
          target: currentMarkerPosition,
          zoom: 15.0,
        ),
        markers: {marker}, // Use the marker set
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pop(context, currentMarkerPosition);
        },
      ),
    );
  }
}
