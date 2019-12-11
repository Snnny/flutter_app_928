import 'package:flutter_app_928/store/actions/actions.dart';
import 'package:redux/redux.dart';

final navListReducer = combineReducers<List<String>>([
  TypedReducer<List<String>, NavListAction>(_navListAction),
  TypedReducer<List<String>, AddNavAction>(_addNavAction),
  TypedReducer<List<String>, RemoveNavAction>(_removeNavAction),
]);

List<String> _navListAction(List<String> navList, NavListAction action) {
  return action.navList;
}

List<String> _addNavAction(List<String> navList, AddNavAction action) {
  return List.from(navList)..add(action.navItem);
}

List<String> _removeNavAction(List<String> navList, RemoveNavAction action) {
  return navList.where((nav)=> nav!=action.navItem).toList();
}