import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_navigation/screens/campus_map.dart';
import 'package:mapbox_navigation/screens/navigation_screen.dart';

import '../constants/locations.dart';
import '../helpers/shared_prefs.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({Key? key}) : super(key: key);

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  // List<Map<dynamic, dynamic>> _foundLocations = [];

  // @override
  // void initState() {
  //   _foundLocations = locations;
  //   super.initState();
  // }

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
              // CupertinoTextField(
              //   prefix: const Padding(
              //     padding: EdgeInsets.only(left: 15),
              //     child: Icon(Icons.search),
              //   ),
              //   onChanged: updateList,
              //   padding: const EdgeInsets.all(15),
              //   placeholder: 'Where would you like to go today?',
              //   style: const TextStyle(color: Colors.white),
              //   decoration: const BoxDecoration(
              //     color: Colors.black54,
              //     borderRadius: BorderRadius.all(Radius.circular(5)),
              //   ),
              // ),
              const SizedBox(height: 5),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: locations.length,
                itemBuilder: (BuildContext context, int index) {
                  // return Card(
                  //   clipBehavior: Clip.antiAlias,
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(15)),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       CachedNetworkImage(
                  //         height: 175,
                  //         width: 140,
                  //         fit: BoxFit.cover,
                  //         imageUrl: _foundLocations[index]['image'],
                  //       ),
                  //       // Image.asset(
                  //       //   locations[index]['image'],
                  //       // ),
                  //       Expanded(
                  //         child: Container(
                  //           height: 175,
                  //           padding: const EdgeInsets.all(15),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 _foundLocations[index]['name'],
                  //                 style: const TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     fontSize: 16),
                  //               ),
                  //               Text(_foundLocations[index]['items']),
                  //               const Spacer(),
                  //               const Text('Waiting time: 2hrs'),
                  //               Text(
                  //                 'Closes at 10PM',
                  //                 style:
                  //                     TextStyle(color: Colors.redAccent[100]),
                  //               ),
                  //               Row(
                  //                 children: [
                  //                   cardButtons(
                  //                     Icons.location_on,
                  //                     'Navigate',
                  //                   ),
                  //                   const Spacer(),
                  //                   Text(
                  //                       '${(getDistanceFromSharedPrefs(index) / 1000).toStringAsFixed(2)}km'),
                  //                 ],
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // );
                  return ListTile(
                    title: Text(locations[index]['name']),
                    subtitle: Text(locations[index]['items']),
                    contentPadding: const EdgeInsets.all(8.0),
                    trailing: Row(
                      children: [
                        IconButton(
                          onPressed: () => {
                            Navigator.pushNamed(
                              context,
                              NavigationScreen.routeName,
                              arguments: {locations[index]['coordinates']},
                            )
                          },
                          icon: const Icon(Icons.navigation_outlined),
                        ),
                        const Spacer(),
                        Text(
                            '${getDistanceFromSharedPrefs(index).toStringAsFixed(2)}m'),
                      ],
                    ),
                    leading: Image.asset(
                      locations[index]['image'],
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
