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
    return GestureDetector(
      onTap: () async {
        XFile image = await imagePicker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 50,
            preferredCameraDevice: CameraDevice.front);
        setState(() {
          _image = File(image.path);
        });
      },
      child: _image != null
          ? Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Image.file(
                _image,
                fit: BoxFit.fitHeight,
              ))
          : Container(
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColorLight,
                  borderRadius: BorderRadius.circular(5)),
              child: const Icon(
                Icons.image,
                color: Colors.white,
                size: 50,
              ),
            ),
    );
  }
}
