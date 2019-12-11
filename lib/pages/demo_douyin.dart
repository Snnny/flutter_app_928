import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_928/utils/utils.dart';
import 'package:flutter_app_928/widget/load_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:after_layout/after_layout.dart';
import 'dart:math';

class DouYin extends StatefulWidget {
  @override
  _DouYinState createState() => _DouYinState();
}

class _DouYinState extends State<DouYin> with TickerProviderStateMixin {
  AnimationController animationControllerX;
  AnimationController animationControllerY;
  TabController _controller;
  Animation<double> animationX;
  Animation<double> animationY;
  double offsetX = 0.0;
  double offsetY = 0.0;
  int currentIndex = 0;
  bool isMiddle = true;
  bool absorbing = true;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  void dispose() {
//    animationControllerX.dispose();
//    animationControllerY.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      child: Scaffold(
        body: Listener(
          behavior: HitTestBehavior.deferToChild,
          onPointerMove: (details) {
//            if(offsetX+screenWidth == 0 ) {
//              print('onPointerMove:${details.position.dy}....');
//              if(details.position.dy > 246 && details.position.dy < 391) {
//                return null;
//              }
//            }
            if (offsetX + details.delta.dx >= screenWidth) {
              setState(() {
                offsetX = screenWidth;
              });
            } else if (offsetX + details.delta.dx <= -screenWidth) {
              setState(() {
                offsetX = -screenWidth;
              });
            } else {
              setState(() {
                offsetX += details.delta.dx;
              });
            }
          },
          onPointerUp: (details) {
            if (offsetX.abs() < screenWidth / 2) {
              animateToMiddle();
            } else if (offsetX > 0) {
              animateToLeft(screenWidth);
            } else {
              animateToRight(screenWidth);
            }
          },
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  child: TabBarView(
                    controller: _controller,
//                  dragStartBehavior: DragSart,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: Colors.redAccent),
                        child: Center(
                          child: Text('page1'),
                        ),
                      ),
                      HomePage(),
                    ],
                  ),
                ),
                Positioned(
                  top: ScreenUtil.statusBarHeight,
                  left: 0,
                  width: screenWidth,
                  child: TopTab(controller: _controller),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  width: screenWidth,
                  child: BottomSafeBar(
                    selIndex: 0,
                  ),
                ),
                buildRightPage(),
              ],
            ),
          ),
        ),
//        bottomNavigationBar: BottomSafeBar(
//          selIndex: 0,
//        )
      ),
    );
  }

  void onPageChanged(index) {
    currentIndex = index;
  }

  buildRightPage() => RightPage(offsetX: offsetX, offsetY: offsetY);

  Widget buildMiddlePage() {
    return AbsorbPointer(
      absorbing: absorbing,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
        },
        child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification.direction == ScrollDirection.idle &&
                  notification.metrics.pixels == 0.0) {
                setState(() {
                  absorbing = true;
                });
              }
            },
            child: MiddlePage(
              offsetX: offsetX,
              offsetY: offsetY,
              onPageChanged: onPageChanged,
            )),
      ),
    );
  }

  void animateToMiddle() {
    animationControllerX = AnimationController(
        duration: Duration(milliseconds: offsetX.abs() * 1000 ~/ 500),
        vsync: this);
    final curve = CurvedAnimation(
        parent: animationControllerX, curve: Curves.easeOutCubic);
    animationX = Tween(begin: offsetX, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          offsetX = animationX.value;
        });
      });
    isMiddle = true;
    animationControllerX.forward();
  }

  void animateToRight(double screenWidth) {
    animationControllerX = AnimationController(
        duration: Duration(milliseconds: offsetX.abs() * 1000 ~/ 500),
        vsync: this);
    final curve = CurvedAnimation(
        parent: animationControllerX, curve: Curves.easeOutCubic);
    animationX = Tween(begin: offsetX, end: -screenWidth).animate(curve)
      ..addListener(() {
        setState(() {
          offsetX = animationX.value;
        });
      });
    isMiddle = false;
    animationControllerX.forward();
  }

  void animateToLeft(double screenWidth) {
    animationControllerX = AnimationController(
        duration: Duration(milliseconds: offsetX.abs() * 1000 ~/ 500),
        vsync: this);
    final curve = CurvedAnimation(
        parent: animationControllerX, curve: Curves.easeOutCubic);
    animationX = Tween(begin: offsetX, end: screenWidth).animate(curve)
      ..addListener(() {
        setState(() {
          offsetX = animationX.value;
        });
      });
    isMiddle = false;
    animationControllerX.forward();
  }
}

// 底部导航
class BottomSafeBar extends StatelessWidget {
  const BottomSafeBar({Key key, @required this.selIndex}) : super(key: key);
  final int selIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Container(
        decoration: BoxDecoration(color: Colors.black),
        height: 80,
        // decoration: BoxDecoration(color: Colors.black),
        child: BtmBar(
          selectIndex: selIndex,
        ),
      ),
    );
  }
}

/// 底部导航
class BtmBar extends StatefulWidget {
  BtmBar({Key key, this.selectIndex}) : super(key: key);
  final int selectIndex;

  @override
  _BtmBarState createState() => _BtmBarState();
}

class _BtmBarState extends State<BtmBar> {
  List<bool> selected = List<bool>();
  List<String> selectItems = List<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    super.initState();
    for (var i = 0; i < 4; i++) {
      selected.add(false);
    }
    selected[widget.selectIndex] = true;
  }

  tapItem(int) {}

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: getBtmTextWidget("首页", selected[0], () {
                tapItem(0);
              }, rpx)),
          Expanded(
              flex: 1,
              child: getBtmTextWidget("同城", selected[1], () {
                tapItem(1);
              }, rpx)),
          Expanded(
              flex: 1,
              child: AddIcon(
                tapItem: () {
                  tapItem(3);
                },
              )),
          Expanded(
              flex: 1,
              child: getBtmTextWidget("消息", selected[2], () {
                tapItem(2);
              }, rpx)),
          Expanded(
              flex: 1,
              child: getBtmTextWidget("我", selected[3], () {
                tapItem(3);
              }, rpx)),
        ],
      ),
    );
  }

  getBtmTextWidget(String content, bool ifSelected, tapFunc, double rpx) {
    return FlatButton(
        onPressed: () {
          tapFunc();
        },
        child: Text("$content",
            style: ifSelected
                ? TextStyle(
                    fontSize: 30 * rpx,
                    color: Colors.white,
                    fontWeight: FontWeight.w900)
                : TextStyle(
                    fontSize: 30 * rpx,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w900)));
  }
}

class AddIcon extends StatelessWidget {
  const AddIcon({Key key, @required this.tapItem}) : super(key: key);
  final VoidCallback tapItem;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    double iconHeight = 55 * rpx;
    double totalWidth = 90 * rpx;
    double eachSide = 5 * rpx;
    return Container(
      // decoration: BoxDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 30 * rpx),
      height: iconHeight,
      width: 150 * rpx,
      child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            tapItem();
          },
          child: Stack(
            children: <Widget>[
              Positioned(
                height: iconHeight,
                width: totalWidth - eachSide,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Positioned(
                height: iconHeight,
                width: totalWidth - eachSide,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Positioned(
                height: iconHeight,
                width: totalWidth - eachSide * 2,
                right: eachSide,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.add),
                ),
              ),
            ],
          )),
    );
  }
}

/// 主页面
class MiddlePage extends StatelessWidget {
  final double offsetX;
  final double offsetY;
  final Function onPageChanged;

  const MiddlePage({Key key, this.offsetX, this.offsetY, this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: Transform.translate(
        offset: Offset(offsetX > 0 ? offsetX : offsetX / 5, 0),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              height: 120,
              width: screenWidth,
              child: Container(
                decoration: BoxDecoration(color: Colors.redAccent),
                child: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    if (offsetY >= 20) {
      return Opacity(
        opacity: (offsetY - 20) / 20,
        child: Transform.translate(
          offset: Offset(0, offsetY),
          child: Container(
            height: 44,
            child: Center(
              child: const Text(
                "下拉刷新内容",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      );
    } else {
      return Opacity(
        opacity: max(0, 1 - offsetY / 20),
        child: Transform.translate(
          offset: Offset(0, offsetY),
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 18, color: Colors.grey),
            child: Container(
              height: 44,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 5, 0),
                    child: Icon(
                      Icons.camera_alt,
                      size: 24,
                    ),
                  ),
                  const Text('随拍'),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "推荐",
                          style: TextStyle(color: Colors.white),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: 1,
                          height: 12,
                          color: Colors.white24,
                        ),
                        Text("上海"),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.live_tv,
                    size: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 24, 0),
                    child: Icon(
                      Icons.search,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class TopTab extends StatefulWidget {
  TabController controller;
  TopTab({Key key, this.controller});

  @override
  _TopTabState createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> with SingleTickerProviderStateMixin {
//  TabController _controller;

  @override
  void initState() {
//    _controller = TabController(length: 2, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.search,
                    size: ScreenUtil.getInstance().setHeight(50),
                  ))),
          Expanded(
              flex: 8,
              child: Container(
                width: ScreenUtil.getInstance().setHeight(220),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.getInstance().setHeight(50)),
                child: TabBar(
                    labelStyle: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(36),
                        color: Colors.white),
                    unselectedLabelStyle: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(30),
                        color: Colors.grey[700]),
                    indicatorColor: Colors.white,
                    indicatorPadding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil.getInstance().setHeight(50)),
                    controller: widget.controller,
                    tabs: [
                      Text('关注'),
                      Text('推荐'),
                    ]),
              )),
          Expanded(
              flex: 2,
              child: Icon(
                Icons.live_tv,
                size: ScreenUtil.getInstance().setHeight(50),
              )),
        ],
      ),
    );
  }
}

/// 推荐页

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PanelController panel = PanelController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SlidingUpPanel(
      controller: panel,
      minHeight: 0,
      maxHeight: 600,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      panel: Center(
        child: Text('评论区'),
      ),
      body: GestureDetector(
        onTap: () {
          panel.close();
        },
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Container(
            color: Colors.pinkAccent,
            child: Center(
              child: InkWell(
                onTap: () {
                  panel.open();
                },
                child: Text('打开评论'),
              ),
            ),
          ),
        ),
      ),
    );

//    return Container(
//      width: screenHeight,
//      height: screenHeight,
//      decoration: BoxDecoration(
//        color: Colors.pinkAccent
//      ),
//      child: Stack(
//        children: <Widget>[
//          Positioned(
//            top: 100,
//            left: 100,
//            child: InkWell(
//              onTap: (){
//                Navigator.push(context, TransparentPage(
//                  builder:(BuildContext context) {
//                    return null;
//                  },
//                  fullscreenDialog: true
//                ));
//              },
//              child: Text('推荐页'),
//            ),
//          ),
//        ],
//      ),
//    );
  }
}

//class HomePage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final screenWidth = MediaQuery.of(context).size.width;
//    final screenHeight = MediaQuery.of(context).size.height;
//    PanelController panel = PanelController();
//
//    return SlidingUpPanel(
//      controller: panel,
//      minHeight: 0,
//      borderRadius: BorderRadius.only(
//        topLeft: Radius.circular(24.0),
//        topRight: Radius.circular(24.0)
//      ),
//      panel: Center(
//        child: Text('评论区'),
//      ),
//      body: Container(
//        width: screenHeight,
//        height: screenHeight,
//        decoration: BoxDecoration(
//          color: Colors.pinkAccent
//        ),
//        child: Stack(
//          children: <Widget>[
//            Positioned(
//              top: 100,
//              left: 100,
//              child: InkWell(
//                onTap: (){
//                  panel.open();
//                },
//                child: Text('推荐页'),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//
////    return Container(
////      width: screenHeight,
////      height: screenHeight,
////      decoration: BoxDecoration(
////        color: Colors.pinkAccent
////      ),
////      child: Stack(
////        children: <Widget>[
////          Positioned(
////            top: 100,
////            left: 100,
////            child: InkWell(
////              onTap: (){
////                Navigator.push(context, TransparentPage(
////                  builder:(BuildContext context) {
////                    return null;
////                  },
////                  fullscreenDialog: true
////                ));
////              },
////              child: Text('推荐页'),
////            ),
////          ),
////        ],
////      ),
////    );
//  }
//}

/// 品论页
class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/// 用户页面
class RightPage extends StatelessWidget {
  final double offsetX;
  final double offsetY;

  const RightPage({Key key, this.offsetX, this.offsetY});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Transform.translate(
        offset: Offset(max(0, offsetX + screenWidth), 0),
        child: Container(
          width: screenWidth,
          height: screenHeight,
//          color: Colors.greenAccent,
          child: HomeMain(),
        ));
  }
}

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  // y值
  double preDy = 0;
  // 增加的图片拉伸的高度
  double extraPicHeight = 0;
  // 图片展示方式
  BoxFit fitType = BoxFit.fitWidth;
  // 是否关注
  bool hasFollow = false;
  // 是否展示更多
  bool showMore = false;
  // SliverAppBar 高度
  double expandedHeight = 300;
  //   SliverAppBar 改变的高度
  double changeExpandedHeight = 0;

  @override
  void initState() {
    // TODO: implement initState
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween(begin: 0.0, end: 0.0).animate(controller);
//    ..addListener((){
//    });
    super.initState();
  }

  updatePicHeight(dy) {
    if (preDy == 0) {
      //未拉伸过
      preDy = dy;
    }
    extraPicHeight += dy - preDy;
//    print('extraPicHeight:$extraPicHeight');
    if (extraPicHeight >= 120) {
      fitType = BoxFit.fitHeight;
    } else {
      fitType = BoxFit.fitWidth;
    }
    setState(() {
      preDy = dy;
      extraPicHeight = extraPicHeight;
      fitType = fitType;
    });
  }

  runAnimation() {
    setState(() {
      animation = Tween(begin: extraPicHeight, end: 0.0).animate(controller)
        ..addListener(() {
          setState(() {
            extraPicHeight = animation.value;
            fitType =
                animation.value >= 120 ? BoxFit.fitHeight : BoxFit.fitWidth;
          });
        });
      preDy = 0;
    });
  }

  // 加关注取消关注
  void handleFollow() {
    setState(() {
      if (!hasFollow && !showMore) {
        handleShowMore();
      }
      hasFollow = !hasFollow;
    });
  }

  void handleShowMore() {
    setState(() {
      if(showMore) {
        Timer(const Duration(milliseconds: 300),(){
          changeExpandedHeight = 0;
        });
      } else {
        changeExpandedHeight = 250;
      }
      showMore = !showMore;
    });
  }

  updateExpandedHeight(height) {
    setState(() {
      expandedHeight = height;
    });
  }

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    print('changeExpandedHeight$changeExpandedHeight');
    return Listener(
      onPointerMove: (info) {
        updatePicHeight(info.position.dy);
      },
      onPointerUp: (_) {
        // 抬起
        runAnimation();
        controller.forward(from: 0);
      },
      child: CustomScrollView(
        physics: ClampingScrollPhysics(), // SliverAppBar与SliverList始终贴合
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
            actions: <Widget>[],
            flexibleSpace: FlexibleSpaceBar(
              background: TopBarWithCallback(
                extraPicHeight: extraPicHeight,
                fitType: fitType,
                followCallback: handleFollow,
                hasFollow: hasFollow,
                showMore: showMore,
                handleShowMore: handleShowMore,
                updateHeight: updateExpandedHeight
              ),
            ),
            expandedHeight: expandedHeight + extraPicHeight + changeExpandedHeight*rpx ,
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              height: 30,
              color: Colors.blueAccent,
            );
          }, childCount: 30))
        ],
      ),
    );
  }
}

class SliverTopBar extends StatelessWidget {
  SliverTopBar({
    Key key,
    @required this.extraPicHeight,
    @required this.fitType,
    @required this.followCallback,
    @required this.hasFollow,
    @required this.showMore,
    @required this.handleShowMore,
  });

  final double extraPicHeight;
  final BoxFit fitType;
  final Function followCallback;
  final bool hasFollow;
  final bool showMore;
  final Function handleShowMore;

  // 关注、未关注
  Widget renderFollow(rpx) {
    return hasFollow
        ? FollowAnimation(rpx: rpx, followCallback: followCallback)
        : FollowAnimation2(rpx: rpx, followCallback: followCallback);
  }

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              LoadAssetImage(
                'temple',
                width: 750 * rpx,
                height: 300 * rpx + extraPicHeight,
                format: 'jpg',
                fit: fitType,
              ),
              Container(
                height: 140 * rpx,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    renderFollow(rpx),
                    SizedBox(
                      width: 20 * rpx,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: showMore ? Colors.redAccent : Colors.grey[800],
                          borderRadius:
                              BorderRadius.all(Radius.circular(6 * rpx))),
                      height: 80 * rpx,
                      width: 80 * rpx,
                      child: MoreIcon(
                        clickMore: handleShowMore,
                        showMore: showMore,
                      ),
                    ),
                    SizedBox(
                      width: 20 * rpx,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20 * rpx),
//              Container(
//                width: 750*rpx,
//                padding: EdgeInsets.only(left: 30 *rpx),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text('阳光先生', style: TextStyle(color: Colors.white, fontSize: 35*rpx),),
//                    Text('抖音号 1234567', style: TextStyle(color: Colors.white, fontSize: 25*rpx),),
//                  ],
//                ),
//              ),
              AnimatedCrossFade(
                  firstChild: Container(
                    width: 750 * rpx,
                    padding: EdgeInsets.only(left: 30 * rpx),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '阳光先生',
                          style: TextStyle(
                              color: Colors.white, fontSize: 35 * rpx),
                        ),
                        Text(
                          '抖音号 1234567',
                          style: TextStyle(
                              color: Colors.white, fontSize: 25 * rpx),
                        ),
                      ],
                    ),
                  ),
                  secondChild: Container(
                    width: 750 * rpx,
                    padding: EdgeInsets.only(left: 30 * rpx),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '你可能感兴趣',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20 * rpx),
                              child: Text(
                                '查看更多 >',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                        Container(
                            height: 280 * rpx,
                            padding: EdgeInsets.only(top: 10 * rpx),
//                        color: Colors.redAccent,
                            child: ListView.builder(
                                itemCount: 10,
                                scrollDirection: Axis.horizontal,
//                          physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 280 * rpx,
                                    width: 200 * rpx,
                                    color: Colors.grey[900],
                                    padding: EdgeInsets.all(20 * rpx),
                                    margin: EdgeInsets.only(right: 10 * rpx),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: 120 * rpx,
                                        height: 60 * rpx,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius:
                                              BorderRadius.circular(5 * rpx),
                                        ),
                                        child: Text(
                                          '+关注',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25 * rpx,
                                              letterSpacing: 1),
                                        ),
                                      ),
                                    ),
                                  );
                                }))
                      ],
                    ),
                  ),
                  crossFadeState: showMore
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 300)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * rpx),
                child: Divider(
                  color: Colors.grey[100],
                ),
              ),
              Container(
                height: 100 * rpx,
              ),
            ],
          ),
//           AvatorAnimation(rpx: rpx, top: 240 * rpx  + extraPicHeight, left: 30 * rpx)
          Positioned(
            top: 240 * rpx + extraPicHeight,
            left: 30 * rpx,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(110 * rpx))),
              padding: EdgeInsets.all(15 * rpx),
              width: 220 * rpx,
              height: 220 * rpx,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D500/sign=dde475320ee9390152028d3e4bec54f9/d009b3de9c82d1586d8294a38f0a19d8bc3e42a4.jpg'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TopBarWithCallback extends StatefulWidget {
  TopBarWithCallback({
    Key key,
    @required this.extraPicHeight,
    @required this.fitType,
    @required this.followCallback,
    @required this.hasFollow,
    @required this.showMore,
    @required this.handleShowMore,
    @required this.updateHeight
  });

  final double extraPicHeight;
  final BoxFit fitType;
  final Function followCallback;
  final bool hasFollow;
  final bool showMore;
  final Function handleShowMore;
  final Function(double) updateHeight;
  @override
  _TopBarWithCallbackState createState() => _TopBarWithCallbackState();
}

class _TopBarWithCallbackState extends State<TopBarWithCallback>
    with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliverTopBar(
        extraPicHeight: widget.extraPicHeight,
        fitType: widget.fitType,
        followCallback: widget.followCallback,
        hasFollow: widget.hasFollow,
        showMore: widget.showMore,
        handleShowMore: widget.handleShowMore,
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    // 获取render之后的高度
    RenderBox box = context.findRenderObject();
    double height = box.getMaxIntrinsicHeight(MediaQuery.of(context).size.width);
    print('after----$height');
    widget.updateHeight(height);
  }
}

class FollowAnimation extends StatefulWidget {
  FollowAnimation({Key key, this.rpx, this.followCallback});
  final double rpx;
  final Function followCallback;

  @override
  _FollowAnimationState createState() => _FollowAnimationState();
}

class _FollowAnimationState extends State<FollowAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController controller1;
  Animation animation1;

  bool showText = false;

  @override
  void initState() {
    // TODO: implement initState
    controller1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    animation1 = Tween(begin: 0.0, end: 1.0).animate(controller1)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            showText = true;
          });
        }
      });
    controller1.forward(from: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6 * widget.rpx))),
      height: 80 * widget.rpx,
      width: 300 * widget.rpx,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: widget.followCallback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 200 * widget.rpx,
              height: 80 * widget.rpx,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius:
                      BorderRadius.all(Radius.circular(6 * widget.rpx))),
              child: GestureDetector(
                child: Text(
                  '取消关注',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 10 * widget.rpx,
            ),
            Container(
              width: 90 * widget.rpx * animation1.value,
              height: 80 * widget.rpx,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius:
                      BorderRadius.all(Radius.circular(6 * widget.rpx))),
              child: GestureDetector(
                child: showText
                    ? Text(
                        '私信',
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(''),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FollowAnimation2 extends StatefulWidget {
  FollowAnimation2({Key key, this.rpx, this.followCallback});
  final double rpx;
  final Function followCallback;

  @override
  _FollowAnimation2State createState() => _FollowAnimation2State();
}

class _FollowAnimation2State extends State<FollowAnimation2>
    with SingleTickerProviderStateMixin {
  AnimationController controller1;
  Animation animation1;

  @override
  void initState() {
    // TODO: implement initState
    controller1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    animation1 = Tween(begin: 1.0, end: 0.0).animate(controller1)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {});
        }
      });
    controller1.forward(from: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double rendAni = 1 - animation1.value;
    double sizeBoxW = 100 * widget.rpx * animation1.value;
    double rendwidth = 300 * widget.rpx - sizeBoxW;
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: widget.followCallback,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius:
                      BorderRadius.all(Radius.circular(6 * widget.rpx))),
              height: 80 * widget.rpx,
              width: rendwidth,
              alignment: Alignment.center,
              child: Text(
                '+关注',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28 * widget.rpx,
                    letterSpacing: 2),
              )),
        ),
        SizedBox(width: sizeBoxW),
      ],
    );
  }
}

class AvatorAnimation extends StatefulWidget {
  AvatorAnimation(
      {Key key, @required this.rpx, @required this.top, @required this.left});
  final double rpx;
  final double top;
  final double left;

  @override
  _AvatorAnimationState createState() => _AvatorAnimationState();
}

class _AvatorAnimationState extends State<AvatorAnimation>
    with TickerProviderStateMixin {
  AnimationController controller1;
  AnimationController controller2;

  Animation animation1;
  Animation animation2;

  @override
  void initState() {
    // TODO: implement initState

    controller1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    controller2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    animation1 = RelativeRectTween(
      begin: RelativeRect.fromLTRB(widget.left, widget.top, 0.0, 0.0),
      end: RelativeRect.fromLTRB(widget.left, widget.top + 40.0, 0.0, 0.0),
    ).animate(controller1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
        rect: animation1,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius:
                  BorderRadius.all(Radius.circular(110 * widget.rpx))),
          padding: EdgeInsets.all(15 * widget.rpx),
          width: 120 * widget.rpx,
          height: 120 * widget.rpx,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D500/sign=dde475320ee9390152028d3e4bec54f9/d009b3de9c82d1586d8294a38f0a19d8bc3e42a4.jpg'),
          ),
        ));
  }
}

class MoreIcon extends StatefulWidget {
  MoreIcon({Key key, @required this.clickMore, @required this.showMore});
  final Function clickMore;
  final bool showMore;

  @override
  _MoreIconState createState() => _MoreIconState();
}

class _MoreIconState extends State<MoreIcon>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween(begin: 0.0, end: .5).animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: animation,
      child: IconButton(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          onPressed: () {
            if (widget.showMore == false) {
              controller.forward(from: 0);
            } else {
              controller.reverse();
            }
            widget.clickMore();
          }),
    );
  }
}
