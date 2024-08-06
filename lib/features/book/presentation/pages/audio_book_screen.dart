import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../../core/ColorHandler.dart';
import '../../../../core/FontHandler.dart';

import 'package:get/get.dart';

class AudiobookScreen extends StatefulWidget {
  @override
  _AudiobookScreenState createState() => _AudiobookScreenState();
}

class _AudiobookScreenState extends State<AudiobookScreen> {

  final bookImage=Get.arguments[0].image;
  final name=Get.arguments[0].name;
  final description=Get.arguments[0].description;
  final author=Get.arguments[0].author;
  final published=Get.arguments[0].published;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  double _speed = 1.0;
  double _volume = 1.0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  final String _coverUrl = 'https://example.com/book_cover.jpg'; // Replace with your cover image URL
  final String _title = 'Book Title'; // Replace with your title
  final String _artist = 'Author Name'; // Replace with your artist name

  @override
  void initState() {
    super.initState();
    //_audioPlayer.setUrl('https://www.example.com/audiofile.mp3'); // Replace with your audio file URL
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });
    // _audioPlayer.onAudioPositionChanged.listen((position) {
    //   setState(() {
    //     _currentPosition = position;
    //   });
    // });
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _audioPlayer.pause();
      } else {
       // _audioPlayer.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _skipBackward() {
    _audioPlayer.seek(Duration(seconds: (_currentPosition.inSeconds - 15).clamp(0, _totalDuration.inSeconds)));
  }

  void _skipForward() {
    _audioPlayer.seek(Duration(seconds: (_currentPosition.inSeconds + 15).clamp(0, _totalDuration.inSeconds)));
  }

  void _updateSpeed(double value) {
    setState(() {
      _speed = value;
      //_audioPlayer.setPlaybackRate(playbackRate: _speed);
    });
  }

  void _updateVolume(double value) {
    setState(() {
      _volume = value;
      _audioPlayer.setVolume(_volume);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;

    return Scaffold(
      appBar: AppBar(

        backgroundColor:ColorHandler.normalFont,
        elevation: 0,
        title: Text('Now Playing',style: TextStyle(color: ColorHandler.bgColor),),
      ),
      body: Stack(
        children: [

          // Book Cover Image
          Container(
            margin: EdgeInsets.only(top: 0),
            height: screenHeight *0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(bookImage,), // Book cover image
                  fit: BoxFit.fill
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,

              child: Container(

                decoration: const BoxDecoration(
                    color: ColorHandler.normalFont,  //Color(0xFF66BB6A),
                    boxShadow: [
                      BoxShadow(
                      color: ColorHandler.normalFont,
                      blurRadius: 8.0,
                        spreadRadius: 10
                    ),
                      BoxShadow(
                        color: ColorHandler.normalFont,
                        blurRadius: 70.0,
                          spreadRadius: 90
                      ),
                    ]
                ),
                  alignment: Alignment.bottomCenter,
                  height:180,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title and Artist
                      FontHandler(
                        name,
                        color: ColorHandler.bgColor,
                        textAlign: TextAlign.left,
                        fontsize: 28,
                        fontweight: FontWeight.bold,
                      ),
                      SizedBox(height: 4),
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
                              icon: Icon(Icons.replay_10,size: 40,color: ColorHandler.bgColor,),
                              onPressed: _skipBackward,
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,size: 40,color: ColorHandler.bgColor,),
                              onPressed: _togglePlayPause,
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.forward_10,size: 40,color: ColorHandler.bgColor,),

                              onPressed: _skipForward,
                            ),
                            Spacer(),
                          ],
                        ),

                      Slider(
                        thumbColor: ColorHandler.bgColor,
                        value: _currentPosition.inSeconds.toDouble(),
                        max: _totalDuration.inSeconds.toDouble(),
                        onChanged: (value) {
                          _audioPlayer.seek(Duration(seconds: value.toInt()));
                        },
                      ),

                      // Speed and Volume Controls
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Column(
                      //         children: [
                      //           Text('Speed: ${_speed.toStringAsFixed(1)}x'),
                      //           Slider(
                      //             value: _speed,
                      //             min: 0.5,
                      //             max: 2.0,
                      //             divisions: 3,
                      //             onChanged: _updateSpeed,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Column(
                      //         children: [
                      //           Text('Volume: ${(100 * _volume).toStringAsFixed(0)}%'),
                      //           Slider(
                      //             value: _volume,
                      //             min: 0.0,
                      //             max: 1.0,
                      //             onChanged: _updateVolume,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
            ),


        ],
      ),
    );
  }
}
