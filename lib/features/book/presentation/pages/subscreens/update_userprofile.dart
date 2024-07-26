import 'dart:io';
import 'dart:typed_data';
import 'package:bookapp/features/book/domain/%20entities/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/ColorHandler.dart';
import '../../../../../core/IconsHandler.dart';
import '../../controllers/menu_controllers/userprofile_controller.dart';



class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});
  static var croppedPath;

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final userName = TextEditingController();
  final userEmail = TextEditingController();
  final userabout = TextEditingController();
  late UserprofileController controller;


  var name;
  var email;
  var about;

  File? image;


  @override
  void initState() {
    super.initState();
    controller=Get.find();
    ImageHandler();
  }

  clear() {
    userName.clear();
    userEmail.clear();
    userabout.clear();
  }
  Future<void> _uploadImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {

        image = File(pickedFile.path);
      });
    }
  }


  final _formKey = GlobalKey<FormState>();

  setProfile() {
    try {

      //controller.profileInfo['image'] = image;

      controller.userProfile.value=UserProfile(

          name: name,
          email: email,
          personal_info: about,
          image: image?.path,
      );
      controller.isImageUpdate(true);


      controller.setUserProfile(imageFile: image!, email: email, name: name, profileInfo: about);

    } catch (e) {
      print("Error getting document: $e");
    }
  }

  ImageHandler() async {
    if (UpdateProfileScreen.croppedPath != null) {
      setState(() {
        //image = File(_pickedFile!.path);
      });
    }


  }



  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHandler.bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorHandler.bgColor,
        leading: IconButton(
          onPressed: () {
           Get.back();
          },
          icon: Icon(
            IconHandler.angle_left,
            color: ColorHandler.normalFont,
          ),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: ColorHandler.normalFont,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 30.sp),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 38.sp),
          child: Column(children: [
            Stack(children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.sp),
                  child: image != null
                      ? Image.file(image!)
                      : Image.network(
                    '${controller.userProfile.value.image}',
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                    width: 24.sp,
                    height: 24.sp,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.sp),
                        color: ColorHandler.normalFont),
                    child: IconButton(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(right: 0),
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ImagePicker_(
                        //           isUpdateProfile: true,
                        //         )));
                        _uploadImage();
                      },
                      icon: Icon(
                        IconHandler.camera,
                        color: ColorHandler.bgColor,
                        size: 20.sp,
                      ),
                    )),
              ),
            ]),
            SizedBox(
              height: 25.sp,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 50.sp,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: ColorHandler.normalFont,
                      label: Text("Full Name"),
                      prefixIcon: Icon(
                        IconHandler.person,
                      ),
                    ),
                    controller: userName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter name';
                      }
                    },
                  ),
                  SizedBox(
                    height: 25.sp,
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                        label: Text("E-Mail"),
                        prefixIcon: Icon(
                          IconHandler.mail,
                        ),
                      ),
                      controller: userEmail,
                      validator: validateEmail),


                  SizedBox(
                    height: 25.sp,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text("About"),
                      prefixIcon: Icon(
                        IconHandler.pass,
                      ),
                    ),
                    controller: userabout,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter about text';
                      }
                    },
                  ),
                  SizedBox(
                    height: 25.sp,
                  ),
                  SizedBox(
                    width: 200.sp,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.green,
                          minimumSize: Size(40.sp, 40.sp),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            try {
                              setState(() {
                                name = userName.text;
                                email = userEmail.text;

                                about = userabout.text;
                              });
                              setProfile();

                              //controller.isSetProfileInfo=true;
                              //controller.setUserProfileInfo(image!);

                              clear();
                              Get.back();

                            } catch (e) {}

                          }
                        },
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                              color: ColorHandler.bgColor, fontSize: 20.sp),
                        )),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
