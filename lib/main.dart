import 'dart:convert';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:bookapp/Auth/AuthScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Controller/AuthController.dart';
import 'Screens/ReadBook.dart';
import '../Screens/BookHomeScreen.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(

    //Use when you want to work on design

    //         DevicePreview(
    //       enabled: true,
    //       tools: const [
    //         ...DevicePreview.defaultTools,
    //       ],
    //       builder: (BuildContext context) => MyApp(),
    //     )
    // );
      Phoenix(child: MyApp())
  );
}



class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.isLoading.value) {
        return MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      } else {
        return ScreenUtilInit(
            designSize: const Size(360, 640),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Book Store App',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                initialRoute: authController.isAuthenticated.value
                    ? '/home'
                    : '/auth',
                getPages: [
                  GetPage(name: '/auth', page: () => AuthScreen()),
                  GetPage(name: '/home', page: () => BookStore()),
                  GetPage(name: '/ReadBook', page: () => ReadBook()),
                ],
              );
            }
        );
      }
    });
  }
}


//
// void main()  {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//       Phoenix(
//           child:MyApp()
//       ));
// }
//
// class MyApp extends StatelessWidget {
//
//   final Future<FirebaseApp> _initialisation=Firebase.initializeApp();
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return FutureBuilder(
//         future: _initialisation,
//         builder: (context,snapshot){
//           if(snapshot.hasError){
//             print("something went wrong");
//
//
//           }
//           if(snapshot.connectionState==ConnectionState.done){
//             return  MaterialApp(
//               theme: ThemeData(
//                 primarySwatch: Colors.green,
//               ),
//               home: const MyHomePage(),
//               debugShowCheckedModeBanner: false,
//             );
//           }
//
//
//           return CircularProgressIndicator();
//
//         }
//     );
//
//
//
//
//   }
// }
//
//
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late File file;
//
//   @override
//   void initState() {
//     super.initState();
//     IntentHandler();
//   }
//
//   void IntentHandler() async {
//     await _initReceiveIntent()
//         ? Timer(
//         const Duration(seconds: 0),
//         // FirebaseAuth.instance.currentUser!.isAnonymous
//         //     ?
//           () => Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => ReadBook(file: file)))
//             //:() => Navigator.pushReplacement(
//             // context, MaterialPageRoute(builder: (context) => AuthScreen()))
//     )
//         : FirebaseAuth.instance.currentUser!.isAnonymous?
//         () => Navigator.pushReplacement(
//          context, MaterialPageRoute(builder: (context) => BookStore()))
//           :Timer(
//         const Duration(seconds: 1),
//             () => Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => AuthScreen())));
//   }
//
//   Future<bool> _initReceiveIntent() async {
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//
//       final receivedIntent = await ReceiveIntent.getInitialIntent();
//
//       if (receivedIntent!.isNotNull) {
//         File file_ = await toFile(receivedIntent.data.toString());
//         file = file_;
//
//         return true;
//       }
//
//       return false;
//
//       // Validate receivedIntent and warn the user, if it is not correct,
//       // but keep in mind it could be `null` or "empty"(`receivedIntent.isNull`).
//     } on PlatformException {
//       // Handle exception
//       return false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color:Colors.white70, child: Image.asset("asset/image/Logo.jpg"));
//   }
// }
//
