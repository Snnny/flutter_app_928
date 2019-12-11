import 'package:flutter/material.dart';
import 'package:flutter_app_928/pages/home_page.dart';
import 'package:flutter_app_928/pages/melon_video.dart';
import 'package:flutter_app_928/pages/my_page.dart';
import 'package:flutter_app_928/pages/short_video_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState(); 

}

class _TabNavigatorState extends State<TabNavigator> {
  final PageController _controller = PageController(
    initialPage: 0
  );

  final _defaultColor = Colors.grey;
  final _activeColor = Colors.lightBlue;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomePage(),
          MelonVideoPage(),
          ShortVideoPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: ThemeData( // 去掉导航水波纹
          brightness: Brightness.light,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 20.0,
          selectedFontSize: 12.0,
//        elevation: 15.0,
          onTap: (index){
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            _bottomNavigationBarItem('首页', Icons.home, 0),
            _bottomNavigationBarItem('西瓜视频', Icons.video_label, 1),
            _bottomNavigationBarItem('小视频', Icons.videocam, 2),
            _bottomNavigationBarItem('我的', Icons.account_circle, 3),
          ],
        ),
      ),
    );
  }

  _bottomNavigationBarItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon, 
        color: _defaultColor,
      ),
      activeIcon: Icon(
        icon,
        color: _activeColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _currentIndex == index ? _activeColor : _defaultColor
        ),
      )
    );
  }

}