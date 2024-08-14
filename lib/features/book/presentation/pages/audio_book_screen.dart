import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:bookapp/features/book/presentation/controllers/audio_book_controller.dart';
import 'package:bookapp/features/book/presentation/pages/menu_pages/animation_videos.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
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
  final audiobook_duration = Get.arguments[0].audiobook_duration;
  final String? audiobookFile = Get.arguments[0].audiobook_file;

  List<String>? listAudioDuration;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  final AudioBookController audioBookController = Get.put(AudioBookController());

  @override
  void initState() {
    super.initState();
    print("audio book file $audiobookFile");

    try {
      if (audiobookFile == null || audiobookFile!.isEmpty) {
        throw Exception('Audiobook file is missing');
      }

      // Safely parse the audiobook duration
      listAudioDuration = audiobook_duration.split(':');
      if (listAudioDuration?.length == 3) {
        hours = int.parse(listAudioDuration![0]);
        minutes = int.parse(listAudioDuration![1]);
        seconds = int.parse(listAudioDuration![2]);
      } else {
        throw Exception('Invalid duration format');
      }

      print("Time of audio: ${audiobook_duration}");

      audioBookController.setSource("${Constants.BASE_URL}/$audiobookFile");
      audioBookController.initAudioPlayer();
    } catch (e) {
      print("Error initializing audio: $e");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load audiobook: $e'),backgroundColor: Colors.red,),
        );
      });
    }
  }

  Future<void> _handleMenuOption(String option, BuildContext context) async {
    switch (option) {
      case "Add Bookmark":
      // Implement add bookmark functionality
        break;
      case "Show Bookmarks":
      // Implement show bookmarks functionality
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
                    max: 5.0,
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
        ];
      },
      icon: const Icon(
        IconHandler.three_dot_menue,
        color: Colors.white,
      ),
    );
  }

  Color getColorForGenre(String genre) {
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

    return genreColors[genre] ?? Colors.grey;
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
                image: NetworkImage(bookImage),
                fit: BoxFit.fill,
              ),
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
                  color: getColorForGenre(genre),
                  boxShadow: [
                    BoxShadow(
                      color: getColorForGenre(genre),
                      blurRadius: 10.0,
                      spreadRadius: 8,
                    ),
                    BoxShadow(
                      color: getColorForGenre(genre),
                      blurRadius: 100.0,
                      spreadRadius: 90,
                    ),
                  ],
                ),
                alignment: Alignment.bottomCenter,
                height: 220,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: threeDotMenuButton(),
                    ),
                    FontHandler(
                      name,
                      color: ColorHandler.bgColor,
                      textAlign: TextAlign.left,
                      fontsize: 28,
                      fontweight: FontWeight.bold,
                    ),
                    SizedBox(height: 2),
                    FontHandler(
                      "by $author",
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
                    if (audiobookFile != null && audiobookFile!.isNotEmpty)
                      Obx(() {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ProgressBar(
                            progress: Duration(
                              seconds: audioBookController.currentPosition.value.inSeconds.toInt(),
                            ),
                            total: Duration(
                              hours: hours,
                              minutes: minutes,
                              seconds: seconds,
                            ),
                            baseBarColor: ColorHandler.bgColor,
                            progressBarColor: getColorForGenre(genre).withOpacity(0.9),
                            thumbColor: ColorHandler.bgColor,
                            onSeek: (duration) {
                              print('User selected a new time: $duration');
                              audioBookController.audioPlayer.seek(duration);
                              audioBookController.sliderValue.value = duration.inMinutes.toDouble();
                              audioBookController.thumbPosition.value = duration.inMinutes.toDouble();
                              audioBookController.thumbChange.value = true;
                            },
                          ),
                        );
                      })
                    else
                      SizedBox.shrink(),
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
