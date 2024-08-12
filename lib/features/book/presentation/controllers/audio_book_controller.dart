import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioBookController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var speed = 1.0.obs;
  var src = ''.obs;
  var volume = 1.0.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  var selectedValue = 'Male'.obs;
  var thumbPosition = 0.0.obs;
  var sliderValue = 0.0.obs;
  var thumbChange=false.obs;

  @override
  void onInit() {
    super.onInit();

  }

  void initAudioPlayer() {
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      print("Audio player state changed to $state");
      if (state == PlayerState.playing) {
        isPlaying.value = true;
      } else {
        isPlaying.value = false;
      }
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      print("Audio duration changed to $duration");
      totalDuration.value = duration;
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      print("Audio position changed to $position");
      currentPosition.value = position;
    });

    audioPlayer.onPlayerStateChanged.listen((msg) {
      print('Audio player state change: $msg');

    });
  }

  void setSource(String url) {
    src.value = url;
    audioPlayer.setSource(UrlSource(src.value));
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      audioPlayer.pause();
    } else {
      audioPlayer.play(UrlSource(src.value));
    }
  }

  void skipBackward() {
    audioPlayer.seek(Duration(seconds: (currentPosition.value.inSeconds - 15).clamp(0, totalDuration.value.inSeconds)));
  }

  void skipForward() {
    audioPlayer.seek(Duration(seconds: (currentPosition.value.inSeconds + 15).clamp(0, totalDuration.value.inSeconds)));
  }

  void updateSpeed(double value) {
    speed.value = value;
    audioPlayer.setPlaybackRate(value);
  }

  void updateVolume(double value) {
    volume.value = value;
    audioPlayer.setVolume(value);
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
