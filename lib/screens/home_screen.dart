import 'dart:ffi';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:meet/main.dart';
import 'package:meet/screens/about_screen.dart';
import 'package:meet/screens/meeting_screen.dart';
import 'package:meet/screens/set_information_screen.dart';
import 'package:meet/utils/color.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import '../utils/information.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/snackBar.dart';
import '../auth/firebase_auth_google.dart';
import 'dart:io';
import 'package:page_animation_transition/page_animation_transition.dart';
import '../resources/jitsi_meeting_methous.dart';
import '../utils/show_AlertDialog_join_Meet.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class home_screen extends StatefulWidget {
  const home_screen({Key? key}) : super(key: key);

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  final _formkey = GlobalKey<FormState>();
  final AuthMethods _authMethods = AuthMethods();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Widget currentPage = home_screen();
  bool isNUll = false;
  String url = "";
  String name = "no one";
  String loginMethod = "Google";
  String roomName = "";
  String recentMeet = "";
  String itemCount = "0";
  String joinButtonText = "更改";
  List<String> customNameList = [];
  List<String> roomNameList = [];
  TextEditingController roomNameCon = TextEditingController();
  TextEditingController customNameCon = TextEditingController();
  ScrollController _controller = ScrollController();

  void dispose() {
    roomNameCon.dispose();
    customNameCon.dispose();
    super.dispose();
  }

  _loadData(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      if (key == "url") {
        url = (sp.getString(key) ?? _authMethods.user.photoURL.toString());
      } else if (key == "name") {
        name = (sp.getString(key) ?? _authMethods.user.displayName.toString());
      } else if (key == "loginMethod") {
        loginMethod =
            (sp.getString(key) ?? _authMethods.user.displayName.toString());
      } else if (key == "recentMeet") {
        recentMeet = (sp.getString(key) ?? "沒有資料");
      } else if (key == "itemCount") {
        itemCount = (sp.getString(key) ?? "0");
      }
    });
  }

  _updateString(String key, String value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sp.setString(key, value);
    });
  }

  _updateList(String key, List<String> list) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sp.setStringList(key, list);
    });
  }

  _loadList(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      if (key == "stringList") {
        customNameList = (sp.getStringList(key) ?? []);
      } else if (key == "roomNameList") {
        roomNameList = (sp.getStringList(key) ?? []);
      }
    });
  }

  _removeData(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sp.remove(key);
    });
  }

  _buildSuggestions() {
    if (customNameList.length > 0)
      Timer(Duration(milliseconds: 500),
          () => _controller.jumpTo(_controller.position.maxScrollExtent));
  }

  signOut() async {
    _removeData("loginMethod");
    await _firebaseAuth.signOut();
  }

  randomRoomName() {
    var random = Random();
    roomName = "";
    for (int i = 1; i <= 3; i++) {
      int num = random.nextInt(26) + 97; //97-122(含)
      roomName += String.fromCharCode(num);
    }
    roomName += "-";
    for (int i = 1; i <= 3; i++) {
      int num = random.nextInt(26) + 97; //97-122(含)
      roomName += String.fromCharCode(num);
    }
    int num = random.nextInt(900) + 100;

    ///100~999(含)
    roomName = roomName + "-" + num.toString();
  }

  @override
  void initState() {
    super.initState();
    if (information.name == "_non") {
      setState(() {
        _loadData("name");
        _loadData("url");
        _loadData("recentMeet");
        _loadData("itemCount");
        _loadList("stringList");
        _loadList("roomNameList");
        _loadData("loginMethod");
      });
    } else {
      name = information.name;
      url = information.photoURL;
      setState(() {
        _updateString("name", information.name);
        _updateString("url", information.photoURL);
        _updateString("loginMethod", "anonymous");
        _loadData("loginMethod");
        _loadData("recentMeet");
        _loadData("itemCount");
        _loadList("stringList");
        _loadList("roomNameList");
      });
    }
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, int index, String curItemCount) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("請輸入資訊"),
            content: SizedBox(
              height: 101.0,
              child: Column(children: [
                TextField(
                  controller: customNameCon,
                  decoration: InputDecoration(
                    hintText: "請輸入自訂名稱",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: TextField(
                    controller: roomNameCon,
                    decoration: InputDecoration(
                      hintText: "請輸入會議代碼",
                    ),
                  ),
                ),
              ]),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.secondaryContainer),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0.8),
                  child: Text(
                    "取消",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                onPressed: () {
                  try {
                    if (index == int.parse(curItemCount)) {
                      itemCount = (int.parse(itemCount) - 1).toString();
                      _updateString("itemCount", itemCount);
                    }
                  } catch (e) {}
                  Navigator.pop(context);
                  joinButtonText = "更改";
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary:
                          Theme.of(context).colorScheme.secondaryContainer),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.8),
                    child: Text(
                      joinButtonText,
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      joinButtonText = "更改";
                      try {
                        if (index == int.parse(curItemCount)) {
                          customNameList.insert(index, customNameCon.text);
                          roomNameList.insert(index, roomNameCon.text);
                        }
                      } catch (e) {
                        customNameList[index] = customNameCon.text;
                        roomNameList[index] = roomNameCon.text;
                      }
                      _updateList("stringList", customNameList);
                      _updateList("roomNameList", roomNameList);
                      customNameCon.clear();
                      roomNameCon.clear();
                    });
                    _buildSuggestions();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          titleSpacing: 10.0,
          title: const Padding(
            padding: EdgeInsets.only(bottom: 3.5),
            child: Text("首頁"),
          )),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3)),
                    child: ClipOval(
                      child: Image.network(
                        url,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                "設定個人資料",
                style: loginMethod == "anonymous"
                    ? TextStyle(color: null)
                    : TextStyle(color: Colors.grey),
              ),
              onTap: loginMethod == "anonymous"
                  ? () {
                      /*Navigator.of(context).pushAndRemoveUntil(
                          PageAnimationTransition(
                              page: set_information_screen(),
                              pageAnimationType: RightToLeftTransition()),
                          (route) => route == null);*/
                      Navigator.of(context).push(PageAnimationTransition(
                          page: set_information_screen(),
                          pageAnimationType: RightToLeftTransition()));
                    }
                  : null,
            ),
            ListTile(
              title: Text(
                "登出",
              ),
              onTap: () {
                signOut();
                information.name = "_non";
                _removeData("url");
                _removeData("name");
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(builder: (context) => new Meet_App()),
                    (route) => route == null);
              },
            ),
            ListTile(
              title: Text("關於"),
              onTap: () {
                Navigator.of(context).push(PageAnimationTransition(
                    page: about_screen(),
                    pageAnimationType: RightToLeftTransition()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        //padding: EdgeInsets.only(left:8.0,right: 8.0,bottom: 8.0),
        child: Column(
          children: [
            Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150.0,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          randomRoomName();
                          await availableCameras().then((value) => Navigator.of(
                                  context)
                              .push(PageAnimationTransition(
                                  page: meeting_screen(
                                    roomName: roomName,
                                    name: name,
                                    photoURL: url,
                                    cameras: value,
                                  ),
                                  pageAnimationType: RightToLeftTransition())));
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.primary),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0.8),
                          child: Text(
                            "創建會議室",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150.0,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          show_AlertDialog_join_Meet(context, name, url);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.primary),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0.8),
                          child: Text(
                            "加入會議室",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
                child: Container(
                  color: Colors.grey,
                  height: 1.0,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 5.0, left: 10.0, right: 5.0),
                child: Row(
                  children: [
                    Text(
                      "最近加入的會議室",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                child: Row(children: [
                  Expanded(
                      flex: 500,
                      child: Text(
                        recentMeet,
                        style: TextStyle(fontSize: 23.0),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.secondary),
                      onPressed: recentMeet == "沒有資料"
                          ? null
                          : () async {
                              await availableCameras().then((value) =>
                                  Navigator.of(context).push(
                                      PageAnimationTransition(
                                          page: meeting_screen(
                                            roomName: recentMeet,
                                            name: name,
                                            photoURL: url,
                                            cameras: value,
                                          ),
                                          pageAnimationType:
                                              RightToLeftTransition())));
                            },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0.8),
                        child: Text(
                          "加入",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 9.0, left: 10.0, right: 10.0, bottom: 14.0),
                child: Container(
                  color: Colors.grey,
                  height: 1.0,
                ),
              ),
            ]),
            Flexible(
              child: ListView.builder(
                controller: _controller,
                itemCount: customNameList.length,
                itemBuilder: ((context, index) {
                  final item = customNameList[index];
                  return GestureDetector(
                    onTap: () async {
                      print(customNameList[index] + " " + roomNameList[index]);
                      if (roomNameList[index].isEmpty) {
                        showSnackBar(context, "會議代碼為空，請新增會議代碼");
                      } else if (roomNameList[index].contains(RegExp(
                              r'[!@#$%^&*(),.?":{}|<>/\，。、：;；~`ˇˋˊ˙=+]')) ||
                          roomNameList[index].contains(RegExp(r"'"))) {
                        showSnackBar(context, "請勿輸入特殊字元");
                      } else {
                        await availableCameras().then((value) =>
                            Navigator.of(context).push(PageAnimationTransition(
                                page: meeting_screen(
                                  roomName: roomNameList[index],
                                  name: name,
                                  photoURL: url,
                                  cameras: value,
                                ),
                                pageAnimationType: RightToLeftTransition())));
                      }
                    },
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 1,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0)),
                            onPressed: ((context) => {
                                  _displayTextInputDialog(
                                      context, index, "AAAAAA"),
                                  customNameCon.text = customNameList[index],
                                  roomNameCon.text = roomNameList[index],
                                }),
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: '編輯',
                          ),
                          SlidableAction(
                            onPressed: ((context) => {
                                  customNameList.removeAt(index),
                                  roomNameList.removeAt(index),
                                  itemCount =
                                      (int.parse(itemCount) - 1).toString(),
                                  _updateString("itemCount", itemCount),
                                  _updateList("stringList", customNameList),
                                  _updateList("roomNameList", roomNameList),
                                }),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            foregroundColor:
                                Theme.of(context).colorScheme.onError,
                            icon: Icons.delete,
                            label: '刪除',
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10.0, left: 10.0, right: 10.0),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              item,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                            ),
                            subtitle: Text(
                              "會議代碼：" + roomNameList[index],
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                            ),
                          ),
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          joinButtonText = "新增";
          customNameCon.clear();
          roomNameCon.clear();
          _displayTextInputDialog(context, int.parse(itemCount), itemCount);
          itemCount = (int.parse(itemCount) + 1).toString();
          _updateString("itemCount", itemCount);
        },
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
