import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meet/utils/color.dart';
import '../utils/set_photo.dart';
import '../utils/information.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/show_AlertDialog.dart';

class set_information_screen extends StatefulWidget {
  const set_information_screen({Key? key}) : super(key: key);
  @override
  State<set_information_screen> createState() => _set_information_screenState();
}

class _set_information_screenState extends State<set_information_screen> {
  var imgkey = UniqueKey();
  String URL = information.photoURL;
  TextEditingController nameCon = TextEditingController();
  bool _validate = false;
  
  void initState() {
    super.initState();
  }

  void dispose() {
  nameCon.dispose();
  super.dispose();
  }

  _updateData(String key, String value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sp.setString(key, value);
    });
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: GestureDetector(
                  onTap: () {
                    set_photoURL_dialog(context);
                    URL = information.photoURL;
                    print(URL);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                    child: ClipOval(
                      child: Image.network(
                        URL,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 80.0, right: 80.0, top: 5.0),
                child: TextField(
                  controller: nameCon,
                  decoration: InputDecoration(
                    hintText: "名字",
                    contentPadding: EdgeInsets.only(bottom: -8.0),
                    errorText: _validate ? "首位字元不能為 _" : null,
                  ),
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      if (value != "" && value[0] == "_") {
                        _validate = true;
                      } else {
                        _validate = false;
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 50.0,
                  right: 50.0,
                  top: 20.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 0.8),
                        child: Text(
                          "儲存個人資料",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onPressed: _validate
                          ? null
                          : () {
                              if (nameCon.text == "") {
                                information.name = "匿名";
                              } else
                                information.name = nameCon.text;
                              information.photoURL = URL;
                              Navigator.pushNamed(context, '/home');
                            }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
