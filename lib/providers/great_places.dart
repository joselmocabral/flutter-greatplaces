import 'package:flutter/foundation.dart';
import 'dart:io';
//import 'package:intl/intl.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    fetchAndSet();
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addPlace(String title, String memory, File image,
      PlaceLocation pickedLocation, DateTime selectedDate) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address);
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      memory: memory,
      date: selectedDate,
      title: title,
      location: updatedLocation,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places4', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'memory' : newPlace.memory,
      'date': selectedDate.toIso8601String(),
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSet() async {
    final dataList = await DBHelper.getData('user_places4');

    _items = dataList.map((item) {
      return Place(
        id: item['id'],
        title: item['title'],
        memory: item['memory'],
        date: DateTime.parse(item['date']),
        image: File(item['image']),
        location: PlaceLocation(
          latitude: item['loc_lat'],
          longitude: item['loc_lng'],
          address: item['address'],
        ),
      );
    }).toList();
    notifyListeners();
  }

  Future<void> deletePlace(String id) async {
    await DBHelper.delete('user_places4', id);
    notifyListeners();
    return fetchAndSet();
  }
}
