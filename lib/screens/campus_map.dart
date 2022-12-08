import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_navigation/helpers/commons.dart';
import 'package:mapbox_navigation/screens/navigation_screen.dart';

import '../constants/locations.dart';
import '../helpers/shared_prefs.dart';
import '../widgets/carousel_card.dart';

class CampusMap extends StatefulWidget {
  static const routeName = '/map-screen';
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
  // bool _loadedInitData = false;
  // LatLng? destination = null;

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

  // @override
  // void didChangeDependencies() {
  //   if (!_loadedInitData) {
  //     final routeArgs =
  //         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  //     final latitude = routeArgs['latitude'];
  //     final longitude = routeArgs['longitude'];
  //     destination = LatLng(latitude, longitude);
  //   }
  //   _loadedInitData = true;
  // }

  _addSourceAndLineLayer(int index, bool removeLayer) async {
    // Can animate camera to focus on the item
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        _locationList[index],
      ),
    );
    // Add a polyLine between source and destination
    Map geometry = getGeometryFromSharedPrefs(carouselData[index]['index']);
    // Map final_geometry = geometry;
    // for (int i = 0; i <= geometry.length; i++) {
    //   if (i == 0) {
    //     final_geometry[i] = [latlng.latitude, latlng.longitude];
    //   } else {
    //     final_geometry[i] = geometry[i - 1];
    //   }
    // }
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

    // await controller.addSymbolLayer(
    //   "fills",
    //   "lines",
    //   const SymbolLayerProperties(
    //     iconImage: 'assets/icon/th.png',
    //     iconSize: 0.5,
    //     textField: 'Destination',
    //     textColor: Colors.white,
    //     textAnchor: "top",
    //     iconTextFit: "none",
    //     textSize: 7,
    //   ),
    // );
    for (CameraPosition _location in _locationList) {
      await controller.addSymbol(
        SymbolOptions(
          geometry: _location.target,
          iconSize: 0.2,
          iconImage: "assets/icon/th.png",
          iconOpacity:
              _location.target == carouselData[index]['index'] ? 0.75 : 0.05,
        ),
      );
    }

    // await controller.addSymbol(
    //   SymbolOptions(
    //       geometry: geometry[geometry.length - 1],
    //       iconSize: 0.75,
    //       iconImage: 'assets/icon/th.png'),
    // );

    // Remove lineLayer and source if it exists
    if (removeLayer == true) {
      await controller.removeLayer("lines");
      await controller.removeSource("fills");
      // await controller.removeSymbol(
      //   Symbol(
      //     "lines",
      //     SymbolOptions(),
      //   ),
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
        lineWidth: 3,
        // lineOpacity: 0,
      ),
    );
    // await controller.addSymbols(SymbolOptions(
    //   geometry:
    // ));
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
          iconImage: "assets/icon/th.png",
          iconOpacity: 0.1,
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
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
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
                myLocationRenderMode: MyLocationRenderMode.NORMAL,
                // onUserLocationUpdated: (location) => setState(() {
                //   latlng = [
                //     location.position.latitude,
                //     location.position.longitude
                //   ] as LatLng;
                // }),
                // cameraTargetBounds: CameraTargetBounds(
                //   LatLngBounds(
                //     northeast: LatLng(16.844520514826883, 74.59821532994178),
                //     southwest: LatLng(16.842341570446195, 74.60467173950599),
                //   ),
                // ),
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

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults = [
    'Saraswati Idol',
    'Ajit Gulabchand Library',
    'Main Gate',
    'CSE Department',
    'Cyber Hostel',
    'Lipton',
    'Rector Office',
    'Polytechnique Wing',
    'Exam cell',
    'Sai Canteen',
    'WCE Gym',
    'Walchand College Ground',
    'Tilak Hall',
    'Open Theatre',
    'Civil Department',
    'Mechanical Department',
    'Department Of Electrical Engineering',
    'Academic Complex',
    'Administration Building',
    'Ganesh Temple',
    'IT Department ',
    'CCF',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: Icon(
            Icons.clear,
          ),
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: Icon(
          Icons.arrow_back,
        ),
      );

  @override
  Widget buildResults(BuildContext context) => NavigationScreen(query);

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
      itemCount: suggestions.length,
    );
    // throw UnimplementedError();
  }
}
