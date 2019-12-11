import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_app_928/pages/short_video_subpage.dart';

class ShortVideoPage extends StatefulWidget {
  @override
  _ShortVideoPageState createState() => _ShortVideoPageState(); 

}

class _ShortVideoPageState extends State<ShortVideoPage> with SingleTickerProviderStateMixin{

  TabController _tabController;
  List navList = ['关注', '推荐', '附近','活动','游戏'];

  @override
  void initState() {
    _tabController = TabController(length: navList.length, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
       body: Stack(
         children: <Widget>[
           MediaQuery.removePadding(context: context, removeTop: true,
               child: Column(
                 children: <Widget>[
                   Container(
                       height: 80.0,
                       padding: EdgeInsets.only(top: 40.0),
                       decoration: BoxDecoration(
                         border: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFF0F0F0)))
                       ),
                       child: Row(
                         children: <Widget>[
                           Expanded(
                             child: TabBar(
                               controller: _tabController,
                               isScrollable: true,
                               labelColor: Colors.redAccent,
                               labelStyle: TextStyle(fontSize: 18),
                               unselectedLabelColor: Colors.black,
                               unselectedLabelStyle: TextStyle(fontSize: 16),
                               labelPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                               indicator: UnderlineTabIndicator(
                                   borderSide: BorderSide.none
                               ),
                               tabs: navList.map<Tab>((item){
                                 return Tab(text: item,);
                               }).toList(),
                             ),
                           ),
                           Container(
                             width: 100.0,
                           )
                         ],
                       )
                   ),
                   Expanded(
                       flex: 1,
                       child: Container(
                         color: Color(0xfff0f0f0),
                         child: TabBarView(
                           controller: _tabController,
                           children: navList.map((item){
                             return Center(
                               child: Short_video_subpage(type: item),
                             );
                           }).toList(),
                         ),
                       )
                   )
                 ],
               )
           )
         ],
       ),
      
    );
  }
}