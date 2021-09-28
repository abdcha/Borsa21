// import 'package:central_borssa/presentation/Home/All_post.dart';
// import 'package:central_borssa/presentation/Home/Central_Borssa.dart';
// import 'package:central_borssa/presentation/Home/Chat.dart';
// import 'package:central_borssa/presentation/Home/Company_Profile.dart';
// import 'package:flutter/material.dart';

// class ShareAppbars extends StatefulWidget {
//   ShareAppbarsPage createState() => ShareAppbarsPage();
// }

// class ShareAppbarsPage extends State<ShareAppbars> {
//   final navbarColor = Color(0xff223C5E);
//   final bottomnavbar = Color(0xff223C5E);
//   int selectedPage = 0;

//   callBody(int value) {
//     switch (value) {
//       case 0:
//         return All_Post();
//       case 1:
//         return Company_Profile();
//       case 2:
//         return CentralBorssa();
//       case 3:
//         return Chat();
//         // ignore: dead_code
//         break;
//       default:
//     }
//   }

//   void choosePage(int index) {
//     setState(() {
//       selectedPage = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: Color(bottomnavbar.hashCode),
//       selectedItemColor: Colors.white,
//       unselectedItemColor: Colors.white.withOpacity(.60),
//       selectedFontSize: 14,
//       unselectedFontSize: 14,
//       currentIndex: selectedPage,
//       onTap: choosePage,
//       items: [
//         BottomNavigationBarItem(
//           title: Text('الأساسية'),
//           icon: Icon(Icons.home),
//         ),
//         BottomNavigationBarItem(
//           title: Text('الشخصية'),
//           icon: Icon(Icons.person_rounded),
//         ),
//         BottomNavigationBarItem(
//           title: Text('مزاد الحواللات'),
//           icon: Icon(Icons.attach_money),
//         ),
//         BottomNavigationBarItem(
//           title: Text('المحادثة'),
//           icon: Icon(Icons.chat_outlined),
//         ),
//       ],
//     );
//   }
// }
