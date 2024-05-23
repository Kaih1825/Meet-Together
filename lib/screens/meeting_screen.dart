import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/jitsi_meeting_methous.dart';
import '../screens/no_Internet.dart';

class meeting_screen extends StatefulWidget {
  final String roomName;
  final String name;
  final String photoURL;
  final List<CameraDescription>? cameras;
  meeting_screen({
    Key? key,
    required this.roomName,
    required this.name,
    required this.photoURL,
    required this.cameras,
  }) : super(key: key);

  @override
  State<meeting_screen> createState() => _meeting_screenState();
}

class _meeting_screenState extends State<meeting_screen> {
  late CameraController _cameraController;
  final JitsiMeetMethous _jitsiMeetMethous = JitsiMeetMethous();
  bool cameraIsOpen = true;
  bool micIsOpen = true;
  bool isInternet = false;
  bool isStraight = true;

  @override
  void initState() {
    super.initState();
    isInternetConnected();
    // initialize the rear camera
    try {
      initCamera(widget.cameras!.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front));
    } catch (e) {
      initCamera(widget.cameras![0]);
      print("camera error $e");
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  joinMeeting() async {
    _jitsiMeetMethous.joinMeeting(
      roomName: widget.roomName,
      isAudioMuted: micIsOpen ? false : true,
      isVideoMuted: cameraIsOpen ? false : true,
      userDisplayName: widget.name,
      photoURL: widget.photoURL,
      context: context,
    );
  }

  _updateString(String key, String value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sp.setString(key, value);
    });
  }

  Future initCamera(CameraDescription cameraDescription) async {
    //create a CameraController
    _cameraController = CameraController(cameraDescription, ResolutionPreset.high);
    //initialize the controller
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      print("camera error $e");
    }
  }

  Future<void> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      var res = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      setState(() {
        isInternet = true;
      });
    } on SocketException catch (_) {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new noInternet()), (route) => route == null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color videocamBorderColor = cameraIsOpen ? Colors.grey : Colors.red.shade800;
    Color videocamFillColor = cameraIsOpen ? Theme.of(context).colorScheme.background : Colors.red.shade900;
    Icon videocam = cameraIsOpen
        ? Icon(
            Icons.videocam_outlined,
            size: 30,
            color: Theme.of(context).colorScheme.onBackground,
          )
        : Icon(
            Icons.videocam_off_outlined,
            size: 30,
            color: Theme.of(context).colorScheme.background,
          );

    Color micBorderColor = micIsOpen ? Colors.grey : Colors.red.shade800;
    Color micFillColor = micIsOpen ? Theme.of(context).colorScheme.background : Colors.red.shade900;
    Icon mic = micIsOpen
        ? Icon(
            Icons.mic,
            size: 25,
            color: Theme.of(context).colorScheme.onBackground,
          )
        : Icon(
            Icons.mic_off_outlined,
            size: 25,
            color: Theme.of(context).colorScheme.background,
          );
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Share.share("""點擊下方連結加入會議：
https://meet.skailine.net:8443/${widget.roomName}""");
                },
                icon: Icon(
                  Icons.share,
                  size: 20.0,
                ))
          ],
        ),
        body: OrientationBuilder(
          builder: ((context, orientation) {
            if (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height) {
              isStraight = false;
            } else {
              isStraight = true;
            }
            if (isStraight == true) {
              return Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 23.0),
                      child: Text(
                        "會議代碼:" + widget.roomName,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                      child: Container(
                        height: 300,
                        width: 168.75,
                        child: cameraIsOpen
                            ? _cameraController.value.isInitialized
                                ? CameraPreview(_cameraController)
                                : Center(child: const CircularProgressIndicator())
                            : Container(
                                height: 150,
                                width: 250,
                                color: Theme.of(context).colorScheme.secondary,
                                child: Center(
                                  child: Container(
                                      height: 90,
                                      width: 90,
                                      child: ClipOval(
                                        child: Image.network(widget.photoURL),
                                      )),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 23.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cameraIsOpen ? cameraIsOpen = false : cameraIsOpen = true;
                                  print(cameraIsOpen);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(1.5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: videocamBorderColor,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: videocamFillColor,
                                  maxRadius: 23,
                                  child: videocam,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  micIsOpen ? micIsOpen = false : micIsOpen = true;
                                  print(micIsOpen);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(1.5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: micBorderColor,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: micFillColor,
                                  maxRadius: 23,
                                  child: mic,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: SizedBox(
                              width: 130.0,
                              height: 50.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                                onPressed: () async {
                                  await _updateString("recentMeet", widget.roomName);
                                  await joinMeeting();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 0.8),
                                  child: Text(
                                    "加入",
                                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 100.0, right: 100.0),
                      child: Container(
                        color: Colors.grey,
                        height: 1.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Power By Jitsi Meet",
                        style: TextStyle(fontSize: 13.0),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        "會議代碼:" + widget.roomName,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                      child: cameraIsOpen
                          ? Container(
                              height: 150,
                              width: 250,
                              child: _cameraController.value.isInitialized
                                  ? CameraPreview(_cameraController)
                                  : Center(child: const CircularProgressIndicator()),
                            )
                          : Container(
                              height: 150,
                              width: 250,
                              color: Theme.of(context).colorScheme.secondary,
                              child: Center(
                                child: Container(
                                    height: 90,
                                    width: 90,
                                    child: ClipOval(
                                      child: Image.network(widget.photoURL),
                                    )),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 23.0, bottom: 23.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cameraIsOpen ? cameraIsOpen = false : cameraIsOpen = true;
                                  print(cameraIsOpen);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(1.5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: videocamBorderColor,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: videocamFillColor,
                                  maxRadius: 23,
                                  child: videocam,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  micIsOpen ? micIsOpen = false : micIsOpen = true;
                                  print(micIsOpen);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(1.5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: micBorderColor,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: micFillColor,
                                  maxRadius: 23,
                                  child: mic,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: 130.0,
                              height: 50.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                                onPressed: () {
                                  joinMeeting();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 0.8),
                                  child: Text(
                                    "加入",
                                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
        ));
  }
}
