import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app_928/store/states/app_state.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app_928/store/reducers/app_state_reducer.dart';
import 'package:flutter_app_928/router/page_router.dart';
import 'package:flutter_app_928/splash.dart';

void main() {
  runApp(MyApp());
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.init()
  );


  @override
  Widget build(BuildContext context) {
    PageRouter.setupRoutes();
    return StoreProvider(
      store: store,
      child: RefreshConfiguration(
          headerBuilder: () => WaterDropHeader(),        // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
          footerBuilder:  () => ClassicFooter(),        // 配置默认底部指示器
          headerTriggerDistance: 60.0,        // 头部触发刷新的越界距离
//          springDescription:SpringDescription(stiffness: 170, damping: 16, mass: 1.9),         // 自定义回弹动画,三个属性值意义请查询flutter api
          maxOverScrollExtent :100, //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
          maxUnderScrollExtent:0, // 底部最大可以拖动的范围
          enableScrollWhenRefreshCompleted: true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
          enableLoadingWhenFailed : true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
          hideFooterWhenNotFull: false, // Viewport不满一屏时,禁用上拉加载更多功能
          enableBallisticLoad: true, // 可以通过惯性滑动触发加载更多
          child: MaterialApp(
            title: '今日头条',
            theme: ThemeData(primarySwatch: Colors.blue),
            debugShowCheckedModeBanner: false,
            home: StoreConnector(
              builder: (BuildContext context, AppState state) {
//                return TabNavigator();
                return SplashPage();
              },converter: (Store<AppState> store){
              return store.state;
            },
            ),
            onGenerateRoute: PageRouter.router.generator,
          )
      ),
    );
  }
}
