import 'package:carousel_slider/carousel_slider.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_event.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/data/model/Post/Cities.dart';
import 'package:central_borssa/presentation/Company/company.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class AllPost extends StatefulWidget {
  AllPostPage createState() => AllPostPage();
}

late List<list> _companiesName = [];

class AllPostPage extends State<AllPost> {
  final List<String> imagesList = [
    'assest/Images/slider3.jpg',
    'assest/Images/slider3.jpg',
    'assest/Images/slider3.jpg'
  ];
  late PostBloc postbloc;
  late BorssaBloc borssaBloc;
  late CompanyBloc companybloc;
  late List<Posts> post = [];
  late List<list> cities = [];
  late List<list?> selectedcities = [];
  late List<String> userPermissions = [];

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
  int companyuser = 0;
  int currentPage = 1;

  sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    userPermissions = prefs.getStringList('permissions')!.toList();
    companyuser = int.parse(prefs.get('companyid').toString());
    userType = prefs.get('roles').toString();
    if (prefs.get('end_at') != null) {
      userActive = prefs.get('end_at').toString();
    }
    setState(() {});
  }

  reload() async {
    print('main reload');
    postloading(isRefresh: true);
    await Future.delayed(Duration(milliseconds: 1000));
  }

  Future<bool> postloading({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      print('test');
      post.clear();
      postbloc.add(
          GetAllPost(page: currentPage, countItemPerpage: countItemPerpage));
      currentPage++;
    }
    if (post.length != totalpost && isRefresh == false) {
      postbloc.add(
          GetAllPost(page: currentPage, countItemPerpage: countItemPerpage));
      currentPage++;
    }
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

  @override
  void initState() {
    postbloc = BlocProvider.of<PostBloc>(context);
    borssaBloc = BlocProvider.of<BorssaBloc>(context);
    companybloc = BlocProvider.of<CompanyBloc>(context);
    postloading();
    sharedValue();
    companybloc.add(GetAllCompanies());
    borssaBloc.add(AllCitiesList());
    super.initState();
  }

  //Carousel tools Start
  int _current = 0;
  final CarouselController _controller = CarouselController();
  //Carousel tools End
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
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    children: [
                      Card(
                        child: CarouselSlider(
                          carouselController: _controller,
                          options: CarouselOptions(
                              autoPlay: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  // print(index);
                                  _current = index;
                                });
                              }),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imagesList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Color(navbar.hashCode)
                                          : Colors.black)
                                      .withOpacity(
                                          _current == entry.key ? 0.9 : 0.4)),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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
                                    child: Text(DateFormat.jm().format(
                                        DateTime.parse(post[index].createdAt))),
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
                                    builder: (context) => AnyCompanyProfile(
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
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 1,
        ),
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
                          onConfirm: (List<list?> results) {
                            setState(() {
                              // print(results);
                              selectedcities = results;
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
                        child: Text('البحث'),
                        onPressed: () {
                          // selectedcities.clear();
                          // print(selectedcities);
                          postbloc.add(GetPostByCityName(
                              postscityName: selectedcities,
                              page: 1,
                              countItemPerpage: 5,
                              sortby: "desc"));
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
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          logout();
                          return Loginpage();
                        }));
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
          ],
          backgroundColor: Color(navbar.hashCode),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<PostBloc, PostState>(
              listener: (context, state) {
                if (state is AddPostSuccess) {
                  print(state);
                  print('from add');
                  reload();
                } else if (state is PostLoadingInProgress) {
                  print(state);
                } else if (state is PostsLoadedSuccess) {
                  if (post.isEmpty) {
                    print(state);
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
                await Future.delayed(Duration(milliseconds: 5000));
                postloading(isRefresh: false);
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
              // print('show image');
              // 1. Show Results
              // showResults(context);

              // 2. Close Search & Return Result
              // close(context, suggestion);

              // 3. Navigate to Result Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AnyCompanyProfile(
                    id: suggestion.id,
                  ),
                ),
              );
            },
            leading: Icon(Icons.location_city),
            // title: Text(suggestion),
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
