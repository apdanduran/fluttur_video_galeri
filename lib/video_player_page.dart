import 'dart:io';
import 'package:flutter/material.dart';
import 'package:v1/video_settings.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;

  const VideoPlayerPage({Key key, this.videoPath}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState(videoPath);
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController playerController;
  VoidCallback listener;
  String videoPath;
  BuildContext context;
  double cameraHorizontalPosition = 0;
  Future<void> _controllerInizializer;
  _VideoPlayerPageState(this.videoPath);
  bool galeriyeKaydat = false;

  @override
  @override
  void initState() {
    super.initState();

    listener = () {};
    initializeVideo();
    playerController.play();
    _controllerInizializer = playerController.initialize();
    _controllerInizializer.whenComplete(() {
      setState(() {
        cameraHorizontalPosition = -(MediaQuery.of(context).size.width *
                playerController.value.aspectRatio) /
            2;
      });
    });
  }

  void initializeVideo() {
    playerController = VideoPlayerController.file(File(videoPath))
      ..addListener(listener)
      ..setVolume(1.0)
      ..initialize()
      ..play();
  }

  @override
  void deactivate() {
    if (playerController != null) {
      playerController.setVolume(0.0);
      playerController.removeListener(listener);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (playerController != null) playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            left: cameraHorizontalPosition,
            right: cameraHorizontalPosition,
            child: Container(
              child: (playerController != null
                  ? VideoPlayer(
                      playerController,
                    )
                  : Container()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => VideoSettingsPage(
                videoPath: videoPath,
              ),
            ),
          );
        },
        child: Icon(
          Icons.done,
          size: 20,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
