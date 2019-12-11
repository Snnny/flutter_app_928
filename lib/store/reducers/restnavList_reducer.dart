import 'package:flutter_app_928/store/actions/actions.dart';
import 'package:redux/redux.dart';

final restnavListReducer = combineReducers<List<String>>([
  TypedReducer<List<String>, RestNavListAction>(_restnavListAction),
  TypedReducer<List<String>, AddNavAction>(_addNavAction),
  TypedReducer<List<String>, RemoveNavAction>(_removeNavAction),
]);

List<String> _restnavListAction(List<String> restnavList, RestNavListAction action) {
  return action.restnavList;
}

List<String> _addNavAction(List<String> restnavList, AddNavAction action) {
  return restnavList.where((nav)=> nav!=action.navItem).toList();
}

List<String> _removeNavAction(List<String> restnavList, RemoveNavAction action) {
  return List.from(restnavList)..insert(0, action.navItem);
}