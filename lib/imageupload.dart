import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Imageupload extends StatefulWidget {
  Imageupload({required this.onclick, required this.id, required this.img});

  final void Function(File pickimg) onclick;
  var id;
  String img;

  @override
  State<Imageupload> createState() => _ImageuploadState();
}

class _ImageuploadState extends State<Imageupload> {
  File? pickedimg;

  void pickimg() async {
    var pickedimg1 = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 150, imageQuality: 50);
    if (pickedimg1 == null) {
      return;
    }
    _cropImage(pickedimg1.path);
  }

  /// Crop Image
  _cropImage(String filePath) async {
    File croppedImage = (await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    )) as File;
    if (croppedImage != null) {
      pickedimg = croppedImage;
      setState(() {});
      widget.onclick(pickedimg!);
    }
  }

  void pickimg2() async {
    var pickedimg1 = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 150, imageQuality: 50);
    if (pickedimg1 == null) {
      return;
    }
    _cropImage(pickedimg1.path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.id == 'file')
          CircleAvatar(
            backgroundColor: Colors.black45,
            backgroundImage: pickedimg != null ? FileImage(pickedimg!) : null,
            radius: 50,
          ),
        if (widget.id == 'network')
          CircleAvatar(
            backgroundColor: Colors.black45,
            backgroundImage: NetworkImage(widget.img),
            radius: 50,
          ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: pickimg,
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.black45,
                ),
              ),
              IconButton(
                onPressed: pickimg2,
                icon: Icon(
                  Icons.image,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
