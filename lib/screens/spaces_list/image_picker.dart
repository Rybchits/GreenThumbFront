import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/app_theme.dart';
import 'package:image_picker/image_picker.dart';

class ImageFromGalleryEx extends StatefulWidget {
  const ImageFromGalleryEx({Key? key}) : super(key: key);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState();
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;

  ImageFromGalleryExState();

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 0,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                XFile image = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                    preferredCameraDevice: CameraDevice.front);
                setState(() {
                  _image = File(image.path);
                });
              },
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                width: 93,
                height: 77,
                child: _image != null
                    ? Container(

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.file(
                          _image,
                          width: 93,
                          height: 77,
                          fit: BoxFit.fitHeight,
                        ))
                    : Container(
                        decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColorLight,
                            borderRadius: BorderRadius.circular(10)),
                        width: 93,
                        height: 77,
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
