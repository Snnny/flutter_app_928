import 'package:flutter_app_928/store/actions/actions.dart';
import 'package:redux/redux.dart';

final navconfigReducer = combineReducers<bool>([
  TypedReducer<bool, ShowNavConfig>(_showNavconfig),
]);

bool _showNavconfig(bool show, ShowNavConfig action) {
  print('_showNavconfig${action.show},$show');
  return action.show;
}