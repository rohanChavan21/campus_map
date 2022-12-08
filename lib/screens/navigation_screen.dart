import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_navigation/helpers/shared_prefs.dart';

import '../constants/locations.dart';
import '../helpers/commons.dart';
import '../widgets/carousel_card.dart';

class NavigationScreen extends StatefulWidget {
  static const routeName = '/navigate';
  final String query;
  const NavigationScreen(this.query, {Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  LatLng latlng = getLatLngFromSharedPrefs();
  late CameraPosition _initialcameraPosition;
  late LatLng destination;
  late MapboxMapController controller;
  late List<CameraPosition> _locationList;
  List<Map> carouselData = [];
  late List<Widget> carouselItems;
  late CameraPosition destinationCamera;
  bool _loadedInitData = false;
  late int id;

  @override
  void initState() {
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

    // destination = ModalRoute.of(context)?.settings.arguments([] ?? );

    // destinationCamera = CameraPosition(target: latlng, zoom: 17);
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
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      final routeArgs = (ModalRoute.of(context)?.settings.arguments ??
          <dynamic, dynamic>{}) as Map<dynamic, dynamic>;
      if (routeArgs.isEmpty) {
        int element = 0;
        for (int i = 0; i < locations.length; i++) {
          if (widget.query == locations[i]['name']) {
            element = i;
            break;
          }
        }
        destination = locations[element]['coordinates'];
      } else {
        destination = LatLng(
          double.parse(routeArgs['latitude']),
          double.parse(
            routeArgs['longitude'],
          ),
        );
        destinationCamera = CameraPosition(target: destination, zoom: 17.5);
        id = routeArgs['id'];
      }
    }
    _loadedInitData = true;
    super.didChangeDependencies();
  }

  _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
  }

  // _onStyleLoadedCallback() async {
  //   await
  // }

  _addSourceAndLineLayer(bool removeLayer) async {
    late int index = id;
    // for (int i = 0; i < locations.length; i++) {
    //   if (destination.latitude == locations[i]['coordinates']['latitude'] &&
    //       destination.longitude == locations[i]['coordinates']['longitude']) {
    //     index = i;
    //   }
    // }
    controller.animateCamera(
      CameraUpdate.newCameraPosition(destinationCamera),
    );

    Map geometry = getGeometryFromSharedPrefs(index);
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

    await controller.addSymbolLayer(
      "fills",
      "lines",
      const SymbolLayerProperties(
        iconImage: 'assets/icon/th.png',
        iconSize: 0.75,
        textField: 'Destination',
        iconTextFit: "none",
        textSize: 4,
      ),
    );

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
        lineWidth: 2.2,
        lineOpacity: 0.75,
        // lineOpacity: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation screen'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: MapboxMap(
                initialCameraPosition: _initialcameraPosition,
                accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
                onMapCreated: _onMapCreated,
                // onStyleLoadedCallback: _addSourceAndLineLayer(false),
                myLocationEnabled: true,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                myLocationRenderMode: MyLocationRenderMode.NORMAL,
                minMaxZoomPreference: const MinMaxZoomPreference(16, 19),
                onUserLocationUpdated: ((location) {
                  setState(() {
                    latlng = [
                      location.position.latitude,
                      location.position.longitude
                    ] as LatLng;
                    _addSourceAndLineLayer(false);
                  });
                }),
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
