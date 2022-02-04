import 'dart:ui' as ui;

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:central_borssa/business_logic/Advertisement/bloc/advertisement_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_bloc.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_state.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_event.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_state.dart';
import 'package:central_borssa/data/model/Advertisement.dart';
import 'package:central_borssa/presentation/Main/HomeOfApp.dart';
import 'package:central_borssa/presentation/Main/SkipePage.dart';
import 'package:central_borssa/presentation/Post/EditORDelete.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:central_borssa/business_logic/Borssa/bloc/borssa_event.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_event.dart';
import 'package:central_borssa/business_logic/Post/bloc/post_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Post/Cities.dart';
import 'package:central_borssa/data/model/Post/GetPost.dart';
import 'package:central_borssa/presentation/Company/company.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:central_borssa/presentation/Post/add_Post.dart';
import 'package:transparent_image/transparent_image.dart';

class AllPost extends StatefulWidget {
  AllPostPage createState() => AllPostPage();
}

late List<list> _companiesName = [];

class AllPostPage extends State<AllPost> {
  late PostBloc postbloc;
  late BorssaBloc borssaBloc;
  late CompanyBloc companybloc;
  late LoginBloc loginbloc;
  late AdvertisementBloc advertisementbloc;
  late List<Posts> post = [];
  late List<list> cities = [];
  late List<list?> selectedcities = [];
  late List<String> userPermissions = [];
  late List<Advertisements> advertisements = [];
  late List<CityId> cityid = [];
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _refresherKey = GlobalKey();
  late int countItemPerpage = 5;
  late int totalpost = 0;
  late String userName = "";
  late String userPhone = "";
  late String userLocation = "";
  late String userType = "";
  late String userActive = "";
  late int countofMessage = 0;
  late List<String> messageBody = [];
  int companyuser = 0;
  int currentPage = 1;
  List<CityId> cityidconvert = [];
  List<String> cityloaded = [];
  List<String> _searchcity = [];
  List<int> cityloadedId = [];
  bool isEmpty = false;
  bool isSerach = false;

  sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    userPermissions = prefs.getStringList('permissions')!.toList();
    companyuser = int.parse(prefs.get('companyid').toString());
    if (prefs.getInt('countofMessage') != null) {
      countofMessage = 0;
      countofMessage = prefs.getInt('countofMessage')!;
      print('--share---');
      print(countofMessage);
    }
    if (prefs.getStringList('MessageBody') != null) {
      messageBody.clear();
      messageBody = prefs.getStringList('MessageBody')!;
      print('--share---');
      print(messageBody);
    }
    userType = prefs.get('roles').toString();
    if (prefs.get('end_subscription') != null) {
      userActive = prefs.get('end_subscription').toString();
    }
    if (prefs.getStringList('searchcity') != null) {
      cityloadedId.clear();
      _searchcity = prefs.getStringList('searchcity')!;
      for (int i = 0; i < _searchcity.length; i++) {
        cityloadedId.add(int.parse(_searchcity[i]));
      }
    }
  }

  firebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseMessaging.onMessage.handleError((error) {
      print("Erorrrrrr : ${error.toString()}");
    }).listen((event) async {
      String? body = event.notification?.body;
      if (event.data['type'] == "broadcast") {
        if (messageBody.isEmpty) {
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');
          countofMessage++;
          messageBody.add(body!);
          prefs.setInt('countofMessage', countofMessage);
          prefs.setStringList('MessageBody', messageBody);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(body),
              action: SnackBarAction(
                label: 'تنبيه',
                onPressed: () {},
              ),
            ),
          );
        } else if (messageBody.isNotEmpty) {
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');
          countofMessage++;
          messageBody.add(body!);
          prefs.setInt('countofMessage', countofMessage);
          prefs.setStringList('MessageBody', messageBody);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(body),
              action: SnackBarAction(
                label: 'تنبيه',
                onPressed: () {},
              ),
            ),
          );
        }
      }
    });
  }

  addsharedValue(List<CityId> cityid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cityloadedId.clear();
    cityloaded.clear();
    if (prefs.getStringList('searchcity') != null) {
      prefs.getStringList('searchcity')!.clear();
      for (var i in cityid) {
        cityloaded.add(i.id.toString());
        cityloadedId.add(i.id!.toInt());
      }
      prefs.setStringList('searchcity', cityloaded);
    } else if (prefs.getStringList('searchcity') == null) {
      for (var i in cityid) {
        cityloaded.add(i.id.toString());
        cityloadedId.add(i.id!.toInt());
      }
      var temp = prefs.setStringList('searchcity', cityloaded);
      print(temp);
    }
  }

  reload() async {
    print('main reload');
    postloading(isRefresh: true);
    setState(() {});
    await Future.delayed(Duration(milliseconds: 500));
  }

  Future<bool> postloading({bool isRefresh = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cityid = prefs.getStringList('searchcity');
    print('inside postloading');
    print(cityid);
    if (cityid != null) {
      print('inside cityid');
      if (cityidconvert.isEmpty) {
        for (var i in cityid) {
          cityidconvert.add(CityId(id: int.parse(i)));
        }
      } else if (cityidconvert.isNotEmpty) {
        cityidconvert.clear();
        for (var i in cityid) {
          print('test');
          print(i);
          cityidconvert.add(CityId(id: int.parse(i)));
        }
      }

      if (isRefresh) {
        currentPage = 1;
        post.clear();
        print(cityidconvert);
        postbloc.add(GetPostByCityName(
          postscityId: cityidconvert,
          sortby: "desc",
          page: currentPage,
          countItemPerpage: countItemPerpage,
        ));
        print('inside');
        currentPage++;
      }
      if (post.length != totalpost && !isRefresh) {
        print('out');
        print(currentPage);

        postbloc.add(GetPostByCityName(
            postscityId: cityidconvert,
            sortby: "desc",
            page: currentPage,
            countItemPerpage: countItemPerpage));
        currentPage++;
      }
    } else {
      // print(cityid!.length);
      print('else');
      print(totalpost);
      print(post.length);
      if (isRefresh) {
        currentPage = 1;
        post.clear();
        postbloc.add(
            GetAllPost(page: currentPage, countItemPerpage: countItemPerpage));
        print('inside');
        currentPage++;
      }
      if (post.length != totalpost && !isRefresh) {
        print('out');
        postbloc.add(
            GetAllPost(page: currentPage, countItemPerpage: countItemPerpage));
        currentPage++;
      }
    }
    return true;
  }

  void whatsappSender({@required number}) async {
    final String url = "https://api.whatsapp.com/send?phone=+964-$number";
    await launch(url);
  }

  // @override
  // void dispose() {
  //   // refreshController.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    postbloc = BlocProvider.of<PostBloc>(context);
    borssaBloc = BlocProvider.of<BorssaBloc>(context);
    companybloc = BlocProvider.of<CompanyBloc>(context);
    loginbloc = BlocProvider.of<LoginBloc>(context);
    advertisementbloc = BlocProvider.of<AdvertisementBloc>(context);
    advertisementbloc.add(GetAdvertisementEvent());

    postloading();
    sharedValue();
    firebase();
    companybloc.add(GetAllCompanies());
    borssaBloc.add(AllCitiesList());
    super.initState();
  }

  Widget sliderImage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 0),
      child: Column(
        children: [
          Card(
            color: Colors.white,
            child: CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: advertisements
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        margin: EdgeInsets.only(
                          top: 15.0,
                          bottom: 15.0,
                        ),
                        elevation: 5.0,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                              InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: Image.network(item.image),
                                          );
                                        });
                                  },
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: item.image,
                                    fadeInCurve: Curves.bounceIn,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: advertisements.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 10.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  //Carousel tools Start
  int _current = 0;
  final CarouselController _controller = CarouselController();
  //Carousel tools End
  Widget ourListview() {
    return ListView.separated(
      key: _contentKey,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(2),
      itemCount: post.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Card(
              color: Colors.white,

              // color: Color(0xff505D6E),
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
                      post[index].companyId == companyuser
                          ? Container(
                              margin: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: PopupMenuButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.black,
                                  ),
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
                                              id: post[index].id,
                                              type: 'حذف المنشور',
                                              image: post[index].image,
                                              body: post[index].body,
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
                                              id: post[index].id,
                                              type: 'تعديل المنشور',
                                              image: post[index].image,
                                              body: post[index].body,
                                            );
                                          }));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          : Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, top: 15, right: 10, left: 25),
                            ),
                      Container(
                          margin: const EdgeInsets.only(
                              bottom: 10, top: 15, right: 10),
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.black,
                              ),
                              Text(
                                post[index].user.city.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                            ],
                          )),
                      Spacer(),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  post[index].company.name,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Colors.black,
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
                                            post[index].createdAt)) +
                                        " " +
                                        DateFormat.jm().format(DateTime.parse(
                                                post[index].createdAt)
                                            .toUtc()),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ),
                                Text(
                                  post[index].user.name,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AnyCompanyProfile(
                                        id: post[index].companyId,
                                        name: post[index].company.name,
                                      )),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                              post[index].company.image,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          bottom: 10, left: 25, top: 10, right: 25),
                      child: ReadMoreText(
                        post[index].body == "empty" ? "" : post[index].body,
                        trimLines: 6,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'قرائة المزيد',
                        trimExpandedText: '',
                        textAlign: TextAlign.right,
                        // moreStyle: TextStyle(fontSize: 14),
                        style: TextStyle(
                            // color: Colors.black.withOpacity(0.6),
                            color: Colors.black,
                            fontSize: 16),
                      )),
                  Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                        right: 10,
                        left: 10,
                      ),
                      child: post[index].image ==
                                  "https://centralborsa.comno_image" ||
                              post[index].image ==
                                  "https://centralborsa.com/uploads/placeholder.jpg"
                          ? Container()
                          : FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: post[index].image,
                              fadeInCurve: Curves.bounceIn,
                              fit: BoxFit.fill,
                              width: double.infinity,
                            )
                      // child: Image.network(
                      //     post[index].image,
                      //     fit: BoxFit.fill,
                      //     width: double.infinity,
                      //     // height: 200,
                      //   ),
                      ),
                  Padding(
                    padding: const EdgeInsets.only(right: 95, left: 95),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  whatsappSender(
                                      number: post[index].user.phone);
                                },
                                child: Image.asset(
                                  'assest/Images/whatsapp.png',
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  launch("tel://+964${post[index].user.phone}");
                                },
                                child: Icon(
                                  Icons.add_ic_call,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Spacer()
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 1,
      ),
    );
  }

  Widget newEndDrawer() {
    return Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Drawer(
          child: new ListView(
            children: [
              Column(
                children: <Widget>[
                  ListTile(
                      title: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "البحث",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ))),
                  Divider(
                    color: Color(navbar.hashCode),
                    thickness: 1,
                    endIndent: 90,
                    indent: 90,
                    height: 1,
                  ),
                  ListTile(
                    title: Text(
                      "المدينة",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MultiSelectDialogField(
                          items: cities
                              .map((list citiesname) => MultiSelectItem<int?>(
                                  citiesname.id, citiesname.name))
                              .toList(),
                          title: Text("المدن"),
                          selectedColor: Color(navbar.hashCode),
                          initialValue: cityloadedId,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(navbar.hashCode),
                              width: 2,
                            ),
                          ),
                          buttonIcon: Icon(
                            Icons.location_on_outlined,
                            color: Color(navbar.hashCode),
                          ),
                          buttonText: Text(
                            "أختيار المدينة",
                            style: TextStyle(
                              color: Color(Colors.black.hashCode),
                              fontSize: 16,
                            ),
                          ),
                          onConfirm: (List<dynamic> results) {
                            setState(() {
                              print(results);
                              cityid.clear();
                              for (var i = 0; i < results.length; i++) {
                                print('object');
                                cityid.add(CityId(id: results[i].hashCode));
                              }
                              // print(selectedcities);
                            });
                          },
                        ),
                      )
                    ]),
                  ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(navbar.hashCode),
                            alignment: Alignment.center),
                        child: Text('تم'),
                        onPressed: () {
                          if (cityid.isNotEmpty) {
                            print('from here');
                            addsharedValue(cityid);
                            setState(() {
                              isSerach = true;
                            });
                            currentPage = 1;
                            postbloc.add(GetPostByCityName(
                              postscityId: cityid,
                              sortby: "desc",
                              page: currentPage,
                              countItemPerpage: countItemPerpage,
                            ));
                            currentPage++;
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('الرجاء أختيار المدينه المرادة'),
                                action: SnackBarAction(
                                  label: 'تنبيه',
                                  onPressed: () {},
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  logout() async {
    // print('from');
    loginbloc.add(LogoutEvent());
  }

  logoutmethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => SkipePage()),
      ModalRoute.withName('/'),
    );
  }

  Widget newDrawer() {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new Container(
            child: new DrawerHeader(
                child: new CircleAvatar(
              backgroundColor: navbar,
              radius: 30.0,
              child: Image.asset(
                'assest/Images/test2.png',
              ),
            )),
            color: Colors.grey[300],
          ),
          new Container(
              color: Colors.white,
              child: Center(
                child: new Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(userName),
                      leading: new Icon(Icons.account_circle),
                    ),
                    ListTile(
                      title: Text(userPhone),
                      leading: new Icon(Icons.phone),
                    ),
                    ListTile(
                      title: Text(userActive == "" ? "غيرفعال" : userActive),
                      leading: new Icon(Icons.wifi_tethering_outlined),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('تسجيل الخروج'),
                      leading: new Icon(Icons.logout_sharp),
                      onTap: () {
                        logout();
                      },
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey[550],
        backgroundColor: Colors.grey[400],
        drawer: newDrawer(),
        endDrawer: newEndDrawer(),
        appBar: AppBar(
          title: Container(
            margin: EdgeInsets.only(left: 24),
            child: Center(
              child: Text('البورصة المركزية'),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                child: Icon(Icons.search),
                onTap: () {
                  showSearch(context: context, delegate: CitySearchPage());
                },
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.filter_alt_sharp),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                  child: countofMessage != 0
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0, top: 2),
                          child: Badge(
                            badgeContent: Text(countofMessage.toString()),
                            child: Icon(Icons.notification_add_outlined),
                          ),
                        )
                      : Icon(Icons.notification_add_outlined),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    countofMessage = 0;
                    prefs.setInt('countofMessage', 0);
                    messageBody.isNotEmpty
                        ? showDialog(
                            // barrierColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: Center(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              350,
                                      child: SingleChildScrollView(
                                        child: Card(
                                          child: Column(
                                            children: [
                                              for (int i =
                                                      messageBody.length - 1;
                                                  i >= 0;
                                                  i--)
                                                Card(
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'البورصة المركزية',
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      120,
                                                                  child: Text(
                                                                    messageBody[
                                                                        i],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                              );
                            })
                        : Container();
                  }),
            ),
          ],
          backgroundColor: Color(navbar.hashCode),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<PostBloc, PostState>(
              listener: (context, state) {
                if (state is PostLoadingInProgress) {
                  print(state);
                } else if (state is PostsLoadedSuccess) {
                  print(state);
                  if (post.isEmpty) {
                    print(state);
                    print('empty');
                    post = state.posts.posts;
                    totalpost = state.posts.total;
                  } else if (post.isNotEmpty) {
                    post.addAll(state.posts.posts);
                    print('not empty');
                  }
                } else if (state is PostsLoadingError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('خطأ في التحميل'),
                      action: SnackBarAction(
                        label: 'تنبيه',
                        onPressed: () {},
                      ),
                    ),
                  );
                } else if (state is GetPostByCityNameLoading) {
                  print(state);
                } else if (state is GetPostByCityNameError) {
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
                } else if (state is GetPostByCityNameLoaded) {
                  if (post.isEmpty || isSerach) {
                    post.clear();
                    print(state);
                    post = state.posts.posts;
                    totalpost = state.posts.total;
                    setState(() {
                      isSerach = false;
                    });
                  } else if (!isSerach) {
                    post.addAll(state.posts.posts);
                  }
                } else if (state is AddPostSuccess) {
                  print(state);
                  reload();
                  setState(() {});
                }
              },
            ),
            BlocListener<BorssaBloc, BorssaState>(
              listener: (context, state) {
                if (state is AllCitiesLoading) {
                  print(state);
                } else if (state is AllCitiesLoaded) {
                  print(state);
                  cities.clear();
                  cities = state.cities;
                  setState(() {});
                } else if (state is AllCitiesLoadingError) {
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
            BlocListener<CompanyBloc, CompanyState>(
              listener: (context, state) {
                if (state is CompanyNameIsLodaing) {
                  print(state);
                } else if (state is CompanyNameIsLoaded) {
                  print(state);
                  _companiesName.clear();
                  _companiesName = state.companies;
                  setState(() {});
                } else if (state is CompanyNameError) {
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
                } else if (state is DeletePostLoaded) {
                  print(state);
                  reload();
                } else if (state is EditPostLoaded) {
                  print(state);
                  reload();
                }
              },
            ),
            BlocListener<AdvertisementBloc, AdvertisementState>(
              listener: (context, state) {
                if (state is GetAdvertisementLoading) {
                  print(state);
                } else if (state is GetAdvertisementLoaded) {
                  print(state);
                  advertisements.clear();
                  advertisements = state.allAdvertisements;
                  print(advertisements);
                  setState(() {});
                } else if (state is GetAdvertisementError) {
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
            BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LogoutLoaded) {
                  logoutmethod();
                }
                if (state is LogoutError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('حدث خطأ في الطلب'),
                      action: SnackBarAction(
                        label: 'تنبيه',
                        onPressed: () {},
                      ),
                    ),
                  );
                } else if (state is LogoutLoading) {
                  setState(() {
                    // isLogedin = true;
                  });
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
                completeDuration: Duration(milliseconds: 50),
              ),
              onRefresh: () async {
                postloading(isRefresh: true);
                await Future.delayed(Duration(milliseconds: 50));
                if (mounted) setState(() {});
                refreshController.refreshCompleted();
              },
              onLoading: () async {
                await Future.delayed(Duration(milliseconds: 50));
                postloading(isRefresh: false);
                if (mounted) setState(() {});
                if (mounted) setState(() {});
                refreshController.loadFailed();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    sliderImage(),
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
            tooltip: 'إضافة',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddPost();
              }));
            }));
  }
}

class CityId {
  late int? id;
  CityId({
    this.id,
  });

  CityId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class CitySearchPage extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_city, size: 120),
            const SizedBox(height: 48),
            Text(
              query,
              style: TextStyle(
                color: Colors.black,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? _companiesName
        : _companiesName.where((city) {
            final cityLower = city.name.toLowerCase();
            final queryLower = query.toLowerCase();

            return cityLower.startsWith(queryLower);
          }).toList();

    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List<list> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.name.substring(0, query.length);
          final remainingText = suggestion.name.substring(query.length);
          return ListTile(
            onTap: () {
              query = suggestion.name;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AnyCompanyProfile(
                    id: suggestion.id,
                    name: suggestion.name,
                  ),
                ),
              );
            },
            leading: Icon(Icons.location_city),
            title: RichText(
              text: TextSpan(
                text: queryText,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: remainingText,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
