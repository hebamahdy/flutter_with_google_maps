import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CustomTrackerGoogleMap extends StatefulWidget {
  const CustomTrackerGoogleMap({super.key});

  @override
  State<CustomTrackerGoogleMap> createState() => _CustomTrackerGoogleMapState();
}

class _CustomTrackerGoogleMapState extends State<CustomTrackerGoogleMap> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  late Location location;
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        zoom: 17, target: LatLng(30.050432863521632, 31.237802109270767));
    location = Location();
    //checkAndRequireLocationService();
    updateMyLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (controller) {
        googleMapController = controller;
        initMapStyle();
      },
    );
  }

  void initMapStyle() async {
    var nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/night_map_style.json');
    googleMapController.setMapStyle(nightMapStyle);
  }

  Future<void> checkAndRequestLocationService() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        //show error bar
      }
    }

    //checkAndRequestLocationPermission();
  }

  Future<bool> checkAndRequestLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();

    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  void getLocationData() {
    location.onLocationChanged.listen((locationData) {});
  }

  void updateMyLocation() async {
    await checkAndRequestLocationService();
    var hasPermission = await checkAndRequestLocationPermission();
    if (hasPermission) {
      getLocationData();
    } else {}
  }
}
//inquire about location service
//request permission
//get location
//display
