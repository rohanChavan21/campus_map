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
  Widget _buildlistItem(int id, String title, String subtitle,
      Map<dynamic, dynamic> coordinates, String imgUrl) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: const EdgeInsets.all(8.0),
      trailing: IconButton(
        onPressed: () => {
          Navigator.pushNamed(
            context,
            NavigationScreen.routeName,
            arguments: {
              'latitude': coordinates['latitude'],
              'longitude': coordinates['longitude'],
              'id': id,
            },
          )
        },
        icon: const Icon(Icons.navigation_outlined),
      ),
      // const Spacer(),
      // Text(
      //     '${getDistanceFromSharedPrefs(index).toStringAsFixed(2)}m

      leading: Container(
        height: 60,
        width: 60,
        child: FittedBox(
          child: Image.asset(imgUrl),
          fit: BoxFit.contain,
          alignment: const Alignment(0.5, 0.5),
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
              const SizedBox(height: 5),
              //     return ListTile(
              //       title: Text(locations[index]['name']),
              //       subtitle: Text(locations[index]['items']),
              //       contentPadding: const EdgeInsets.all(8.0),
              //       trailing: IconButton(
              //         onPressed: () => {
              //           Navigator.pushNamed(
              //             context,
              //             NavigationScreen.routeName,
              //             arguments: {locations[index]['coordinates']},
              //           )
              //         },
              //         icon: const Icon(Icons.navigation_outlined),
              //       ),
              //       // const Spacer(),
              //       // Text(
              //       //     '${getDistanceFromSharedPrefs(index).toStringAsFixed(2)}m

              //       leading: Image.asset(
              //         locations[index]['image'],
              //       ),
              //     );
              //   },
              // ),
              _buildlistItem(
                  1,
                  'Saraswati Idol',
                  'Club meeting, PhotoShoot, events, Birthday, Peace',
                  {
                    'latitude': '16.84395552735782',
                    'longitude': '74.60173842596902',
                  },
                  'assets/image/saraswati_idol.jpg'),
              _buildlistItem(
                  2,
                  'Ajit Gulabchand Library',
                  'Study, Books, Newspaper, Magazine',
                  {
                    'latitude': '16.84423533154822',
                    'longitude': '74.6018126727777',
                  },
                  'assets/image/library.jpg'),
              _buildlistItem(
                  3,
                  'Main Gate',
                  'Entry,Exit,ParsalComes,DabbaComes',
                  {
                    'latitude': '16.846005416156103',
                    'longitude': '74.60258462531968',
                  },
                  'assets/image/main_gate.jpg'),
              _buildlistItem(
                  4,
                  'CSE Department',
                  'Computer Science, Labs, Classrooms, Apple Lab, mini CCF',
                  {
                    'latitude': '16.84560854643989',
                    'longitude': '74.60221840840376',
                  },
                  'assets/image/cse_dept.jpg'),
              _buildlistItem(
                5,
                'Cyber Hostel',
                'Students accomodation',
                {
                  'latitude': '16.845316151040933',
                  'longitude': '74.60231126707097',
                },
                'assets/image/cyber_hostel.jpg',
              ),
              _buildlistItem(
                6,
                'Lipton',
                ' Coofee, chai, Samosa, Breakfast, Chill, Friendzone',
                {
                  'latitude': '16.844462203879132',
                  'longitude': '74.60233789081025',
                },
                'assets/image/lipton.jpg',
              ),
              _buildlistItem(
                7,
                'Rector Office',
                'Hostel Addmission, Hostel doubts',
                {
                  'latitude': '16.8447948786974',
                  'longitude': '74.60251117102982',
                },
                'assets/image/rector_office.jpg',
              ),
              _buildlistItem(
                8,
                'Polytechnique Wing',
                'Diploma Addmision, Diploma Classes',
                {
                  'latitude': '16.844291583174353',
                  'longitude': '74.60241591746365',
                },
                'assets/image/polytechnique_wing.jpg',
              ),
              _buildlistItem(
                9,
                'Exam cell',
                'Exam, Grade Card, Exam doubt',
                {
                  'latitude': '16.843956552648578',
                  'longitude': '74.60231231493475',
                },
                'assets/image/exam_section.jpg',
              ),
              _buildlistItem(
                10,
                'Sai Canteen',
                'Nasta, Pohe, Samosa, chill,Coofee, chai, Breakfast, Chill, Friendzone ',
                {
                  'latitude': '16.843274696535488',
                  'longitude': '74.60189866841853',
                },
                'assets/image/canteen.jpg',
              ),
              _buildlistItem(
                11,
                'WCE Gym',
                'Workout, Training, Chess, Carrom, Exercise',
                {
                  'latitude': '16.843756642337624',
                  'longitude': '74.60157106046634',
                },
                'assets/image/wce_gym.jpg',
              ),
              _buildlistItem(
                12,
                'Walchand College Ground',
                'Sports, Cricket, Running, Play, couplesGoals,',
                {
                  'latitude': '16.843419155152205',
                  'longitude': '74.6010944373028',
                },
                'assets/image/wce_ground.jpg',
              ),
              _buildlistItem(
                13,
                'Tilak Hall',
                'Events, Gathering, Play, MeetUps',
                {
                  'latitude': '16.844462951646193',
                  'longitude': '74.60142721822041',
                },
                'assets/image/tilak_hall.jpg',
              ),
              _buildlistItem(
                14,
                'Open Theatre',
                'gathering, Dance, Play, Events',
                {
                  'latitude': '16.844622300619946',
                  'longitude': '74.60076623675295',
                },
                'assets/image/open_theatre.jpg',
              ),
              _buildlistItem(
                15,
                'Civil Department',
                'Drawing, Classes',
                {
                  'latitude': '16.844580141041334',
                  'longitude': '74.60017499164545',
                },
                'assets/image/civil_dept.jpg',
              ),
              _buildlistItem(
                16,
                'Mechanical Department',
                'Mechanics, Classes',
                {
                  'latitude': '16.84526136444424',
                  'longitude': '74.60070351589872',
                },
                'assets/image/mechanical_dept.jpg',
              ),
              _buildlistItem(
                17,
                'Department Of Electrical Engineering',
                'Electrical, classes',
                {
                  'latitude': '16.84523965723362',
                  'longitude': '74.60155293922392',
                },
                'assets/image/electrical_dept.jpg',
              ),
              _buildlistItem(
                18,
                'Academic Complex',
                'Admission, Classrooms',
                {
                  'latitude': '16.84489211134003',
                  'longitude': '74.60106802269144',
                },
                'assets/image/academic_complex.jpg',
              ),
              _buildlistItem(
                19,
                'Administration Building',
                'Admission',
                {
                  'latitude': '16.845663181492583',
                  'longitude': '74.6013309035929',
                },
                'assets/image/administration_complex.jpg',
              ),
              _buildlistItem(
                20,
                'Ganesh Temple',
                'Peace, Worship',
                {
                  'latitude': '16.84495234379368',
                  'longitude': '74.60188683770903',
                },
                'assets/image/ganesh_temple.jpg',
              ),
              _buildlistItem(
                21,
                'IT Department ',
                'IT Students, Computer Science ',
                {
                  'latitude': '16.845656504414023',
                  'longitude': '74.6008747923008',
                },
                'assets/image/it_dept.jpg',
              ),
            ],
          ),
        ),
      )),
    );
  }
}
