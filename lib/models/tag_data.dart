import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'tag.dart';

class TagData extends ChangeNotifier{
  final List<Tag> _myTags = [
    // Tag(title: 'No Wind'),
    // Tag(title: 'Sunny'),
    // Tag(title: 'Topwater')
  ];

  UnmodifiableListView<Tag> get tagList {
    return UnmodifiableListView(_myTags);
  }

  int get myTagsCount {
    return _myTags.length;
  }

  void addTag(tagTitle){
    _myTags.add(Tag(title: tagTitle));
    notifyListeners();
  }

  void deleteTag(Tag tag){
    _myTags.remove(tag);
    notifyListeners();
  }

}