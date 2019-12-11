import 'package:flutter/material.dart';
import 'package:flutter_app_928/widget/app_bar.dart';

class DemoFormSubmit extends StatefulWidget {
  @override
  _DemoFormSubmitState createState() => _DemoFormSubmitState();
}

class _DemoFormSubmitState extends State<DemoFormSubmit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: '表单',
      ),
      body: MainBody(),
    );
  }
}

class MainBody extends StatefulWidget {
  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  TextEditingController _nameController, _pwController, _controller1;
  FocusNode _nameFocusNode, _pwFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _pwController = TextEditingController();
    _controller1 = TextEditingController();
    _nameFocusNode = FocusNode();
    _pwFocusNode = FocusNode();
  }

  Future<bool> _hanldeBack(){
    return showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        title: Text('确定退出此页面?'),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _hanldeBack,
        child: Container(
            color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 80.0),
            child: ListView(
              children: <Widget>[
                Center(
                  child: Text(
                    '登录',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                SizedBox(
                  height: 230.0,
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.account_balance,
                        ),
                        prefixStyle: TextStyle(color: Colors.grey),
                        hintText: '用户名、手机或者邮箱',
                        border: InputBorder.none, // 去掉下边框
                      ),
                      focusNode: _nameFocusNode,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (input) {
                        _nameFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_pwFocusNode);
                      },
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _pwController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
//                  prefixText: '密码',
                        hintText: '密码',
                        hintStyle: TextStyle(textBaseline: TextBaseline.alphabetic),
                        border: InputBorder.none, // 去掉下边框
                      ),
                      focusNode: _pwFocusNode,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(textBaseline: TextBaseline.alphabetic),
                      onSubmitted: (input) {
                        _pwFocusNode.unfocus();
                      },
                    ),
                  ),
                ),
                Container(
                  child: Chip(
                    label: Text('标签'),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.grey.shade800,
                      child: Text('01'),
                    ),
                    onDeleted: () {},
                  ),
                ),
                Container(
                  child: ActionChip(
                      label: Text('ActionChip'),
                      onPressed: () {
                        setState(() {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
//                              behavior: SnackBarBehavior.floating,
//                              backgroundColor: Colors.greenAccent,
                              content: Text('底部消息提醒'),
                              action: SnackBarAction(
                                label: '确定',
                                onPressed: () {},
                              ),
                            ),
                          );
                        });
                      }),
                ),
              ],
            )));
  }
}
