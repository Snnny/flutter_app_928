
import 'package:flutter_app_928/store/states/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

int getCount(AppState state)=> state.count;

isShowNavConfig(AppState state)=> state.showNavConfig;

getAddedNavList(AppState state)=> state.navList;

Object getUser(AppState state) async{
  // 先从本地缓存中取
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Object localUser = prefs.get('user');
  Object reduxUser = state.user;

//  print('本地存储用户信息：$user ; redux:${state.user}');
//  if(user == null) {
//    if(state.user !=null) { // 缓存到本地
////      prefs.se('user', user);
//    }
//    return state.user;
//  }
  return state.user;
}