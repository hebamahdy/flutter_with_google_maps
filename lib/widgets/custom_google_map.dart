import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_google_maps/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  Set<Polyline> polyLines = {};
  Set<Polygon> polygons = {};
  Set<Circle> circles = {};
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        zoom: 12, target: LatLng(30.050432863521632, 31.237802109270767));
    initMarkers();
    initPolyLines();
    initPolygons();
    initCircles();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            polygons: polygons,
            polylines: polyLines,
            circles: circles,
            zoomControlsEnabled: false,
            markers: markers,
            //mapType: MapType.hybrid,
            mapType: MapType.normal,
            onMapCreated: (controller) {
              googleMapController = controller;
              initMapStyle();
            },
            // cameraTargetBounds: CameraTargetBounds(LatLngBounds(
            //     southwest: const LatLng(31.05651019874807, 29.82097325180651),
            //     northeast: const LatLng(31.26862069750076, 30.16704257583534))),
            initialCameraPosition: initialCameraPosition),
        Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ElevatedButton(
                onPressed: () {
                  // CameraPosition cameraPosition = const CameraPosition(
                  //     target: LatLng(29.74625924680959, 31.390448199193557),
                  //     zoom: 12);
                  // googleMapController.animateCamera(
                  //     CameraUpdate.newCameraPosition(cameraPosition));
                  googleMapController.animateCamera(CameraUpdate.newLatLng(
                      const LatLng(29.74625924680959, 31.390448199193557)));
                },
                child: const Text('Change Location')))
      ],
    );
  }

  void initMapStyle() async {
    var nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/night_map_style.json');
    googleMapController.setMapStyle(nightMapStyle);
  }

  void initMarkers() async {
    // var customMarkerIcon = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(), 'assets/images/map_marker.png');
    var customMarkerIcon = BitmapDescriptor.fromBytes(
        await getImageFromRowData('assets/images/map_marker.png', 100));
    Marker marker = const Marker(
        markerId: MarkerId('1'),
        position: LatLng(31.188767791441013, 29.89719090055096));
    markers.add(marker);

    markers.addAll(places
        .map(
          (placeModel) => Marker(
            icon: customMarkerIcon,
            infoWindow: InfoWindow(title: placeModel.name),
            position: placeModel.latLng,
            markerId: MarkerId(placeModel.id.toString()),
          ),
        )
        .toSet());
    setState(() {});
  }

  Future<Uint8List> getImageFromRowData(String image, double width) async {
    var imageData = await rootBundle.load(image);
    var imageCodec = await ui.instantiateImageCodec(
        imageData.buffer.asUint8List(),
        targetWidth: width.round());

    var imageFrameInfo = await imageCodec.getNextFrame();
    var imageByteData =
        await imageFrameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return imageByteData!.buffer.asUint8List();
  }

  void initPolyLines() {
    Polyline polyline = const Polyline(
        geodesic: true,
        patterns: [PatternItem.dot],
        width: 5,
        startCap: Cap.roundCap,
        color: Colors.red,
        points: [
          LatLng(31.214591594569665, 29.886538398626755),
          LatLng(31.182728381573018, 29.87795532999175),
          LatLng(31.185665532076037, 29.90464867318941),
          LatLng(31.196238519276392, 29.90782440855376),
          LatLng(31.209453092204477, 29.935032737060745),
        ],
        polylineId: PolylineId('1'));
    polyLines.add(polyline);
  }

  void initPolygons() {
    Polygon polygon = Polygon(
        holes: const [
          [
            LatLng(31.190291359290114, 29.901129616518393),
            LatLng(31.195798001699426, 29.89829720389614),
          ],
        ],
        strokeWidth: 3,
        fillColor: Colors.black.withOpacity(0.5),
        points: const [
          LatLng(31.215325643065565, 29.885165108771865),
          LatLng(31.18918999235753, 29.891602410425335),
          LatLng(31.185592104397045, 29.94189919214183),
        ],
        polygonId: const PolygonId('1'));
    polygons.add(polygon);
  }

  void initCircles() {
    Circle circle = Circle(
        fillColor: Colors.black.withOpacity(0.5),
        center: const LatLng(30.05040500336092, 31.238166889684244),
        radius: 10000,
        circleId: const CircleId('1'));
    circles.add(circle);
  }
  //world view 0->3
  //country view -> 4->6
  //city view  10->12
  //street view 13->17
  //building view 18->20
}
