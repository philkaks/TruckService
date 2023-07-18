// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


final truckchosen = StateProvider<int>((ref) {
  return 0;
});
// location provider
final locationProvider = StateProvider<LatLng>((ref) {
  return LatLng(0, 0);
});
