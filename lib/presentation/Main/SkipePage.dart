import 'package:central_borssa/business_logic/Login/bloc/login_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_event.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_state.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Main/HomeOfApp.dart';
import 'package:central_borssa/presentation/Main/LoginTrader.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SkipePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SkipePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late bool isHidden = true;
  late bool isLogedin = false;
  late String phoneNumber;
  late String password;

  final phoneNumberTextEdit = TextEditingController();
  final passwordTextEdit = TextEditingController();

  late LoginBloc authloginBloc;

  @override
  void initState() {
    authloginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

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
                              margin: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: navbar, // background
                                      // onPrimary: navbar,
                                      shadowColor: Color(0xff132133),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Loginpage();
                                      }));
                                    },
                                    child: Text("تسجيل الدخول"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeOfApp(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'تخطي',
                                        style: TextStyle(color: Colors.white),
                                      ))
                                ],
                              ),
                            )
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
