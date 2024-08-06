import 'dart:convert';
import 'package:bookapp/core/ColorHandler.dart';
import 'package:bookapp/core/FontHandler.dart';
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

import 'features/book/data/datasouces/remote/auth_api_service.dart';
import 'features/book/data/repositories/auth_repository_impl.dart';
import 'features/book/dependency_injection.dart';
import 'features/book/domain/repositories/auth_repository.dart';
import 'features/book/domain/usecases/auth_usecase.dart';
import 'features/book/presentation/controllers/auth_controller.dart';
import 'features/book/presentation/pages/auth_screen.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';

import 'features/book/presentation/pages/home_screen.dart';

import 'package:http/http.dart' as http;

void init(){

  Get.lazyPut<RemoteAuthDataSource>(() => RemoteAuthDataSource(client: http.Client()));
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
  Get.lazyPut(() => LoginUseCase(Get.find()));
  Get.lazyPut(() => SignUpUseCase(Get.find()));
  Get.lazyPut(() => AuthStatusUseCase(Get.find()));
  Get.lazyPut(() => AuthController(
    loginUseCase: Get.find(),
    signUpUseCase: Get.find(),
    authStatusUseCase: Get.find(),
  ));
}


void main() async {
  init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized

  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final authController = Get.find<AuthController>();
      if (authController.isLoading.value) {
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  Spacer(),
                  Center(
                      child: Image.asset("asset/logo_BookGeany.png",fit: BoxFit.fill,height: 240,)
                  ),
                  const Spacer(),
                  const FontHandler(
                    "BookGenie",
                    color: ColorHandler.normalFont,
                    textAlign: TextAlign.end,
                    fontweight: FontWeight.bold,
                    fontsize: 30,
                  ),
                  SizedBox(height: 60,)
                ],
              ),
            ),
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
              initialBinding: DependencyBinding(),
              getPages: [
                GetPage(
                  name: '/auth',
                  page: () => AuthScreen(),
                  binding: DependencyBinding(),
                ),
                GetPage(
                  name: '/home',
                  page: () => HomeScreen(),
                  binding: DependencyBinding(),
                ),
                // Add other pages and bindings as needed
              ],
            );
          },
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
