import 'package:central_borssa/business_logic/Company/bloc/company_bloc.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_event.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_state.dart';
import 'package:central_borssa/business_logic/Post/bloc/post_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:central_borssa/presentation/Post/EditORDelete.dart';
import 'package:central_borssa/presentation/Post/add_Post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:central_borssa/data/model/Post/CompanyPost.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:central_borssa/data/model/Post/CompanyInfo.dart'
    as companyInfor;

class CompanyProfile extends StatefulWidget {
  CompanyProfilePage createState() => CompanyProfilePage();
}

class CompanyProfilePage extends State<CompanyProfile> {
  void whatsappSender({@required number, @required message}) async {
    final String url = "https://api.whatsapp.com/send?phone=$number";
    await launch(url);
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _refresherKey = GlobalKey();
  int currentPage = 1;
  late int countItemPerpage = 30;
  late companyInfor.Data companyInfo;
  bool infoloaded = false;
  late CompanyBloc bloc;
  late List<Posts> companypost = [];
  late int companyuser = 0;
  late int totalpost = 0;
  late String? location;
  bool isEditn = true;
  Future<bool> postloading(
      {bool isRefresh = false, bool isEdit = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyuser = int.parse(prefs.get('companyid').toString());

    if (isRefresh) {
      companypost.clear();
      currentPage = 1;
      print(companypost.length);
      currentPage = 1;
      bloc.add(GetAllCompanyInformationsEvent(
          id: companyuser,
          pageSize: countItemPerpage,
          date: "desc",
          page: currentPage));

      currentPage++;
    } else if (isEdit) {
      print('edit');
      companypost.clear();
      print(companypost.length);
      currentPage = 1;
      bloc.add(GetAllCompanyInformationsEvent(
          id: companyuser,
          pageSize: countItemPerpage,
          date: "desc",
          page: currentPage));

      currentPage++;
    }
    print(companypost.length);
    if (totalpost != companypost.length && !isRefresh) {
      bloc.add(GetAllCompanyInformationsEvent(
          id: companyuser,
          pageSize: countItemPerpage,
          date: "desc",
          page: currentPage));
      print('Not Empty');
      currentPage++;
    }
    print(currentPage);
    return true;
  }

  Widget companyProfile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 6),
      child: Card(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                bottom: 15,
                top: 20,
              ),
              height: 150,
              width: 150,
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  companyInfo.company.image,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                companyInfo.company.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            // Container(
            //     margin: const EdgeInsets.only(bottom: 10),
            //     child: Center(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: InkWell(
            //               onTap: () {
            //                 whatsappSender(
            //                     message: "hi",
            //                     number: companyInfo.company.phone);
            //               },
            //               child: Image.asset(
            //                 'assest/Images/whatsapp.png',
            //                 width: 25,
            //                 height: 25,
            //               ),
            //             ),
            //           ),
            //           // (isFollowed = companypost[index].isFollowed) == 1
            //           //     ? Padding(
            //           //         padding: const EdgeInsets.all(8.0),
            //           //         child: InkWell(
            //           //             onTap: () {
            //           //               bloc.add(UnFollowEvent(
            //           //                   id: companypost[index].companyId));
            //           //             },
            //           //             child: Icon(
            //           //               Icons.add_circle_outline_rounded,
            //           //               color: Colors.blue[400],
            //           //             )),
            //           //       )
            //           //     : Padding(
            //           //         padding: const EdgeInsets.all(8.0),
            //           //         child: InkWell(
            //           //             onTap: () {
            //           //               bloc.add(FollowEvent(
            //           //                   id: companypost[index].companyId));
            //           //             },
            //           //             child:
            //           //                 Icon(Icons.add_circle_outline_rounded)),
            //           //       )
            //         ],
            //       ),
            //     )),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 8, top: 8, right: 12, left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(companyInfo.company.phone),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        onTap: () {
                          launch("tel://${companyInfo.company.phone}");
                        },
                        child: Icon(
                          Icons.phone,
                          color: Color(navbar.hashCode),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 8, top: 8, right: 12, left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      companyInfo.company.address,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.location_on,
                        color: Color(navbar.hashCode),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 8, top: 8, right: 12, left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      companyInfo.company.email,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.email_sharp,
                        color: Color(navbar.hashCode),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ourListview() {
    return Container(
      child: SingleChildScrollView(
        child: ListView.separated(
          key: _contentKey,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(2),
          itemCount: companypost.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Card(
                  elevation: 5.0,
                  shadowColor: Colors.black,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end, //change here don't //worked
                        children: [
                          Container(
                              margin: const EdgeInsets.only(
                                  bottom: 20, left: 10, right: 10),
                              child: Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: PopupMenuButton(
                                  icon: Icon(Icons.more_horiz),
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry>[
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('حذف المنشور'),
                                        onTap: () {
                                          Navigator.pop(context);

                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return EditORDelete(
                                              id: companypost[index].id,
                                              type: 'حذف المنشور',
                                              image: companypost[index].image,
                                              body: companypost[index].body,
                                            );
                                          }));
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('تعديل المنشور'),
                                        onTap: () {
                                          Navigator.pop(context);

                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return EditORDelete(
                                              id: companypost[index].id,
                                              type: 'تعديل المنشور',
                                              image: companypost[index].image,
                                              body: companypost[index].body,
                                            );
                                          }));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Spacer(),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      companypost[index].company.name,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: Text(
                                        DateFormat.Md().format(DateTime.parse(
                                                companypost[index].createdAt)) +
                                            " " +
                                            DateFormat.jm().format(
                                                DateTime.parse(
                                                    companypost[index]
                                                        .createdAt)),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10),
                                      ),
                                    ),
                                    Text(
                                      companypost[index].user.name,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 10, top: 10, right: 20),
                            child: InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         CompanyProfile(id: post[index].companyId),
                                //   ),
                                // );
                              },
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                  companypost[index].company.image,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                              bottom: 10, left: 10, top: 10, right: 25),
                          child: ReadMoreText(
                            companypost[index].body == "empty"
                                ? ""
                                : companypost[index].body,
                            trimLines: 6,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'قرائة المزيد',
                            trimExpandedText: '',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 10, right: 10, left: 10, bottom: 20),
                        child: companypost[index].image ==
                                    "https://centralborsa.comno_image" ||
                                companypost[index].image ==
                                    "https://centralborsa.com/uploads/placeholder.jpg"
                            ? Container()
                            : Image.network(
                                companypost[index].image,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                // height: 200,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 1,
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   refreshController.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    bloc = BlocProvider.of<CompanyBloc>(context);

    companypost.clear();
    postloading();
    sharedValue();
    setState(() {});

    super.initState();
  }

  late List<String> userPermissions = [];
  late String userName = "";
  late String userPhone = "";
  late String userType = "";
  late String userActive = "";

  sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    userPermissions = prefs.getStringList('permissions')!.toList();
    companyuser = int.parse(prefs.get('companyid').toString());
    userType = prefs.get('roles').toString();
    if (prefs.get('end_subscription') != null) {
      userActive = prefs.get('end_subscription').toString();
    }

    bloc.add(GetCompanyInfoEvent(id: companyuser));

    setState(() {});
  }

  logout() async {
    print('from');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Widget newDrawer() {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new Container(
            child: new DrawerHeader(
                child: new CircleAvatar(
              backgroundColor: navbar,
              // child: Image.asset('asesst/Images/Logo.png')
            )),
            color: Colors.grey[300],
          ),
          new Container(
              color: Colors.white30,
              child: Center(
                child: new Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(userName),
                      leading: new Icon(Icons.account_circle),
                      onTap: () {
                        // Update the state of the app.//feas
                        // ...
                      },
                    ),
                    ListTile(
                      title: Text(userPhone),
                      leading: new Icon(Icons.phone),
                    ),
                    ListTile(
                      title: Text(userActive),
                      leading: new Icon(Icons.wifi_tethering_outlined),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                    ListTile(
                      title: Text('تسجيل الخروج'),
                      leading: new Icon(Icons.logout_sharp),
                      onTap: () {
                        logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) => Loginpage()),
                          ModalRoute.withName('/'),
                        );
                      },
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  reload() async {
    print('main reload');
    postloading(isRefresh: true);
    await Future.delayed(Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: newDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            height: 50,
            child: Center(
              child: Image.asset('assest/Images/test2.png'),
            ),
          ),
          backgroundColor: Color(navbar.hashCode),
        ),
        backgroundColor: Colors.grey[300],
        body: MultiBlocListener(
          listeners: [
            BlocListener<PostBloc, PostState>(
              listener: (context, state) {
                if (state is AddPostSuccess) {
                  print(state);
                  reload();
                }
              },
            ),
            BlocListener<CompanyBloc, CompanyState>(
              listener: (context, state) {
                if (state is EditPostLoaded) {
                  reload();
                } else if (state is DeletePostLoaded) {
                  reload();
                } else if (state is GetCompanyInfoLoaded) {
                  print(state);
                  companyInfo = state.data;
                  setState(() {
                    infoloaded = true;
                  });
                } else if (state is GetAllInformationLoading) {
                  print(state);
                } else if (state is GetAllInformationLoaded) {
                  if (companypost.isEmpty) {
                    print('length');
                    companypost = state.data.posts;
                    totalpost = state.data.total;
                    setState(() {});
                  } else if (companypost.isNotEmpty) {
                    print('from addall');
                    companypost.addAll(state.data.posts);
                  } else {
                    print(state);
                  }
                } else if (state is GetAllInformationError) {
                  print(state);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('خطأ في التحميل'),
                      action: SnackBarAction(
                        label: 'تنبيه',
                        onPressed: () {},
                      ),
                    ),
                  );
                }
              },
            ),
          ],
          child: Container(
            height: double.infinity,
            child: SmartRefresher(
              key: _refresherKey,
              controller: refreshController,
              enablePullUp: true,
              physics: BouncingScrollPhysics(),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                completeDuration: Duration(milliseconds: 200),
              ),
              onRefresh: () async {
                postloading(isRefresh: true);
                await Future.delayed(Duration(milliseconds: 200));
                if (mounted) setState(() {});
                refreshController.refreshCompleted();
              },
              onLoading: () async {
                await Future.delayed(Duration(milliseconds: 200));
                postloading();
                if (mounted) setState(() {});
                refreshController.loadFailed();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    infoloaded ? companyProfile() : Container(),
                    ourListview(),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Color(navbar.hashCode),
            tooltip: 'إضافة منتج',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddPost();
              }));
            }));
  }
}
