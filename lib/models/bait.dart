import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Bait{
  /* The bait will be saved with:
  *   -- picture: take w/ camera or add later
  *   -- description: add now or later
  *   -- tags: "Add Catch" will use these tags to search for a saved bait.
  */
  // String description;
  // List tags;
  // XFile img;
// 
  // Bait({required this.tags});
  final String name;
  // Bait({required this.name, List? tags, String? description});
  Bait({required this.name, List? tags, String? description});


}