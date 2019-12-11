class AddCount{
  final int count;
  AddCount({this.count});
}

class ShowNavConfig{
  final bool show;
  ShowNavConfig({this.show});
}

class NavListAction{
  final List navList;
  NavListAction({this.navList});
}

class RestNavListAction{
  final List restnavList;
  RestNavListAction({this.restnavList});
}


class AddNavAction {
  final String navItem;
  AddNavAction({this.navItem});
}

class RemoveNavAction {
  final String navItem;
  RemoveNavAction({this.navItem});
}

class UserAction {
  final Object user;
  UserAction({this.user});
}