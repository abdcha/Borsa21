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

class AllPost extends StatefulWidget {
  AllPostPage createState() => AllPostPage();
}

late List<list> _companiesname = [];

class AllPostPage extends State<AllPost> {
  final List<String> imagesList = [
    'assest/Images/slider3.jpg',
    'assest/Images/slider3.jpg'
  ];
  late PostBloc postbloc;
  late BorssaBloc borssaBloc;
  late CompanyBloc companybloc;
  late List<Posts> post = [];
  late List<list> cities = [];

  late int totalpost;
  late String? location;
  int currentPage = 1;
  late int countItemPerpage = 3;
  late List<list?> selectedcities = [];
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _refresherKey = GlobalKey();
  logout() async {
    print('from');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> postloading({bool isRefresh = false}) async {
    postbloc
        .add(GetAllPost(page: currentPage, countItemPerpage: countItemPerpage));
    currentPage++;

    if (post.isNotEmpty &&
        (totalpost / countItemPerpage).round() >= currentPage) {
      print('not upper');
      postbloc.add(
          GetAllPost(page: currentPage, countItemPerpage: countItemPerpage));
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

  @override
  void initState() {
    post.clear();
    postbloc = BlocProvider.of<PostBloc>(context);
    borssaBloc = BlocProvider.of<BorssaBloc>(context);
    companybloc = BlocProvider.of<CompanyBloc>(context);
    companybloc.add(GetAllCompanies());
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
                              print(results);
                              selectedcities = results;
                              print(selectedcities);
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
                          print(selectedcities);
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
            BlocListener<CompanyBloc, CompanyState>(
              listener: (context, state) {
                if (state is CompanyNameIsLodaing) {
                  print(state);
                } else if (state is CompanyNameIsLoaded) {
                  print(state);
                  _companiesname.clear();
                  _companiesname = state.companies;
                  print('from company');
                  print(_companiesname);
                  setState(() {
                    // isloading = false;
                  });
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
        ? _companiesname
        : _companiesname.where((city) {
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

              // 1. Show Results
              showResults(context);

              // 2. Close Search & Return Result
              // close(context, suggestion);

              // 3. Navigate to Result Page
              //  Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => ResultPage(suggestion),
              //   ),
              // );
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
