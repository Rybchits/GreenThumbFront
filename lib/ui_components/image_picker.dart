import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/app_theme.dart';
import 'package:green_thumb_mobile/domain/secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageFromGalleryEx extends StatefulWidget {
  const ImageFromGalleryEx(
      {Key? key, required this.setImage, this.initialImageUrl})
      : super(key: key);

  final void Function(File) setImage;
  final String? initialImageUrl;

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
    var image = _image != null
        ? Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Image.file(
              _image,
              fit: BoxFit.fitHeight,
            ))
        : widget.initialImageUrl != null
            ? Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/VstuLogo.jpg",
                  image: Uri.http(Session.SERVER_IP, widget.initialImageUrl!)
                      .toString(),
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Image.asset("assets/images/VstuLogo.jpg"),
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
              );

    return GestureDetector(
        onTap: () async {
          XFile image =
              await imagePicker.pickImage(source: ImageSource.gallery);
          File file = File(image.path);

          setState(() {
            _image = file;
          });
          widget.setImage(file);
        },
        child: image);
  }
}
