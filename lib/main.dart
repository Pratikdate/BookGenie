import 'dart:async';
import 'dart:io';
import 'package:bookapp/Auth/AuthScreen.dart';
import 'package:bookapp/Screens/BookViewScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:receive_intent/receive_intent.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'Screens/ReadBook.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Screens/BookHomeScreen.dart';
import 'package:get/get.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Book Store App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: FirebaseAuth.instance.currentUser!.isAnonymous?'/auth':'/home',
      getPages: [
        GetPage(name: '/auth', page: () => AuthScreen()),
        GetPage(name: '/home', page: () => BookStore()),
        GetPage(name: '/ReadBook', page: () => ReadBook()),

      ],
    );
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
