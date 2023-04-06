import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:googlemap_latlon/screens/signin_screen.dart';

import '../service/auth_services.dart';
import '../service/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var locationmessage = "";
  AuthService authService = AuthService();

  void getCurrentLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    //if service is notenabled
    if (!isServiceEnabled) {
      return Future.error("Location not enabled");
    }
    //status of permission
    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location permission denied forever");
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lastposition = await Geolocator.getLastKnownPosition();

    print(lastposition);
    var lat = position.latitude;
    var lon = position.longitude;

    setState(() {
      locationmessage = "latitude:$lat,longitude:$lon";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () async {
              await authService.signOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => true);
            },
            child: const Icon(
              Icons.exit_to_app,
            ),
          ),
          title: const Text('Location Services'),
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 158, 207, 247),
                borderRadius: BorderRadius.circular(10)),
            height: 300,
            width: 400,
            //color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 48,
                  color: Color(0xFFee7b64),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "GET USER LOCATION",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                locationmessage.isEmpty
                    ? const Text(
                        " Fecth Lat and Long",
                      )
                    : Text(
                        locationmessage,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                ElevatedButton(
                    onPressed: () {
                      NotificationService().showNotification(
                          title: 'LOCATION',
                          body: 'latitude &longitude fecthed');

                      getCurrentLocation();
                    },
                    child: const Text(
                      "Get current Location",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
