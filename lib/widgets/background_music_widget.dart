import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class BackgroundMusicWidget extends StatefulWidget {
  const BackgroundMusicWidget({super.key});

  @override
  State<BackgroundMusicWidget> createState() => _BackgroundMusicWidgetState();
}

class _BackgroundMusicWidgetState extends State<BackgroundMusicWidget> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    playBackgroundMusic();
    audioPlayer.onPlayerComplete.listen((event) {
      playBackgroundMusic();
    });
  }

  void playBackgroundMusic() async {
    await audioPlayer.play(
      AssetSource(
        'music/Mr_Smith-Azul.mp3',
        mimeType: 'audio/mpeg',
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
