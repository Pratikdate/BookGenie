// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
// import '../Controller/ReadBookController.dart';
//
// class BookViewScreen extends StatefulWidget {
//   BookViewScreen({super.key});
//
//   @override
//   State<BookViewScreen> createState() => _BookViewScreenState();
// }
//
// class _BookViewScreenState extends State<BookViewScreen> {
//   final ReadBookController controller = Get.put(ReadBookController());
//   TextEditingController textEditingController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller.fetchPdfFromNetwork();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     controller.loadPage();
//
//     if (controller.fileUrl.value.isNotEmpty) {
//       controller.PDFFileBasename.value = basename(controller.fileUrl.value);
//     }
//
//     return Scaffold(
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (controller.isFilePicked.value || controller.file != null) {
//           return SfPdfViewer.file(
//             controller.file!,
//             key: controller.pdfViewerKey,
//             controller: controller.pdfViewerController,
//             onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
//               controller.selectedTextLines = details.selectedText;
//             },
//             onPageChanged: (PdfPageChangedDetails details) {
//               controller.savePage();
//               controller.isSearch.value = false;
//             },
//           );
//         } else {
//           return Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 controller.handlePickedFile();
//               },
//               child: Text("Select PDF File"),
//             ),
//           );
//         }
//       }),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color.fromRGBO(51, 51, 51, 1),
//         onPressed: () {
//           if (controller.isSearch.value) {
//             controller.isSearch.value = false;
//             controller.controller.clear();
//           } else if (controller.selectedTextLines != null) {
//             controller.isSearch.value = false;
//             _showToast(context, text: controller.selectedTextLines!);
//           } else {
//             controller.isSearch.value = true;
//             _showToast(context);
//           }
//         },
//         child: Icon(Icons.search, color: Colors.white),
//       ),
//     );
//   }
//
//   void _showToast(BuildContext context, {String text = ""}) {
//     final scaffold = ScaffoldMessenger.of(context);
//     scaffold.showSnackBar(
//       SnackBar(
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(30),
//           ),
//         ),
//         backgroundColor: Color.fromRGBO(34, 34, 34, 1),
//         duration: const Duration(seconds: 40),
//         content: FutureBuilder<dynamic>(
//           future: fetchDefinition(text),
//           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator(color: Colors.white));
//             } else if (snapshot.hasError) {
//               if (text == "") {
//                 return SizedBox(
//                   height: 35,
//                   width: 400,
//                   child: TextField(
//                     controller: textEditingController,
//                     decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Color.fromRGBO(34, 34, 34, 1), width: 1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       labelText: 'Search Meaning',
//                       fillColor: Colors.white,
//                       filled: true,
//                     ),
//                     onSubmitted: (text_) {
//                       _showToast(context, text: text_);
//                       scaffold.hideCurrentSnackBar();
//                     },
//                   ),
//                 );
//               } else {
//                 return Text("Error: ${snapshot.error}");
//               }
//             } else if (snapshot.hasData) {
//               final data = snapshot.data;
//               return _buildDefinitionWidget(data);
//             } else {
//               return Text("No data found");
//             }
//           },
//         ),
//         action: SnackBarAction(
//           label: 'UNDO',
//           onPressed: scaffold.hideCurrentSnackBar,
//         ),
//       ),
//     );
//   }
//
//   Future<dynamic> fetchDefinition(String text) async {
//     final response = await http.get(Uri.parse(
//         "https://api.dictionaryapi.dev/api/v2/entries/en/${text.replaceAll(RegExp(r'[^\w\s]+'), '')}"));
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to fetch definition');
//     }
//   }
//
//   Widget _buildDefinitionWidget(dynamic data) {
//     try {
//       final meanings = data[0]['meanings'];
//       final definitions = meanings[0]['definitions'];
//       final partOfSpeech = meanings[0]['partOfSpeech'];
//       final synonyms = meanings[0]['synonyms'];
//
//       return SizedBox(
//         width: 180,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Part of Speech: $partOfSpeech"),
//             SizedBox(height: 6),
//             if (synonyms != null && synonyms.isNotEmpty)
//               Text("Synonyms: $synonyms", maxLines: 4),
//             SizedBox(height: 6),
//             if (definitions.isNotEmpty && definitions[0]['definition'] != null)
//               Text("Definition: ${definitions[0]['definition']}", maxLines: 4),
//             SizedBox(height: 6),
//             if (definitions.isNotEmpty && definitions[0]['example'] != null)
//               Text("Example: ${definitions[0]['example']}", maxLines: 4),
//           ],
//         ),
//       );
//     } catch (e) {
//       return Text("Error parsing data");
//     }
//   }
// }
