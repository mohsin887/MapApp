import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../model/place.dart';

class GreatPlaces with ChangeNotifier {
  final List<Place> _item = [];
  // String? location;

  List<Place> get items {
    return [..._item];
  }

  void addPlace(
    String title,
    XFile pickedImage,
  ) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      // location: location!,
      image: pickedImage,
    );
    _item.add(newPlace);
    notifyListeners();
  }
}
