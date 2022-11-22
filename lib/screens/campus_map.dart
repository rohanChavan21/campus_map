import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_navigation/helpers/commons.dart';

import '../constants/locations.dart';
import '../helpers/shared_prefs.dart';
import '../widgets/carousel_card.dart';

class CampusMap extends StatefulWidget {
  const CampusMap({Key? key}) : super(key: key);

  @override
  State<CampusMap> createState() => _CampusMapState();
}

class _CampusMapState extends State<CampusMap> {
  // Mapbox related
  LatLng latlng = getLatLngFromSharedPrefs();
  late CameraPosition _initialcameraPosition;
  late MapboxMapController controller;
  late List<CameraPosition> _locationList;
  List<Map> carouselData = [];

  // Carousel related
  int pageIndex = 0;
  bool accessed = false;
  late List<Widget> carouselItems;

  @override
  void initState() {
    super.initState();
    _initialcameraPosition = CameraPosition(target: latlng, zoom: 17);
    // Calculate the distance and time from data in SharedPreferences
    for (int index = 0; index < locations.length; index++) {
      num distance = getDistanceFromSharedPrefs(index) / 1000;
      num duration = getDurationFromSharedPrefs(index) / 60;
      carouselData.add(
        {'index': index, 'distance': distance, 'duration': duration},
      );
    }
    carouselData.sort((a, b) => a['duration'] < b['duration'] ? 0 : 1);

    // Generate the list of carousel widgets
    carouselItems = List<Widget>.generate(
      locations.length,
      (index) => carouselCard(carouselData[index]['index'],
          carouselData[index]['distance'], carouselData[index]['duration']),
    );

    // initialize map symbols in the same order as carousel widgets
    _locationList = List<CameraPosition>.generate(
      locations.length,
      (index) => CameraPosition(
        target: getLatLngFromLocationData(carouselData[index]['index']),
        zoom: 16,
      ),
    );
  }

  _addSourceAndLineLayer(int index, bool removeLayer) async {
    // Can animate camera to focus on the item
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        _locationList[index],
      ),
    );
    // Add a polyLine between source and destination
    Map geometry = getGeometryFromSharedPrefs(carouselData[index]['index']);
    final fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ],
    };

    // Remove lineLayer and source if it exists
    if (removeLayer == true) {
      await controller.removeLayer("lines");
      await controller.removeSource("fills");
    }

    // Add new source and lineLayer
    await controller.addSource(
      "fills",
      GeojsonSourceProperties(data: fills),
    );
    await controller.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Colors.green.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 2,
      ),
    );
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    for (CameraPosition _location in _locationList) {
      await controller.addSymbol(
        SymbolOptions(
          geometry: _location.target,
          iconSize: 0.2,
          iconImage: "assest/icon/food.png",
        ),
      );
    }
    _addSourceAndLineLayer(0, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Navigation'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              // height:
              // (mounted) ? MediaQuery.of(context).size.height * 0.8 : 200,
              height: MediaQuery.of(context).size.height * 0.8,
              child: MapboxMap(
                accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
                initialCameraPosition: _initialcameraPosition,
                onMapCreated: _onMapCreated,
                onStyleLoadedCallback: _onStyleLoadedCallback,
                myLocationEnabled: true,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                minMaxZoomPreference: const MinMaxZoomPreference(15.5, 18),
              ),
            ),
            CarouselSlider(
              items: carouselItems,
              options: CarouselOptions(
                height: 100,
                viewportFraction: 0.6,
                initialPage: 0,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
                onPageChanged:
                    (int index, CarouselPageChangedReason reason) async {
                  setState(
                    () {
                      pageIndex = index;
                    },
                  );
                  _addSourceAndLineLayer(index, true);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(_initialcameraPosition),
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
