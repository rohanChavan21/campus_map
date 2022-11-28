import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_navigation/screens/campus_map.dart';

import '../constants/locations.dart';
import '../helpers/shared_prefs.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({Key? key}) : super(key: key);

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  List<Map<dynamic, dynamic>> _foundLocations = [];

  @override
  void initState() {
    _foundLocations = locations;
    super.initState();
  }

  void updateList(String enteredKeyword) {
    List<Map<dynamic, dynamic>> _result = [];

    if (enteredKeyword.isEmpty) {
      _result = locations;
    } else {
      _result = locations
          .where((element) => element['name']
              .toLowerCase()
              .Contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundLocations = _result;
    });
  }

  Widget cardButtons(IconData iconData, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () => CampusMap(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5),
          minimumSize: Size.zero,
        ),
        child: Row(
          children: [
            Icon(iconData, size: 16),
            const SizedBox(width: 2),
            Text(label)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Places'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Icon(Icons.search),
                ),
                onChanged: updateList,
                padding: const EdgeInsets.all(15),
                placeholder: 'Where would you like to go today?',
                style: TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              const SizedBox(height: 5),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: locations.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          height: 175,
                          width: 140,
                          fit: BoxFit.cover,
                          imageUrl: _foundLocations[index]['image'],
                        ),
                        // Image.asset(
                        //   locations[index]['image'],
                        // ),
                        Expanded(
                          child: Container(
                            height: 175,
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _foundLocations[index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(_foundLocations[index]['items']),
                                const Spacer(),
                                const Text('Waiting time: 2hrs'),
                                Text(
                                  'Closes at 10PM',
                                  style:
                                      TextStyle(color: Colors.redAccent[100]),
                                ),
                                Row(
                                  children: [
                                    cardButtons(
                                      Icons.location_on,
                                      'Navigate',
                                    ),
                                    const Spacer(),
                                    Text(
                                        '${(getDistanceFromSharedPrefs(index) / 1000).toStringAsFixed(2)}km'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
