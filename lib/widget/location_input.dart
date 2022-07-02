import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_place/helper/location_helper.dart';
import 'package:great_place/screen/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  const LocationInput({Key? key, required this.onSelectPlace})
      : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showMapPreview(double lat, double lon) {
    final staticMapUrl = LocationHelper.generateLocationPreviewImage(lat, lon);
    print('========Static Mao======= $staticMapUrl');

    setState(() {
      _previewImageUrl = staticMapUrl;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = await Location().getLocation();
      _showMapPreview(location.latitude!, location.longitude!);
      widget.onSelectPlace(location.latitude, location.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedMap = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => const MapScreen(isSelected: true),
      ),
    );
    if (selectedMap == null) {
      return;
    }
    _showMapPreview(selectedMap.latitude, selectedMap.longitude);
    widget.onSelectPlace(selectedMap.latitude, selectedMap.longitude);
    print(selectedMap.latitude);
    print(selectedMap.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: _previewImageUrl == null
              ? const Text(
                  'No Location choosen.',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              label: const Text(
                'Current Location',
              ),
              icon: const Icon(Icons.location_on),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton.icon(
              onPressed: _selectOnMap,
              label: const Text(
                'Select on Map',
              ),
              icon: const Icon(Icons.map),
            ),
          ],
        )
      ],
    );
  }
}
