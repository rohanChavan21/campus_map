import 'package:mapbox_gl/mapbox_gl.dart';

import '../constants/locations.dart';

LatLng getLatLngFromLocationData(int index) {
  return LatLng(double.parse(locations[index]['coordinates']['latitude']),
      double.parse(locations[index]['coordinates']['longitude']));
}
