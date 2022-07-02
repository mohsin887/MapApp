import 'dart:convert';

import 'package:http/http.dart' as http;

// const apiKey = 'AIzaSyB5pan3iafSwAIv2o5XdLJI_ZvfTSCMDfI';
const apiKey = 'AIzaSyCrjmr0iFbaySNjUajBGtmJx9iehpyr4dY';

class LocationHelper {
  static String generateLocationPreviewImage(
      double latitude, double longitude) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&NY&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$latitude,$longitude&markers=color:green%7Clabel:G%7C$latitude,$longitude&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$apiKey';
  }

  static Future<String> getPlaceAddress(double lat, double lon) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=$apiKey');
    final response = await http.get(url);
    print('==============JSON DATA=============${json.decode(response.body)}');
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
