import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'models/global.dart';
import 'models/technician.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            myLocationButtonEnabled: false,
          ),
          Container(
            padding: const EdgeInsets.only(top: 450, bottom: 10),
            child: ListView(
              padding: EdgeInsets.only(left: 20),
              children: getTechniciansInArea(),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('Chats')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), title: Text('Profile')),
          // BottomNavigationBarItem(icon: Icon(Icons)),
        ],
      ),
    );
  }

  List<Technician> getTechies() {
    List<Technician> techies = [];
    for (int i = 0; i < 10; i++) {
      AssetImage profilePic = new AssetImage("assets/profile.png");
      Technician myTechy = new Technician(
          "Oluwole Dr",
          "070-379-031",
          "First road 23 elm street",
          529.3,
          4,
          "Available",
          profilePic,
          "Electrician");
      techies.add(myTechy);
    }
    return techies;
  }

  List<Widget> getTechniciansInArea() {
    List<Technician> techies = getTechies();
    List<Widget> cards = [];
    for (Technician techy in techies) {
      cards.add(technicianCard(techy));
    }
    return cards;
  }
}

Map statusStyles = {
  'Available': statusAvailableStyle,
  'Unavailable': statusUnavailableStyle
};

Widget technicianCard(Technician technician) {
  return Container(
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.only(right: 20, bottom: 0),
    width: 180,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        new BoxShadow(
          color: Colors.grey,
          blurRadius: 20.0,
        ),
      ],
    ),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: CircleAvatar(
                backgroundImage: technician.profilePic,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  technician.name,
                  style: techCardTitleStyle,
                ),
                Text(
                  technician.occupation,
                  style: techCardSubTitleStyle,
                )
              ],
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            children: <Widget>[
              Text(
                "Status:  ",
                style: techCardSubTitleStyle,
              ),
              Text(technician.status, style: statusStyles[technician.status])
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Rating: " + technician.rating.toString(),
                    style: techCardSubTitleStyle,
                  )
                ],
              ),
              Container(
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  child: Row(children: getRatings(technician)))
            ],
          ),
        )
      ],
    ),
  );
}

List<Widget> getRatings(Technician techy) {
  List<Widget> ratings = [];
  for (int i = 0; i < 5; i++) {
    if (i < techy.rating) {
      ratings.add(new Icon(Icons.star, color: Colors.yellow));
    } else {
      ratings.add(new Icon(Icons.star_border, color: Colors.black));
    }
  }
  return ratings;
}
