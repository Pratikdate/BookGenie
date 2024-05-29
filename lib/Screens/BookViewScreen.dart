import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../Controller/ReadBookController.dart';

class BookViewScreen extends StatelessWidget {
  const BookViewScreen({super.key, required this.file});
  final String file;

  @override
  Widget build(BuildContext context) {
    final ReadBookController controller = Get.put(ReadBookController());

    if (file.isNotEmpty) {
      controller.fetchPdfFromNetwork(file);
      ReadBookController.PDFFileBasename = basename(file);
    }

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.isFilePicked || controller.file != null) {
          return SfPdfViewer.file(
            controller.file!,
            key: controller.pdfViewerKey,
            controller: controller.pdfViewerController,
            onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
              controller.selectedTextLines = details.selectedText;
            },
            onPageChanged: (PdfPageChangedDetails details) {
              controller.savePage();
            },
          );
        } else {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                controller.handlePickedFile();
              },
              child: Text("Select PDF File"),
            ),
          );
        }
      }),
      floatingActionButton: Obx(() {
        return FloatingActionButton(
          onPressed: () {
            if (controller.isSearch.value) {
              controller.isSearch.value = false;
              controller.controller.clear();
            } else if (controller.selectedTextLines != null) {
              controller.isSearch.value = true;
              _showToast(context, controller.selectedTextLines!);
            } else {
              controller.isSearch.value = true;
            }
          },
          child: controller.isSearch.value
              ? SizedBox(
            height: 30,
            width: 200,
            child: TextField(
              controller: controller.controller,
              onSubmitted: (text) {
                _showToast(context, text);
              },
            ),
          )
              : Icon(Icons.search),
        );
      }),
    );
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 20),
        content: FutureBuilder<dynamic>(
          future: fetchDefinition(text),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              final data = snapshot.data;
              return _buildDefinitionWidget(data);
            } else {
              return Text("No data found");
            }
          },
        ),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<dynamic> fetchDefinition(String text) async {
    final response = await http.get(Uri.parse(
        "https://api.dictionaryapi.dev/api/v2/entries/en/${text.replaceAll(RegExp(r'[^\w\s]+'), '')}"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch definition');
    }
  }

  Widget _buildDefinitionWidget(dynamic data) {
    try {
      final meanings = data[0]['meanings'];
      final definitions = meanings[0]['definitions'];
      final partOfSpeech = meanings[0]['partOfSpeech'];
      final synonyms = meanings[0]['synonyms'];

      return SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Part of Speech: $partOfSpeech"),
            SizedBox(height: 6),
            if (synonyms != null && synonyms.isNotEmpty)
              Text("Synonyms: $synonyms", maxLines: 4),
            SizedBox(height: 6),
            if (definitions.isNotEmpty && definitions[0]['definition'] != null)
              Text("Definition: ${definitions[0]['definition']}", maxLines: 4),
            SizedBox(height: 6),
            if (definitions.isNotEmpty && definitions[0]['example'] != null)
              Text("Example: ${definitions[0]['example']}", maxLines: 4),
          ],
        ),
      );
    } catch (e) {
      return Text("Error parsing data");
    }
  }
}
