import 'package:carousel_slider/carousel_slider.dart';
import 'package:central_borssa/presentation/Company/company.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

import 'package:central_borssa/business_logic/Company/bloc/company_bloc.dart';
import 'package:central_borssa/business_logic/Post/bloc/post_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Post/GetPost.dart';
import 'package:central_borssa/presentation/Post/add_Post.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class AllPost extends StatefulWidget {
  AllPostPage createState() => AllPostPage();
}

final List<String> imagesList = [
  'assest/Images/slider3.jpg',
  'assest/Images/slider3.jpg'
];
late PostBloc bloc;
late CompanyBloc companybloc;
late List<Posts> post = [];

late int totalpost;
late String? location;

class AllPostPage extends State<AllPost> {
  int currentPage = 1;
  late int countItemPerpage = 3;
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

  @override
  void initState() {
    post.clear();
    bloc = BlocProvider.of<PostBloc>(context);

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
                                    child: Text(DateFormat.Hm().format(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: BlocListener<PostBloc, PostState>(
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
