import 'package:carousel_slider/carousel_slider.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_event.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/data/model/Post/Cities.dart';
import 'package:central_borssa/presentation/Company/company.dart';
import 'package:central_borssa/presentation/Main/HomeOfApp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

import 'package:central_borssa/business_logic/Company/bloc/company_bloc.dart';
import 'package:central_borssa/business_logic/Post/bloc/post_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Post/GetPost.dart';
import 'package:central_borssa/presentation/Post/add_Post.dart';
import 'package:url_launcher/url_launcher.dart';

class AllPost extends StatefulWidget {
  AllPostPage createState() => AllPostPage();
}

class AllPostPage extends State<AllPost> {
  final List<String> imagesList = [
    'assest/Images/slider3.jpg',
    'assest/Images/slider3.jpg'
  ];
  late PostBloc bloc;
  late BorssaBloc borssaBloc;
  late CompanyBloc companybloc;
  late List<Posts> post = [];
  late List<list> cities = [];

  late int totalpost;
  late String? location;
  int currentPage = 1;
  late int countItemPerpage = 3;
  late List<Object> selectedcities= [];
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _refresherKey = GlobalKey();

  Future<bool> postloading({bool isRefresh = false}) async {
    bloc.add(GetAllPost(page: currentPage, CountItemPerpage: countItemPerpage));
    currentPage++;

    if (post.isNotEmpty &&
        (totalpost / countItemPerpage).round() >= currentPage) {
      print('not upper');
      bloc.add(
          GetAllPost(page: currentPage, CountItemPerpage: countItemPerpage));
      currentPage++;

      print('Not Empty');
    }

    print(currentPage);
    return true;
  }

  void whatsappSender({@required number, @required message}) async {
    final String url = "https://api.whatsapp.com/send?phone=$number";

    await launch(url);
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  late final _citiesname;

  @override
  void initState() {
    post.clear();
    bloc = BlocProvider.of<PostBloc>(context);
    borssaBloc = BlocProvider.of<BorssaBloc>(context);
    borssaBloc.add(AllCitiesList());

    postloading();
    super.initState();
  }

  Widget ourListview() {
    return Container(
      child: ListView.separated(
        key: _contentKey,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(2),
        itemCount: post.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              if (index == 0)
                // Slider Images
                Container(
                  child: Card(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                      ),
                      items: imagesList
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.all(10.0),
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
                                      Image.asset(
                                        item,
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              Card(
                elevation: 5.0,
                shadowColor: Colors.black,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(30.0),
                // ),
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
                                bottom: 10, left: 25, top: 15, right: 10),
                            child: Column(
                              children: [
                                Icon(Icons.location_on_outlined),
                                Text(
                                  post[index].user.city.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              ],
                            )),
                        Spacer(),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    post[index].company.name,
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
                                        // DateFormat.Hm().format(
                                        //   DateTime.parse(
                                        // post[index].createdAt
                                        // ))
                                        'time'),
                                  ),
                                  Text(
                                    post[index].user.name,
                                    textAlign: TextAlign.end,
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
                                    builder: (context) => anyCompanyProfile(
                                          id: post[index].companyId,
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
                          post[index].body,
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'قرائة المزيد',
                          trimExpandedText: 'قرائة الأقل',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                        right: 10,
                        left: 10,
                      ),
                      child: post[index].image ==
                                  "https://ferasalhallak.onlineno_image" ||
                              post[index].image ==
                                  "https://ferasalhallak.online/uploads/placeholder.jpg"
                          ? Container()
                          : Image.network(
                              post[index].image,
                              fit: BoxFit.fill,
                              width: double.infinity,
                              // height: 200,
                            ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 15, left: 15, top: 15, right: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    whatsappSender(
                                        message: "hi",
                                        number: '+9647716600999');
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
                                    launch("tel://+9647716600999");
                                  },
                                  child: Icon(
                                    Icons.add_ic_call,
                                    color: Color(navbar.hashCode),
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
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  late DateTime _startDate = DateTime.now();
  late DateTime _endDate = DateTime.now();

  void _selectDate(bool type) async {
    if (type) {
      final DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(2017, 1),
        lastDate: DateTime(2022, 7),
        helpText: 'الرجاء أختيار الوقت',
      );
      _startDate = newDate!;
      print(_startDate);
    }
    if (!type) {
      final DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: DateTime(2017, 1),
        lastDate: DateTime(2022, 7),
        helpText: 'الرجاء أختيار الوقت',
      );
      _endDate = newDate!;
      print(_endDate);
    }
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
            color: Colors.white,
          ),
          new Container(
              color: Colors.white30,
              child: Center(
                child: new Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(''),
                      leading: new Icon(Icons.account_circle),
                      onTap: () {
                        // Update the state of the app.//feas
                        // ...
                      },
                    ),
                    ListTile(
                      title: Text('userPhone'),
                      leading: new Icon(Icons.phone),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                    ListTile(
                      title: Text(''),
                      leading: new Icon(Icons.location_on_outlined),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                    ListTile(
                      leading: new Icon(Icons.online_prediction_outlined),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget newEndDrawer() {
    return Directionality(
        textDirection: TextDirection.rtl,
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
                      "الوقت",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "تاريخ البداية",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    leading: InkWell(
                      child: Icon(Icons.calendar_today_outlined),
                      onTap: () {
                        _selectDate(true);
                      },
                    ),
                    subtitle: Text('تاريخ البداية المطلوب'),
                  ),
                  ListTile(
                    title: Text(
                      "تاريخ النهاية",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    leading: InkWell(
                      child: Icon(Icons.calendar_today_outlined),
                      onTap: () {
                        _selectDate(true);
                      },
                    ),
                    subtitle: Text('تاريح النهاية المطلوب'),
                  ),
                  Divider(
                    color: Color(navbar.hashCode),
                    thickness: 1,
                    endIndent: 50,
                    indent: 8.5,
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
                              .map((list citiesname) => MultiSelectItem<list?>(
                                  citiesname, citiesname.name))
                              .toList(),
                          title: Text("المدن"),
                          selectedColor: Color(navbar.hashCode),
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
                          onConfirm: (results) {
                            selectedcities.add(results);
                          },
                        ),
                      )
                    ]),
                  ),
                  ListTile(
                    title: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(navbar.hashCode),
                          alignment: Alignment.center),
                      child: Text('البحث'),
                      onPressed: () {
                        print(_startDate);
                        print(_endDate);
                        print(selectedcities);
                        // borssaBloc.add(AllCitiesList());
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        drawer: newDrawer(),
        endDrawer: newEndDrawer(),
        appBar: AppBar(
          title: Center(
            child: Text('البورصة المركزية'),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                  child: Icon(Icons.notification_add_outlined), onTap: () {}),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                child: Icon(Icons.search),
                onTap: () {
                  showSearch(context: context, delegate: CitySearch());
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
                  if (post.isEmpty) {
                    post = state.posts.posts;
                    totalpost = state.posts.total;
                  } else if (post.isNotEmpty) {
                    post.addAll(state.posts.posts);
                  } else {
                    print(state);
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
                  print(cities);
                  setState(() {
                    // isloading = false;
                  });
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
                completeDuration: Duration(milliseconds: 500),
              ),
              onRefresh: () async {
                postloading(isRefresh: true);
                await Future.delayed(Duration(milliseconds: 1000));
                if (mounted) setState(() {});
                refreshController.refreshCompleted();
              },
              onLoading: () async {
                await Future.delayed(Duration(milliseconds: 180));
                postloading();
                if (mounted) setState(() {});
                if (mounted) setState(() {});

                refreshController.loadFailed();
              },
              child: ourListview(),
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
