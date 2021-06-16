import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places/middleware/dbHelper.dart';
import 'package:great_places/models/place.dart';

class GreatPlacesProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image) {
    var newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        image: image,
        location: null);
    _items.add(newPlace);
    notifyListeners();
    DbHelper.insert(
      'user_place',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path
      },
    );
  }

  Future<void> fetchAndSetPlace() async {
    final dataList = await DbHelper.getData('user_place');
    _items = dataList
        .map((item) => {
              Place(
                  id: item['id'],
                  title: item['title'],
                  image: File(item['image']),
                  location: null)
            })
        .cast<Place>()
        .toList();
    notifyListeners();
  }
}
