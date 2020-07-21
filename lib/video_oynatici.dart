import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:v1/video_player_page.dart';

class CameraPage extends StatefulWidget {
  CameraPage({Key key, this.controller}) : super(key: key);

  final PageController controller;
  final double iconHeight = 30;

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  CameraController _controller;
  Future<void> _controllerInizializer;
  double cameraHorizontalPosition = 0;
  String videoPath;
  bool butondegis = false;
  List categories = ['5 saniye', '10 saniye', 'Canlı yayın'];
  int selectedIndex = 0;
  int _start = 0;
  Timer _timer;
  String filePath;
  Future<CameraDescription> getCamera() async {
    final c = await availableCameras();
    return c.first;
  }

  @override
  void initState() {
    super.initState();

    getCamera().then((camera) {
      if (camera == null) return;
      setState(() {
        _controller = CameraController(
          camera,
          ResolutionPreset.high,
        );
        _controllerInizializer = _controller.initialize();
        _controllerInizializer.whenComplete(() {
          setState(() {
            cameraHorizontalPosition = -(MediaQuery.of(context).size.width *
                    _controller.value.aspectRatio) /
                2;
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned.fill(
          left: cameraHorizontalPosition,
          right: cameraHorizontalPosition,
          child: FutureBuilder(
            future: _controllerInizializer,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        Positioned.fill(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: Icon(Icons.settings),
              title: Center(
                  child: Text(_start.toString() + " sn",
                      textAlign: TextAlign.center)),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    widget.controller.animateToPage(
                      1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
            body: Container(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    bottom: 50,
                    right: 40,
                    left: 40,
                    child: butondegis == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              /*""  Container(
                               height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: ClipRRect(
                                  child: Image.network(
                                    "",
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),*/
                              Container(
                                height: 20,
                                child: Icon(
                                  Icons.flash_on,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: 20,
                                child: Icon(
                                  Icons.flash_on,
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                    ),
                                  ),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                    border: Border.all(
                                      width: 10,
                                      color: Colors.white.withOpacity(.5),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  if (_controller != null &&
                                      _controller.value.isInitialized &&
                                      !_controller.value.isRecordingVideo) {
                                    _onRecordButtonPressed();
                                    setState(() {
                                      butondegis = true;
                                    });
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              Container(
                                height: 20,
                                child: Icon(
                                  Icons.cached,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: 20,
                                child: Icon(
                                  Icons.tag_faces,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                    ),
                                  ),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                    border: Border.all(
                                      width: 10,
                                      color: Colors.red.withOpacity(.5),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  if (_controller != null &&
                                      _controller.value.isInitialized &&
                                      _controller.value.isRecordingVideo) {
                                    _onStopButtonPressed();
                                    setState(() {
                                      butondegis = false;
                                    });
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                  ),
                  Positioned(
                    right: 0,
                    left: MediaQuery.of(context).size.width / 4.4,
                    bottom: 10,
                    height: 20,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: index == selectedIndex
                                ? Colors.white.withOpacity(0.4)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              categories[index],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  /*     Positioned(
                    bottom: 5,
                    width: 10,
                    height: 10,
                    child: Icon(
                      Icons.arrow_drop_up,
                      color: Colors.white,
                    ),
                  )*/
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  // Display 'Loading' text when the camera is still loading.
  Widget _cameraPreviewWidget() {
    if (_controller == null || !_controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: CameraPreview(_controller),
    );
  }

  void _onStopButtonPressed() {
    try {
      _timer.cancel();
      _stopVideoRecording().then((_) {
        if (mounted) setState(() {});
        Fluttertoast.showToast(
            msg: 'Video recorded to $videoPath',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      });
    } catch (e) {
      print("_onStopButtonPressed hatasııı" + e.toString());
    }
  }

  Future<String> _startVideoRecording() async {
    Future.delayed(Duration(milliseconds: 100));

    if (!_controller.value.isInitialized) {
      Fluttertoast.showToast(
          msg: 'Please wait',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white);

      return null;
    }

    // Do nothing if a recording is on progress
    if (_controller.value.isRecordingVideo) {
      return null;
    }

    final Directory appDirectory = await getExternalStorageDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    filePath = '$videoDirectory/${currentTime}.mp4';

    try {
      await _controller.startVideoRecording(filePath);
      videoPath = filePath;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  void _showCameraException(CameraException e) {
    String errorText =
        'Errorrrrrrrrrrrrrrrr: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    Fluttertoast.showToast(
        msg: 'Error: ${e.code}\n${e.description}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  ///storage/emulated/0/Android/data/com.example.v1/files/Videos/1595321380623.mp4"
  void setCameraResult() {
    print("Recording Done!");

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(
          videoPath: videoPath,
        ),
      ),
    );
    setState(() {
      filePath = null;
      butondegis = false;
      _start = 0;
    });
  }

  Future<void> _stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }
    try {
      await _controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      print("errorTexttttttttttttttttttt " + e.toString());
      setCameraResult();

      return null;
    }
    Duration(milliseconds: 100);

    setCameraResult();
  }

  void _onRecordButtonPressed() {
    try {
      const oneSec = const Duration(seconds: 1);
      if (selectedIndex == 0) {
        _timer = new Timer.periodic(
          oneSec,
          (Timer timer) => setState(
            () {
              if (_start > 4) {
                _stopVideoRecording().then((_) {
                  if (mounted) setState(() {});
                });
              } else {
                _start = _start + 1;
              }
            },
          ),
        );
      } else {
        _timer = new Timer.periodic(
          oneSec,
          (Timer timer) => setState(
            () {
              if (_start > 9) {
                _stopVideoRecording().then((_) {
                  if (mounted) setState(() {});
                });
              } else {
                _start = _start + 1;
              }
            },
          ),
        );
      }

      _startVideoRecording().then((String filePath) {
        if (filePath != null) {
          Fluttertoast.showToast(
              msg: 'Recording video started',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.grey,
              textColor: Colors.white);
        }
      });
    } catch (e) {
      print("_onRecordButtonPressed hatasııı" + e.toString());
    }
  }
}
