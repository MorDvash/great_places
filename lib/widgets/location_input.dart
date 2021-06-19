import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/middleware/location_helper.dart';
import 'package:great_places/screen/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key}) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImage;

  Future<void> getCurrentLocation() async {
    final locationData = await Location().getLocation();
    final _staticImage = LocationHelper.generateLocationPreviewImage(
        locationData.latitude as double, locationData.longitude as double);
    print(_staticImage);
    setState(() {
      _previewImage = _staticImage;
      print(_previewImage);
    });
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    print(selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImage == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImage as String,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.location_on),
              onPressed: getCurrentLocation,
              label: const Text('Current location'),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.map),
              onPressed: _selectOnMap,
              label: const Text('Select on the map'),
            ),
          ],
        )
      ],
    );
  }
}
