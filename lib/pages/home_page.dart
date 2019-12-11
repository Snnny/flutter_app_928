import 'package:flutter/material.dart';
import 'package:flutter_app_928/utils/utils.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app_928/store/actions/actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app_928/store/states/app_state.dart';
import 'package:flutter_app_928/widget/navigatorConfig.dart';
import 'package:flutter_app_928/widget/searchBar.dart';
import 'package:flutter_app_928/widget/app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState(); 

}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  List navList = ['关注', '推荐', '直播','影视','游戏','社会','历史','NBA','国外'];
  double moveY = 80;

  @override
  void initState() {
    _tabController = TabController(length: navList.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       body: Stack(
         children: <Widget>[
           MediaQuery.removePadding(
             removeTop: true,
             context: context,
             child: _tabs,
           ),
          NavigatorConfig(),
          _appBar
         ],
       ),
    );
  }
  Widget get _appBar{
    return Container(
      height: 80.0,
      padding: EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
        color: Colors.redAccent
      ),
      child: SearchBar(
        defaultText: '今日头条上市',
        hint: '今日头条上市',
      ),
    );
  }

  Widget get _tabs{
    return Container(
      padding: EdgeInsets.only(top: 80),
      // color: Colors.white,
      child: Column(
      children: <Widget>[
        Container(
          height: 35,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey)),
            color: Colors.white,
          ),
          child: GestureDetector(
            onTap: (){
            },
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.redAccent,
                    unselectedLabelColor: Colors.black,
                    labelPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide.none
                    ),
                    tabs: navList.map<Tab>((item){
                      return Tab(text: item,);
                    }).toList(),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: StoreConnector<AppState, VoidCallback>(
                    converter:  (Store<AppState> store){
                        return ()=> store.dispatch(ShowNavConfig(show: !store.state.showNavConfig));
                    },
                    builder: (BuildContext context, VoidCallback callback){
                      return GestureDetector(
                        onTap: callback,
                        child: Container(
                          height: 35,
                          width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white10, Colors.white],
                              begin: Alignment.centerLeft,
                              end: Alignment.center
                            ),
                            
                          ),
                          child: Icon(
                            Icons.menu,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: TabBarView(
            controller: _tabController,
            children: navList.map((item){
              return Text(item);
            }).toList(),
          ),
        ),
        
      ],
    ),
    );
  }
}