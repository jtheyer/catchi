import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  _tc() => TextEditingController();
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

  _addTag(val) {
    print(val);
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
                          : Image.file(File(_imageFileList![index].path)),
                      // const SizedBox(
                      //   height: 10,
                      // ),
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
                flex: 3,
                // fit: FlexFit.tight,
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
                    // keyboardType: TextInputType.multiline,
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
              const Flexible(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 150, 0),
                  child: TextField(
                    // controller: _tc(),
                    // onEditingComplete: (){ print('done');},
                    onChanged: ,
                    // maxLength: 25,
                    decoration: InputDecoration(
                      hintText: '\t\tTag bait! ( 1 at a time)'
                    ),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [

              //   ],
              // ),
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
                heroTag: 'image2',
                tooltip: 'Take a Photo',
                child: const Icon(Icons.camera_alt),
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
