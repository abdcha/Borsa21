import 'dart:io';

import 'package:central_borssa/business_logic/Login/bloc/login_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_event.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_state.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Main/HomeOfApp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Loginpage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Loginpage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late bool isHidden = true;
  late bool isLogedin = false;
  late String phoneNumber;
  late String password;

  final phoneNumberTextEdit = TextEditingController();
  final passwordTextEdit = TextEditingController();

  late LoginBloc authloginBloc;
  Future<String?> getValue() async {
    String? token = await FirebaseMessaging.instance.getToken();
  }

  late FirebaseMessaging firebaseMessaging;
  @override
  void initState() {
    authloginBloc = BlocProvider.of<LoginBloc>(context);
    getValue();
    super.initState();
  }

  // void iOS_Permission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true));
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     print("Settings registered: $settings");
  //   });
  // }

  void passwordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(navbar.hashCode),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is UserLoginScreen) {
              setState(() {
                isLogedin = false;
              });
              print(state);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return HomeOfApp();
              }));
            }
            if (state is ErrorLoginState) {
              setState(() {
                isLogedin = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('الرجاء التأكد من المعلومات المدخلة'),
                  action: SnackBarAction(
                    label: 'تنبيه',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return Center(
              //         child: AlertDialog(
              //           title: Text(
              //             'خطأ في المعلومات',
              //             textAlign: TextAlign.right,
              //           ),
              //           content: Text('الرجاء التأكد من صحة المعلومات المدخلة'),
              //         ),
              //       );
              //     });
            } else if (state is LoginLoadingState) {
              setState(() {
                isLogedin = true;
              });
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            Image.asset('assest/Images/Logo.png'),
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 10.0,
                                    left: 10.0,
                                    right: 10.0,
                                    bottom: 10.0),
                                child: new Theme(
                                    data: new ThemeData(
                                        primaryColor: Colors.red,
                                        primaryColorDark: Colors.red,
                                        focusColor: Colors.red),
                                    child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextFormField(
                                          textAlign: TextAlign.right,
                                          cursorColor: Colors.white,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(color: Colors.white),
                                          controller: phoneNumberTextEdit,
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'إدخال رقم الهاتف';
                                            }
                                            return null;
                                          },
                                          onSaved: (String? value) {
                                            phoneNumber = value ?? "";
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                0, 0, 40, 35),
                                            labelText: 'رقم الهاتف',
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            fillColor: Colors.red,
                                            border: OutlineInputBorder(),
                                            enabledBorder:
                                                new OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.white70)),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: Colors.white70),
                                            ),
                                          ),
                                        )))),
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 10.0,
                                    left: 10.0,
                                    right: 10.0,
                                    bottom: 10.0),
                                child: new Theme(
                                    data: new ThemeData(
                                        primaryColor: Colors.red,
                                        primaryColorDark: Colors.red,
                                        focusColor: Colors.red),
                                    child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextFormField(
                                          textAlign: TextAlign.right,
                                          cursorColor: Colors.white,
                                          obscureText: isHidden,
                                          keyboardType: TextInputType.name,
                                          controller: passwordTextEdit,
                                          style: TextStyle(color: Colors.white),
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'إدخال كلمة المرور';
                                            }
                                            return null;
                                          },
                                          onSaved: (String? value) {
                                            password = value ?? "";
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                0, 0, 40, 35),
                                            labelText: 'كلمة المرور',
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            fillColor: Colors.red,
                                            border: OutlineInputBorder(),
                                            enabledBorder:
                                                new OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.white70)),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: Colors.white70),
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: passwordView,
                                              icon: Icon(
                                                isHidden
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )))),
                            isLogedin
                                ? Container(
                                    margin: const EdgeInsets.only(top: 20.0),
                                    child: Center(
                                        child: CircularProgressIndicator()))
                                : Container(
                                    margin: const EdgeInsets.only(top: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          authloginBloc.add(LoginSubmite(
                                              phone: phoneNumberTextEdit.text,
                                              password: passwordTextEdit.text));
                                          getValue();
                                        }
                                      },
                                      child: Text("تسجيل الدخول"),
                                    ),
                                  ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
