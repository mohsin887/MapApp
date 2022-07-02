import 'package:flutter/foundation.dart';
import 'package:great_place/helper/location_helper.dart';
import 'package:image_picker/image_picker.dart';

import '../helper/db_helper.dart';
import '../model/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _item = [];
  // String? location;

  List<Place> get items {
    return [..._item];
  }

  Place findById(String id) {
    return _item.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String title,
    XFile pickedImage,
    PlaceLocation pickedLocation,
  ) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    print('==========ADDRESS===========');
    print(address);
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: updatedLocation,
      image: pickedImage,
    );
    _item.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lon': newPlace.location.longitude,
      'address': newPlace.location.address as String,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _item = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: XFile(
              item['image'],
            ),
            location: PlaceLocation(
              latitude: item['loc_lat'],
              longitude: item['loc_lon'],
              address: item['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }
}
