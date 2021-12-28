import 'package:central_borssa/business_logic/Company/bloc/company_bloc.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_state.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_event.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:central_borssa/data/model/Post/CompanyPost.dart';
import 'package:central_borssa/data/model/Post/CompanyInfo.dart'
    as companyInfor;

import 'package:intl/intl.dart';

class AnyCompanyProfile extends StatefulWidget {
  final int id;
  final String name;
  const AnyCompanyProfile({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);
  CompanyPage createState() => CompanyPage();
}

class CompanyPage extends State<AnyCompanyProfile> {
  void whatsappSender({required String number, @required message}) async {
    String temp = number.substring(0);
    final String url = "https://api.whatsapp.com/send?phone=+964-$temp";
    await launch(url);
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _refresherKey = GlobalKey();
  int currentPage = 1;
  late int countItemPerpage = 30;
  late companyInfor.Data companyInfo;
  late CompanyBloc bloc;
  late List<Posts> companypost = [];
  late bool followStatus;
  late bool isFollowed;
  late int companyuser = 0;
  late int totalpost = 0;
  late String? location;
  bool isEmpty = true;
  bool infoloaded = false;
  Future<bool> postloading({bool isRefresh = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyuser = int.parse(prefs.get('companyid').toString());

    if (isRefresh) {
      bloc.add(GetAllCompanyInformationsEvent(
          id: widget.id,
          pageSize: countItemPerpage,
          date: "desc",
          page: currentPage));
      currentPage++;
    }
    print(companypost.length);
    if (companypost.length != totalpost) {
      bloc.add(GetAllCompanyInformationsEvent(
          id: widget.id,
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
            Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            whatsappSender(
                                message: "hi",
                                number: companyInfo.company.phone);
                          },
                          child: Image.asset(
                            'assest/Images/whatsapp.png',
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                      isFollowed == true
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {
                                    bloc.add(UnFollowEvent(id: widget.id));
                                  },
                                  child: Text(
                                    'متابعة',
                                    style: TextStyle(color: Colors.blue[700]),
                                  )),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {
                                    bloc.add(FollowEvent(id: widget.id));
                                  },
                                  child: Text('متابعة')))
                    ],
                  ),
                )),
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
                                  bottom: 10, left: 25, top: 10, right: 10),
                              child: Column(
                                children: [
                                  Icon(Icons.location_on_outlined),
                                  Text(companypost[index].user.city.name),
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
                          top: 10,
                          right: 10,
                          left: 10,
                        ),
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
      ),
    );
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    bloc = BlocProvider.of<CompanyBloc>(context);
    bloc.add(GetCompanyInfoEvent(id: widget.id));
    companypost.clear();
    postloading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Container(
          height: 50,
          margin: EdgeInsets.only(right: 60),
          child: Center(
            child: Image.asset('assest/Images/test2.png'),
          ),
        ),
        backgroundColor: Color(navbar.hashCode),
      ),
      backgroundColor: Colors.grey[300],
      body: MultiBlocListener(
        listeners: [
          BlocListener<CompanyBloc, CompanyState>(
            listener: (context, state) {
              if (state is GetAllInformationLoading) {
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
              } else if (state is GetCompanyInfoLoaded) {
                print(state);
                companyInfo = state.data;
                isFollowed = companyInfo.isFollow == false ? false : true;
                setState(() {
                  infoloaded = true;
                });
              } else if (state is FollowIsLoading) {
                print(state);
              } else if (state is FollowIsLoaded) {
                print(state);
                followStatus = state.status;
                setState(() {
                  isFollowed = true;
                });
              } else if (state is FollowError) {
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
              } else if (state is UnFollowIsLoading) {
                print(state);
              } else if (state is UnFollowIsLoaded) {
                print(state);
                followStatus = state.status;
                setState(() {
                  isFollowed = false;
                });
              } else if (state is UnFollowError) {
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
              await Future.delayed(Duration(milliseconds: 600));
              if (mounted) setState(() {});
              refreshController.refreshCompleted();
            },
            onLoading: () async {
              await Future.delayed(Duration(milliseconds: 180));
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
    );
  }
}
