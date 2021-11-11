import 'package:central_borssa/business_logic/Login/bloc/login_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_event.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_state.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Main/HomeOfApp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginTradepage extends StatefulWidget {
  @override
  LoginTradeState createState() => LoginTradeState();
}

class LoginTradeState extends State<LoginTradepage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late bool isHidden = true;
  late bool isLogedin = false;
  late String phoneNumber;
  late String password;
  late String email;
  late String name;

  final phoneNumberTextEdit = TextEditingController();
  final passwordTextEdit = TextEditingController();
  final emailTextEdit = TextEditingController();
  final nameTextEdit = TextEditingController();
  late LoginBloc authloginBloc;

  late FirebaseMessaging firebaseMessaging;
  @override
  void initState() {
    authloginBloc = BlocProvider.of<LoginBloc>(context);
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
            if (state is LoginTraderLoaded) {
              setState(() {
                isLogedin = false;
              });
              print(state);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return HomeOfApp();
              }));
            }
            if (state is LoginTraderError) {
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
            } else if (state is LoginTraderLoading) {
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
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          style: TextStyle(color: Colors.white),
                                          controller: emailTextEdit,
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'الرجاء إدخال الإيميل ';
                                            }
                                            return null;
                                          },
                                          onSaved: (String? value) {
                                            email = value ?? "";
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                0, 0, 40, 35),
                                            labelText: 'الإيميل',
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
                                          keyboardType: TextInputType.name,
                                          style: TextStyle(color: Colors.white),
                                          controller: nameTextEdit,
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'إدخال اسم المستخدم ';
                                            }
                                            return null;
                                          },
                                          onSaved: (String? value) {
                                            name = value ?? "";
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                0, 0, 40, 35),
                                            labelText: 'اسم المستخدم',
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
                                          authloginBloc.add(LoginTraderSubmite(
                                            phone: phoneNumberTextEdit.text,
                                            password: passwordTextEdit.text,
                                            name: nameTextEdit.text,
                                            email: emailTextEdit.text,
                                          ));
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
