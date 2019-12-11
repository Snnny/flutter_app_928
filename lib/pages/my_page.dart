import 'package:flutter/material.dart';
import 'package:flutter_app_928/router/page_routes.dart';
import 'package:flutter_app_928/widget/price_input_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_928/widget/click_item.dart';
import 'package:flutter_app_928/utils/utils.dart';
import 'package:flutter_app_928/widget/progress_dialog.dart';
// import 'package:redux/redux.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:flutter_toutiao/store/selectors/selectors.dart';
// import 'package:flutter_toutiao/store/states/app_state.dart';

class _ListItem{
  final String title;
  final String message;

  const _ListItem({
    Key key,
    this.title,
    this.message
  });
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState(); 

}

class _MyPageState extends State<MyPage> {

  List assetList = ['头条', '关注', '粉丝', '获赞'];
  List userHistory = ['我的收藏', '我的评论', '我的点赞', '浏览历史'];
  List<_ListItem> list1 = [
    _ListItem(title: '我的钱包', message: '话费优惠，速充值！'),
    _ListItem(title: '消息通知', message: ''),
  ];
  List<_ListItem> list2 = [
    _ListItem(title: '扫一扫', message: ''),
    _ListItem(title: '免流量服务', message: ''),
    _ListItem(title: '阅读公益', message: '今日阅读18分钟'),
    _ListItem(title: '广告投放', message: ''),
  ];
  List<_ListItem> list3 = [
    _ListItem(title: '用户反馈', message: ''),
    _ListItem(title: '系统设置', message: ''),
  ];


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
              children: <Widget>[
                _userHeader,
                _userAsset,
                _userHistory,
                ClickItem(
                  title: '我的钱包',
                  content: '话费优惠，速充值',
                  onTap: (){},
                ),
                ClickItem(
                  title: '消息通知',
                  content: '',
                  onTap: (){},
                ),
//                Gaps.vGap8,
                ClickItem(
                  title: '扫一扫',
                  content: '',
                  onTap: (){},
                ),
                ClickItem(
                  title: '免流量服务',
                  content: '',
                  onTap: (){},
                ),
                ClickItem(
                  title: '阅读公益',
                  content: '今日阅读18分钟',
                  onTap: (){},
                ),
                ClickItem(
                  title: '广告投放',
                  content: '',
                  onTap: (){},
                ),
                ClickItem(
                  title: '用户反馈',
                  content: '',
                  onTap: (){},
                ),
                ClickItem(
                  title: '系统设置',
                  content: '',
                  onTap: (){
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return PriceInputDialog(
                            title: "配送费满免",
                            onPressed: (value){
                              setState(() {
//                                _freePrice = value;
                              });
                            },
                          );
                        });
//                    showTransparentDialog(
//                        context: context,
//                        barrierDismissible: false,
//                        builder:(_) {
//                          return WillPopScope(
//                            onWillPop: () async {
//                              // 拦截到返回键，证明dialog被手动关闭
//                              return Future.value(true);
//                            },
//                            child: const ProgressDialog(hintText: "正在加载..."),
//                          );
//                        }
//                    );



                  },
                ),
//                _buildList(list1, false),
//                _buildList(list2, false),
//                _buildList(list3, true),
              ]
          ),
        ],
      ),
    );
  }

  void _saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserInfo userInfo = UserInfo(username: 'snnny', introduction: 'hhh', avatar: null);
    print('>>>>>存储 ${userInfo.toString()}');
    prefs.setString('user', 'snnny');
  }

  void _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user');
    print('>>>>>获取$user ,');
  }

  get _userHeader {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          print('跳转到个人详情页${PageName.my_detail_page.toString()}');
          Navigator.pushNamed(context, 'my_detail_page');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 120,
              height: 60,
//              color: Colors.redAccent,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  PhysicalModel(
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(25),
                    child: GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Image.network(
                            'https://img2.woyaogexing.com/2019/06/12/5bf5f3a8faf34f43afd8f0ecf0050041!400x400.jpeg'
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          'Snnny',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 18,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '申请认证',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Icon(
                Icons.keyboard_arrow_right
            )
          ],
        ),
      ),
    );
  }

  get _userAsset {
    return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 4, color: Color(0xfff0f0f0)))
      ),
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: GridView.count(
          crossAxisCount: 4,
          children: _buildAsset(),
        ),
      ),
    );
  } 

  get _userHistory {
    return Container(
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
         border: Border(bottom: BorderSide(width: 4, color: Color(0xfff0f0f0)))
      ),
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(), // 禁止gridview滑动
          crossAxisCount: 4,
          children: _buildHistory(),
        ),
      ),
    );
  }

  List<Widget> _buildAsset() {
    return assetList.map((asset)=> _assetItem(asset)).toList();
  } 

  List<Widget> _buildHistory() {
    return userHistory.map((item)=> _historyItem(item)).toList();
  }

  Widget _historyItem(String item) {
    IconData iconData;
    Color color = Colors.redAccent;
    if(item == '我的收藏') {
      iconData = Icons.star;
      color = Colors.orange;
    } else if(item == '我的评论') {
      iconData = Icons.comment;
      color = Colors.lightBlue;
    }else if(item == '我的点赞') {
      iconData = Icons.thumb_up;
    } else {
      iconData = Icons.access_time;
      color = Colors.grey;
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            size: 20,
            color: color,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
            child: Text(
              item,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _assetItem(String asset) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Text(
            '15',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(asset),
        ],
      ),
    );
  }

  Widget _buildList(List<_ListItem> list, bool last) {
    BorderSide borderSide = BorderSide(width: 4, color: Color(0xfff0f0f0));
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
         border: Border(bottom:  last ? BorderSide.none : borderSide)
      ),
      child: _listPart(list),
    );
  }

  Widget _listPart(List<_ListItem> list) {
    List <Widget> items = [];
    for(int i=0; i<list.length; i++) {
      items.add(_listItem(list[i], i==list.length-1),);
    }
    return Column(
      children: items,
    );
  }

  Widget _listItem(_ListItem item, bool last) {
    BorderSide borderSide = BorderSide(width: .5, color: Colors.black12);
    return Container(
      height: 40,
      decoration: BoxDecoration(
         border: Border(bottom: last ? BorderSide.none: borderSide)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            item.title
          ),
          Row(
            children: <Widget>[
              Text(
                item.message,
                style: TextStyle(color: Colors.black38),
              ),
              Padding(
                padding: EdgeInsets.only(left: 1),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black38,
                  size: 22,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}


class UserInfo {
  final dynamic avatar;
  final String username;
  final String introduction;

  UserInfo({this.avatar, this.username, this.introduction});
}
