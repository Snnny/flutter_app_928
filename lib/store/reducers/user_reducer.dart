import 'package:flutter_app_928/store/actions/actions.dart';
import 'package:redux/redux.dart';

final userReducer = combineReducers<Object>([
  TypedReducer<Object, UserAction>(_userAction),
]);

Object _userAction(Object user, UserAction action) {
  return action.user;
}