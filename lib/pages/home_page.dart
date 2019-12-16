import 'package:flutter/material.dart';
import 'package:flutter_module/dao/home_dao.dart';
import 'package:flutter_module/model/common_model.dart';
import 'package:flutter_module/widget/local_nav.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    // TODO: implement createState
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  final PageController _controller = PageController(initialPage: 0);
  List _imageUrls = [
    'http://pic44.nipic.com/20140723/18505720_094503373000_2.jpg',
    'http://pic34.nipic.com/20131030/2455348_194508648000_2.jpg',
    'https://p2.ssl.qhimgs1.com/sdr/400__/t0100714605ba9621e2.jpg'
  ];

  double appBarAlpha = 0;
  String resultString = "";
  List<CommonModel> localNavList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  loadData() {
    HomeDao.fetch().then((result) {
      setState(() {
        localNavList = result.localNavList;
      });
    }).catchError((e) {
      setState(() {
        resultString = e.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: NotificationListener(
                // ignore: missing_return
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification &&
                      scrollNotification.depth == 0) {
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                },
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 200,
                      child: Swiper(
                        itemCount: _imageUrls.length,
                        autoplay: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(
                            _imageUrls[index],
                            fit: BoxFit.fill,
                          );
                        },
                        pagination: SwiperPagination(),
                      ),
                    ),
                    LocalNav(localNavList: localNavList),
                    Container(
                      height: 6000,
                      child: Text(resultString),
                    )
                  ],
                )),
          ),
          Opacity(
            opacity: appBarAlpha,
            child: Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('首页'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
