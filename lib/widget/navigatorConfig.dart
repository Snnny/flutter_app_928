import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app_928/store/actions/actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app_928/store/selectors/selectors.dart';
import 'package:flutter_app_928/store/states/app_state.dart';

// 定义函数类型
typedef OnAddCallback = Function(String navItem);
typedef OnRemoveCallback = Function(String navItem);

class NavigatorConfig extends StatefulWidget {
  @override
  _NavigatorConfigState createState()=> _NavigatorConfigState();

}


class _NavigatorConfigState extends State<NavigatorConfig> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;
  double moveY = 80;
  bool isTouchMove = false;
  bool editable = false; // 是否处于编辑状态
  String btnTitle = '编辑';

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween<double>(begin: 880, end: 80).animate(_controller)
    ..addListener(() {
      setState(() {
        moveY = animation.value;    
      });
    });
    super.initState();
  }

  playAnimation(play) {
    if(play) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    
    return StoreConnector<AppState, bool>(
      converter: (Store<AppState> store)=> isShowNavConfig(store.state),
      builder: (BuildContext context, bool show) {
        playAnimation(show);
        return Positioned(
          top: isTouchMove ? moveY : animation.value,
          bottom: 0,
          left: 0,
          right: 0,
          child: StoreConnector<AppState, VoidCallback>(
            converter: (Store<AppState> store){
              return (){
                store.dispatch(ShowNavConfig(show: false));
              };
            },
            builder: (BuildContext context, VoidCallback callback) {
              return GestureDetector(
                onPanUpdate: (e)=> _handleMove(e),
                onPanEnd: (e)=> _tapCanel(callback),
                behavior: HitTestBehavior.opaque,
                child: PhysicalModel(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                      padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                      decoration: BoxDecoration(
                        color: Color(0xfff2f2f2),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Positioned(
                            left: 0,
                            top: 0,
                            right: 0,
                            height: 40.0,
                            child: StoreConnector<AppState, VoidCallback>(
                              converter: (Store<AppState> store) {
                                return (){
                                  store.dispatch(ShowNavConfig(show: false));
                                };
                              },
                              builder: (BuildContext context, VoidCallback callback) {
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: ()=> _tapClose(callback),
//                                    enableFeedback: false,
//                                    excludeFromSemantics: false,
                                    child: Icon(Icons.close),
                                  ),
                                );
                              },
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Expanded(
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(top: 25.0),
                                          margin: EdgeInsets.symmetric(vertical: 10.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                      '我的频道',
                                                      style: TextStyle(fontSize: 18, color: Colors.black,)
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 5),
                                                    child: Text(
                                                        '点击频道进入',
                                                        style: TextStyle(fontSize: 12, color: Colors.grey,)
                                                    ),
                                                  )
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: _handleEdit,
                                                child: Container(
                                                  width: 55,
                                                  height: 24,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(width: 0.5, color: Colors.redAccent),
                                                      borderRadius: BorderRadius.circular(12)
                                                  ),
                                                  child: AnimatedSwitcher(
                                                    transitionBuilder: (child, anim){
                                                      return ScaleTransition(child: child,scale: anim);
                                                    },
                                                    duration: Duration(milliseconds: 300),
                                                    child: Text(
                                                      btnTitle,
                                                      key: ValueKey(btnTitle),
                                                      style: TextStyle(
                                                          color: Colors.redAccent,
                                                          fontSize: 14
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        StoreConnector<AppState, List>(
                                          converter: (Store<AppState> store) => store.state.navList,
                                          builder: (BuildContext context, List navList) {
                                            return GridView.count(
                                              shrinkWrap: true,
                                              crossAxisCount: 4,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                              padding: const EdgeInsets.all(8.0),
                                              childAspectRatio: 2.0,
                                              physics: NeverScrollableScrollPhysics(),
                                              children: navList.map((item) {
                                                return Stack(
                                                  overflow: Overflow.visible,
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.all(8.0),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        item,
                                                        style: TextStyle(
                                                            fontSize: 16
                                                        ),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    Positioned(
                                                      right: -6.0,
                                                      top: -6.0,
                                                      width: 16.0,
                                                      height: 16.0,
                                                      child: editable
                                                          ? StoreConnector<AppState, OnRemoveCallback>(
                                                              converter: (Store<AppState> store){
                                                                return (navItem) {
                                                                  print('remove$navItem');
                                                                  store.dispatch(RemoveNavAction(navItem: navItem));
                                                                };
                                                              },
                                                              builder: (BuildContext context, OnRemoveCallback onRemove) {
                                                                return GestureDetector(
                                                                  onTap: ()=> onRemove(item),
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.black26,
                                                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),

                                                                    ),
                                                                    child: Icon(
                                                                      Icons.close,
                                                                      size: 14.0,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          : Text('')
                                                    )
                                                  ],
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                        Container(
                                          // margin: EdgeInsets.only(bottom: 15.0),
                                          margin: EdgeInsets.symmetric(vertical: 10.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                  '频道推荐',
                                                  style: TextStyle(fontSize: 18, color: Colors.black,)
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 5),
                                                child: Text(
                                                    '点击添加频道',
                                                    style: TextStyle(fontSize: 12, color: Colors.grey,)
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        StoreConnector<AppState, List>(
                                          converter: (Store<AppState> store) => store.state.restnavList,
                                          builder: (BuildContext context, List restnavList) {
                                            return GridView.count(
                                              shrinkWrap: true,
                                              crossAxisCount: 4,
                                              mainAxisSpacing: 10.0,
                                              crossAxisSpacing: 10.0,
                                              padding: const EdgeInsets.all(4.0),
                                              childAspectRatio: 2.0,
                                              physics: NeverScrollableScrollPhysics(),
                                              children: restnavList.map((item) {
                                                return StoreConnector<AppState, OnAddCallback>(
                                                    converter: (Store<AppState> store) {
                                                      return (navItem){
                                                        store.dispatch(AddNavAction(navItem: navItem));
                                                      };
                                                    },
                                                    builder: (BuildContext context, OnAddCallback onAdd){
                                                      return GestureDetector(
                                                        onTap: ()=>onAdd(item),
                                                        child: Container(
                                                            color: Colors.white,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: <Widget>[
                                                                Icon(
                                                                  Icons.add,
                                                                  size: 18,
                                                                ),
                                                                Text(
                                                                  item,
                                                                  style: TextStyle(
                                                                      fontSize: 16
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ),
                                                        );
                                                      }
                                                    );
                                              }).toList(),
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                  )
                              ),
                            ],
                          )
                        ],
                      )
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }


  _handleEdit() {
    print('_handleEdit');
    setState(() {
      editable = !this.editable;
      btnTitle = this.editable ? '完成' : '编辑';
    });
  }

   _handleMove(DragUpdateDetails e) {
    setState(() {
      moveY += e.delta.dy;
      isTouchMove = true;   
    });
  }

  _tapClose(Function callback) {
    _controller.reverse();
    callback();
  }

  _tapCanel(Function callback) {
    print('_tapCanel$moveY');
    if(moveY > 250) {
      _controller.reset();
      setState(() {
        moveY = 80;
        isTouchMove = false;
        editable = false;
        btnTitle = '编辑';
      });
      callback();
    } else {
      setState(() {
        moveY = 80;
        isTouchMove = false;
      });
    }
  }

}