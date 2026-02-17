import 'package:get/get.dart';

import 'models/trip.dart';

class TripsController extends GetxController {
  final trips = <Trip>[
    const Trip(name: "vn"),
  ].obs;

  void addTrip({required String name, String description = ""}) {
    trips.add(Trip(name: name, description: description));
  }
}
