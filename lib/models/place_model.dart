import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latLng;

  PlaceModel({
    required this.id,
    required this.name,
    required this.latLng,
  });
}

List<PlaceModel> places = [
  PlaceModel(
      id: 1,
      name: 'Woods Cafe & Restaurant',
      latLng: const LatLng(31.232734067870048, 29.936191521207544)),
  PlaceModel(
      id: 2,
      name: 'The Loft Restaurant & Cafe',
      latLng: const LatLng(31.210714176611535, 29.950611076375417)),
  PlaceModel(
    id: 3,
    name: 'Santiago Restaurant & Cafe',
    latLng: const LatLng(31.252694334676086, 29.975330313806044),
  ),
];
