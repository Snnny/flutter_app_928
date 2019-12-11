import 'package:flutter_app_928/store/actions/actions.dart';
import 'package:redux/redux.dart';

final countReducer = combineReducers<int>([
  TypedReducer<int, AddCount>(_addCount),
]);

int _addCount(int count, AddCount action) {
  print('AddCount$count');
  return count + 1;
}