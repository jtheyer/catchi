import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:catchi/screens/add_tag_modal.dart';
import 'package:provider/provider.dart';
import 'package:catchi/models/tag_data.dart';
import 'package:catchi/widgets/tag_list.dart';

class BaitsPg extends StatefulWidget {
  static const id = 'baitsPg';
  BaitsPg({Key? key}) : super(key: key);

  @override
  State<BaitsPg> createState() => _BaitsPgState();
}

class _BaitsPgState extends State<BaitsPg> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList;
  bool imageInView = false;
  final TextEditingController _baitDescController = TextEditingController();
  dynamic _pickImageError;
  bool isVideo = false;
  String? _retrieveDataError;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  @override
  void dispose() {
    _baitDescController.dispose();
    super.dispose();
  }

  void _saveBait(){
    //Put the image, desc, and tags into an object
    
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 350,
        maxHeight: 350,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      imageInView = true;
      return SafeArea(
        child: Semantics(
            child: ListView.builder(
              key: UniqueKey(),
              itemBuilder: (BuildContext context, int index) {
                // Why network for web?
                // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
                return Semantics(
                  label: 'Selected image',
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      kIsWeb
                          ? Image.network(_imageFileList![index].path)
                          : SizedBox(
                              height: 300,
                              width: 250,
                              child: Image.file(
                                File(_imageFileList![index].path),
                              ),
                            ),
                    ],
                  ),
                );
              },
              itemCount: _imageFileList!.length,
            ),
            label: 'Selected image'),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const FittedBox(
        child: Icon(
          Icons.image,
          size: 10.0,
        ),
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      isVideo = false;
      setState(() {
        _imageFile = response.file;
        _imageFileList = response.files;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Widget TagsDialog() {
    return const Dialog(
      child: Text('dialog'),
    );
  }

  Widget keyboardDismisser(
      {required BuildContext context, required Widget child}) {
    final gesture = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        debugPrint("Keyboard Dismissed!");
      },
      child: child,
    ); //GestureDector
    return gesture;
  }

  @override
  Widget build(BuildContext context) {
    return keyboardDismisser(
      context: context,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                flex: 2,
                child:
                    !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                        ? FutureBuilder<void>(
                            future: retrieveLostData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return const Text(
                                    'Awaiting image...',
                                    textAlign: TextAlign.center,
                                  );
                                case ConnectionState.done:
                                  return _handlePreview();
                                default:
                                  if (snapshot.hasError) {
                                    return Text(
                                      'Pick image/video error: ${snapshot.error}}',
                                      textAlign: TextAlign.center,
                                    );
                                  } else {
                                    return const Text(
                                      'No image for this bait yet.',
                                      textAlign: TextAlign.center,
                                    );
                                  }
                              }
                            },
                          )
                        : _handlePreview(),
              ),
              Flexible(
                flex: 1,
                // fit: FlexFit.tight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    minLines: 2,
                    controller: _baitDescController,
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Description/Notes (optional)',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 65.0),
                child: ElevatedButton(
                    child: const Text('+ Tag'),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AddTagModal((newTagTitle) {
                              setState(() {
                                Provider.of<TagData>(context, listen: false)
                                    .addTag(newTagTitle);
                              });
                            }),
                          ),
                        ),
                      );
                    }),
              ),
              const Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TagList(),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Semantics(
              label: 'image_picker_example_from_gallery',
              child: FloatingActionButton(
                onPressed: () {
                  isVideo = false;
                  _onImageButtonPressed(ImageSource.gallery, context: context);
                },
                heroTag: 'image0',
                tooltip: 'Pick Image from gallery',
                child: const Icon(Icons.photo),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  isVideo = false;
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                heroTag: 'image1',
                tooltip: 'Take a Photo',
                child: const Icon(Icons.camera_alt),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  _saveBait();
                },
                heroTag: 'image2',
                tooltip: 'Add to Tacklebox',
                child: const Icon(Icons.check),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

// Column(
//   mainAxisAlignment: MainAxisAlignment.start,
//   crossAxisAlignment: CrossAxisAlignment.stretch,
//   children: [
//     const SizedBox(height: 40.0),
//     Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 100.0),
//       child:
//            ElevatedButton(
//               child: const Icon(
//                 Icons.image,
//                 size: 150.0,
//               ),
//               onPressed: () {
//                 _takePicture();
//               },
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.grey),
//               ),
//             )
//           : Center(
//               // child: Image(
//               // image: photo,
//               child: _handlePreview()),
//           ),
//     const SizedBox(height: 20.0),
//     Center(
//       child: const Text('Press the icon to take a photo'),
//     ),
//   ],
// ),
