import 'package:central_borssa/constants/string.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(navbar.hashCode),
        body: Container(
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(navbar.hashCode),
            ),
          ),
        ),
      );
}
