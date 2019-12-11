
import 'package:flutter_app_928/store/reducers/count_reducer.dart';
import 'package:flutter_app_928/store/reducers/navconfig_reducer.dart';
import 'package:flutter_app_928/store/states/app_state.dart';
import 'package:flutter_app_928/store/reducers/navList_reducer.dart';
import 'package:flutter_app_928/store/reducers/restnavList_reducer.dart';
import 'package:flutter_app_928/store/reducers/user_reducer.dart';

/// APP reducers
AppState appReducer(AppState state, action){
  return AppState(
    count: countReducer(state.count, action),
    showNavConfig: navconfigReducer(state.showNavConfig, action),
    navList: navListReducer(state.navList, action),
    restnavList: restnavListReducer(state.restnavList, action),
    user: userReducer(state.user, action),
  );
}
