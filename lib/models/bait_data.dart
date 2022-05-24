import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'bait.dart';

class BaitData extends ChangeNotifier{
  final List<Bait> _myBaits = [
    Bait(name: 'Jig'),
    Bait(name: 'Worm'),
    Bait(name: 'Spook')
  ];

  UnmodifiableListView<Bait> get baitList {
    return UnmodifiableListView(_myBaits);
  }

  int get myBaitsCount {
    return _myBaits.length;
  }

  void addBait(baitName, tagList, description){
    _myBaits.add(Bait(name: baitName, tags: tagList, description: description));
    notifyListeners();
  }

  void deleteBait(Bait bait){
    _myBaits.remove(bait);
    notifyListeners();
  }

}