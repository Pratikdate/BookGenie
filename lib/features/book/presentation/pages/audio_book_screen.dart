import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:bookapp/features/book/presentation/controllers/audio_book_controller.dart';
import 'package:bookapp/features/book/presentation/pages/menu_pages/animation_videos.dart';
import 'package:flutter/material.dart';

import '../../../../core/ColorHandler.dart';
import '../../../../core/FontHandler.dart';

import 'package:get/get.dart';

import '../../../../core/IconsHandler.dart';
import '../../../../core/utils/constants.dart';

class AudiobookScreen extends StatefulWidget {
  @override
  _AudiobookScreenState createState() => _AudiobookScreenState();
}

class _AudiobookScreenState extends State<AudiobookScreen> {
  final bookImage = Get.arguments[0].image;
  final name = Get.arguments[0].name;
  final description = Get.arguments[0].description;
  final author = Get.arguments[0].author;
  final published = Get.arguments[0].published;
  final genre = Get.arguments[0].genre;

  final AudioBookController audioBookController =
      Get.put(AudioBookController());

  //final List<String> _options = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    try {
      audioBookController.setSource(
          "${Constants.BASE_URL}/${Get.arguments[0].audiobook_file}");
      audioBookController.initAudioPlayer();
    } catch (e) {
      print("something went wrong in audio");
    }
  }

  Future<void> _handleMenuOption(String option, BuildContext context) async {
    switch (option) {
      case "Add Bookmark":
        break;
      case "Show Bookmarks":
        break;
      case "Exit":
        Get.back();
        break;
    }
  }

  Widget threeDotMenuButton() {
    return PopupMenuButton<String>(
      color: getColorForGenre(genre).withOpacity(0.9),
      onOpened: () {},
      onSelected: (option) => _handleMenuOption(option, context),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: "Sound",
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FontHandler(
                    'Sound: ${audioBookController.volume.value.toStringAsFixed(1)}x',
                    color: ColorHandler.bgColor,
                    textAlign: TextAlign.left,
                  ),
                  Slider(
                    value: audioBookController.volume.value,
                    min: 0.5,
                    max: 2.0,
                    divisions: 4,
                    onChanged: audioBookController.updateVolume,
                  )
                ],
              );
            }),
          ),
          PopupMenuItem<String>(
            value: "Speed",
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FontHandler(
                    'Speed: ${audioBookController.speed.value.toStringAsFixed(1)}x',
                    color: ColorHandler.bgColor,
                    textAlign: TextAlign.left,
                  ),
                  Slider(
                    value: audioBookController.speed.value,
                    min: 0.5,
                    max: 2.0,
                    divisions: 4,
                    onChanged: audioBookController.updateSpeed,
                  )
                ],
              );
            }),
          ),
          // PopupMenuItem<String>(
          //   value: "Voice",
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const FontHandler(
          //         'Voice',
          //         color: ColorHandler.bgColor,
          //         textAlign: TextAlign.left,
          //       ),
          //       Obx(() {
          //         return DropdownButton<String>(
          //           dropdownColor: getColorForGenre(genre).withOpacity(0.9),
          //           value: audioBookController.selectedValue.value,
          //           hint: Text('Select an option'),
          //           items: _options.map((String option) {
          //             return DropdownMenuItem<String>(
          //               value: option,
          //               child: FontHandler(
          //                 option,
          //                 color: ColorHandler.bgColor,
          //                 textAlign: TextAlign.left,
          //               ),
          //             );
          //           }).toList(),
          //           onChanged: (String? newValue) {
          //             audioBookController.selectedValue.value = newValue!;
          //           },
          //         );
          //       }),
          //     ],
          //   ),
          // ),
        ];
      },
      icon: const Icon(
        IconHandler.three_dot_menue,
        color: Colors.white,
      ),
    );
  }

  Color getColorForGenre(String genre) {
    // Define a map of genres to colors
    final Map<String, Color> genreColors = {
      'Romance': Colors.pink[200]!,
      'Mystery': Colors.red[800]!,
      'Science Fiction': Colors.blueAccent,
      'Fantasy': Colors.grey[400]!,
      'Non-Fiction': Colors.blue[100]!,
      'Biography': Color(0xFFF5F5DC),
      'Self-Help': Colors.green[200]!,
      'Historical': Colors.amber[700]!,
      'Horror': Colors.deepPurple[800]!,
      'Adventure': Colors.green[800]!,
      'Young Adult': Colors.orange,
      'Children’s Books': Colors.yellow,
      'Cookbooks': Colors.red[400]!,
      'Travel': Colors.lightBlue,
      'Science & Nature': Colors.lightGreen,
      'Spiritual': Color(0xFF6A0D91),
      'Finance': Color(0xFF004d00),
      'Knowledge': Color(0xFFADD8E6)
    };

    // Return the color for the genre or a default color if not found
    return genreColors[genre] ??
        Colors.grey; // Default color if genre not found
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColorForGenre(genre),
        elevation: 0,
        title: const Text(
          'Audio Book',
          style: TextStyle(color: ColorHandler.bgColor),
        ),
      ),
      body: Stack(
        children: [
          // Book Cover Image
          Container(
            margin: EdgeInsets.only(top: 0),
            height: screenHeight * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    bookImage,
                  ), // Book cover image
                  fit: BoxFit.fill),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {

                audioBookController.thumbChange.value = false;
              },
              child: Container(
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.saturation,
                  color: getColorForGenre(genre), // Main background color
                  boxShadow: [
                    BoxShadow(
                        color: getColorForGenre(genre),
                        blurRadius: 10.0,
                        spreadRadius: 8),
                    BoxShadow(
                        color: getColorForGenre(genre),
                        blurRadius: 100.0,
                        spreadRadius: 90),
                  ],
                ),
                alignment: Alignment.bottomCenter,
                height: 220,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerRight,
                        child: threeDotMenuButton()),

                    // Title and Artist
                    FontHandler(
                      name,
                      color: ColorHandler.bgColor,
                      textAlign: TextAlign.left,
                      fontsize: 28,
                      fontweight: FontWeight.bold,
                    ),
                    SizedBox(height: 2),
                    FontHandler(
                      "by ${author}",
                      color: ColorHandler.bgColor,
                      textAlign: TextAlign.left,
                      fontsize: 18,
                      fontweight: FontWeight.bold,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.replay_10,
                            size: 40,
                            color: ColorHandler.bgColor,
                          ),
                          onPressed: audioBookController.skipBackward,
                        ),
                        Spacer(),
                        IconButton(
                          icon: Obx(() {
                            return Icon(
                              audioBookController.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 40,
                              color: ColorHandler.bgColor,
                            );
                          }),
                          onPressed: audioBookController.togglePlayPause,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.forward_10,
                            size: 40,
                            color: ColorHandler.bgColor,
                          ),
                          onPressed: audioBookController.skipForward,
                        ),
                        Spacer(),
                      ],
                    ),

                    Obx(() {
                      return Stack(children: [
                        Slider(
                          activeColor: getColorForGenre(genre).withOpacity(0.9),
                          thumbColor: ColorHandler.bgColor,
                          value: audioBookController
                              .currentPosition.value.inSeconds
                              .toDouble(),
                          max: audioBookController.totalDuration.value.inSeconds
                              .toDouble(),
                          onChanged: (value) {
                            audioBookController.audioPlayer
                                .seek(Duration(seconds: value.toInt()));
                            audioBookController.sliderValue.value = value;

                            audioBookController.thumbPosition.value =
                                value; //*  audioBookController.sliderValue.value;
                            audioBookController.thumbChange.value = true;
                          },
                        ),

                        // Tooltip
                        audioBookController.thumbChange.value
                            ? Positioned(
                                left: audioBookController.thumbPosition.value +
                                    10, // Offset to center the tooltip
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    '${(audioBookController.sliderValue.value).toStringAsFixed(0)}%',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ]);
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
