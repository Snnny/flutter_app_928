import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:english_words/english_words.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Short_video_subpage extends StatefulWidget {

  final String type;

  Short_video_subpage({this.type});

  @override
  _Short_video_subpageState createState() => _Short_video_subpageState();
}

class _Short_video_subpageState extends State<Short_video_subpage> with AutomaticKeepAliveClientMixin{

  var _words = <String>[];
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
//      header: WaterDropHeader(),
      header: CustomHeader(
        builder: (BuildContext context,RefreshStatus mode){
          Widget body ;
          if(mode==RefreshStatus.idle){
            body =  Text("下拉推荐");
          }
          else if(mode==RefreshStatus.refreshing){
            body =  Text("推荐中...");
          }
          else if(mode == RefreshStatus.failed){
            body = Text("加载失败！点击重试！");
          }
          else if(mode == RefreshStatus.canRefresh){
            body = Text("松手推荐");
          }
          else{
            body = Container(
              color: Color(0xFF87CEEB),
              height: 45.0,
              child: Center(
                child: Text("今日头条推荐引擎更新20条数据", style: TextStyle(color: Colors.lightBlue),),
              ),
            );
          }
          return Container(
            height: 45.0,
            child: Center(child:body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: _words.length == 0
          ? Center(
              child: CupertinoActivityIndicator(

              ),
            )
          : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              childAspectRatio: 0.8
          ),
          itemCount: _words.length,
          itemBuilder: (BuildContext context,int index){
            return _buildItem(index, context);
          }
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('init:${widget.type}');
    _onRefresh();
  }

  Widget _buildItem(index, context) {
    return Container(
      color: Colors.blueAccent,
      child: Center(
        child: Text(_words[index], style: TextStyle(color: Colors.white),),
      ),
    );
  }


  void _onRefresh() async{
    // monitor network fetch
    print('_onRefresh');
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _words.insertAll(0,
        //每次生成20个单词
        generateWordPairs().take(20).map((e) => e.asPascalCase).toList()
    );
    if(mounted)
      setState(() {

      });
    _refreshController.refreshCompleted();
  }

}
