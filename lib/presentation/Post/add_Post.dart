import 'dart:convert';
import 'dart:io';

import 'package:central_borssa/presentation/Main/HomeOfApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import 'package:central_borssa/business_logic/Post/bloc/post_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Home/All_post.dart';

class AddPost extends StatefulWidget {
  AddPostPage createState() => AddPostPage();
}

class AddPostPage extends State<AddPost> {
  final ImagePicker _picker = ImagePicker();
  final postTextInpput = TextEditingController();
  late final String postValue;
  late PostBloc _postBloc;
  late String base64Image;
  late String encodeImage = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? mainFile;

  Future chooseFile() async {
    setState(() async {
      final postFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        mainFile = File(postFile!.path);
      });
      String baseimage = base64Encode(mainFile!.readAsBytesSync());
      print(baseimage);
      String extension = p.extension(postFile!.path);
      String extensionWithoutDot = extension.substring(1);

      String someWorld = 'data:image/$extensionWithoutDot;base64,';
      setState(() {
        mainFile = File(postFile.path);
        encodeImage = '$someWorld$baseimage';
        print(encodeImage);
      });
    });
  }

  Future clearFile() async {
    setState(() {
      mainFile = null;
    });
  }

  @override
  void initState() {
    _postBloc = BlocProvider.of<PostBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('تحديث الأسعار'),
          ),
          backgroundColor: Color(navbar.hashCode),
        ),
        body: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is AddPostSuccess) {
              print(state);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(milliseconds: 12),
                  content: const Text('تم التعديل بنجاح'),
                  action: SnackBarAction(
                    label: 'تنبيه',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );

              Navigator.pop(context, MaterialPageRoute(builder: (context) {
                return HomeOfApp();
              }));
            }
            if (state is PostsLoadingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('الرجاء التأكد من صحة المعلومات المدخلة'),
                  action: SnackBarAction(
                    label: 'خطأ في المعلومات',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
            } else if (state is PostLoadingInProgress) {
              // Future.delayed(const Duration(seconds: 2000), () {
              //   showDialog(
              //       context: context,
              //       builder: (context) {
              //         return Center(child: CircularProgressIndicator());
              //       });
              // });
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(
                      top: 40.0, left: 10.0, right: 10.0, bottom: 10.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                                top: 25.0,
                                left: 15.0,
                                right: 15.0,
                                bottom: 20.0),
                            child: new Theme(
                                data: new ThemeData(
                                    primaryColor: Colors.red,
                                    primaryColorDark: Colors.red,
                                    focusColor: Colors.red),
                                child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      cursorColor: Colors.black,
                                      maxLines: null,
                                      controller: postTextInpput,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(color: Colors.black),
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'الرجاء إدخال المنشور الجديد';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        postValue = value ?? "";
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(0, 0, 40, 35),
                                        labelText: 'المنشور',
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        fillColor: Colors.red,
                                        border: OutlineInputBorder(),
                                        enabledBorder: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Color(navbar.hashCode))),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: Color(navbar.hashCode)),
                                        ),
                                      ),
                                    )))),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 20.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(navbar.hashCode)),
                                          onPressed: () {
                                            chooseFile();
                                          },
                                          child: Text("إضافة صورة"),
                                        ),
                                      ),
                                      Spacer(),
                                      mainFile != null
                                          ? Container(
                                              height: 50,
                                              width: 50,
                                              margin: const EdgeInsets.only(
                                                  top: 20.0,
                                                  left: 0.0,
                                                  right: 10.0),
                                              child: new IconButton(
                                                icon: new Icon(
                                                    Icons.delete_forever),
                                                highlightColor: Colors.grey,
                                                onPressed: () {
                                                  clearFile();
                                                },
                                              ),
                                            )
                                          : Container(),
                                      Container(
                                        height: 125,
                                        width: 125,
                                        margin: const EdgeInsets.only(
                                            top: 20.0, left: 0.0, right: 20.0),
                                        child: Card(
                                            child: mainFile == null
                                                ? Icon(Icons.camera_alt_rounded)
                                                : Image.file(
                                                    File(mainFile!.path))),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.all(25.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                _postBloc.add(AddNewPost(
                                    body: postTextInpput.text,
                                    image: encodeImage));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Color(navbar.hashCode)),
                            child: Text("إضافة المنشور"),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
