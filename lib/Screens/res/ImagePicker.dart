import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../Subscreens/UpdateProfile.dart';


class ImagePicker_ extends StatefulWidget {
  const ImagePicker_({
    super.key,
    this.isUpdateProfile = false,
    this.isVirtualProfile = false,
  });
  final bool isUpdateProfile;
  final bool isVirtualProfile;

  @override
  State<ImagePicker_> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker_> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;

  Future<void> _uploadImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }



  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          // AndroidUiSettings(
          //   toolbarTitle: 'Cropper',
          //   toolbarColor: Colors.deepOrange,
          //   toolbarWidgetColor: Colors.white,
          //   initAspectRatio: CropAspectRatioPreset.square,
          //   lockAspectRatio: false,
          //   aspectRatioPresets: [
          //     CropAspectRatioPreset.original,
          //     CropAspectRatioPreset.square,
          //     CropAspectRatioPreset.ratio4x3,
          //     //CropAspectRatioPresetCustom(),
          //   ],
          // ),
          AndroidUiSettings(
              toolbarTitle: 'Crop',
              cropGridColor: Colors.black,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),


        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;

          // if (widget.isUpdateProfile) {
          //   UpdateProfileScreen.croppedPath = croppedFile.path;
          //
          //   Navigator.pushReplacement(context,
          //       MaterialPageRoute(builder: (context) => UpdateProfileScreen()));
          // }

        });
      }
    }
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            "Crop Your Image",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: _pickedFile != null
                    ? Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.file(File( _pickedFile!.path)))
                    : const Center(
                  child: Text("Add a picture"),
                )),
            Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIconButton(icon: Icons.add, onpressed: _uploadImage),
                      _buildIconButton(icon: Icons.crop, onpressed: _cropImage),
                      _buildIconButton(icon: Icons.clear, onpressed: _clear),
                    ],
                  ),
                ))
          ],
        ));
  }

  Widget _buildIconButton(
      {required IconData icon, required void Function()? onpressed}) {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        child: IconButton(
          onPressed: onpressed,
          icon: Icon(icon),
          color: Colors.white,
        ));
  }
}



class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}