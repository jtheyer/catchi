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

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;

  String? _retrieveDataError;

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
                          : Image.file(File(_imageFileList![index].path)),
                      const TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      )
                    ],
                  ),
                );
              },
              itemCount: _imageFileList!.length,
            ),
            label: 'Selected images'),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.......',
        textAlign: TextAlign.center,
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
              ? FutureBuilder<void>(
                  future: retrieveLostData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Text(
                          'You have not yet picked an image.',
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
                            'You have not yet picked an image.',
                            textAlign: TextAlign.center,
                          );
                        }
                    }
                  },
                )
              : _handlePreview(),
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