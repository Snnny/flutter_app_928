import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app_928/widget/click_item.dart';
import 'package:flutter_app_928/widget/app_bar.dart';

class MyDetailPage extends StatefulWidget {
  @override
  _MyDetailPageState createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<MyDetailPage> {

  UserInfo _userInfo = UserInfo(avatar: null, username: 'Snnny', introduction: null);

  TextEditingController _nameController = TextEditingController(text: 'Snnny');
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: '个人详情',
      ),
      body: Container(
//        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
//        color: Colors.white,
        child: Column(
          children: <Widget>[
            ClickItem(
              title: "头像",
              content:  _userInfo.avatar ?? '上传头像',
              onTap: getImage,
            ),
            ClickItem(
              title: "用户名",
              content: 'Snnny',
              onTap: motifyNickname,
            ),
          ],
        )
      ),
    );
  }

  // handle avatar
  Future getImage() async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text("相册"),
                onTap: () async {
                  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                  if(image!= null) { // 上传头像
                    Navigator.of(context).pop();
                    setState(() {
                      String serveImg = 'https://github.com/simplezhli/flutter_deer/raw/master/preview/logo.jpg';
                      _userInfo = UserInfo(avatar: serveImg, username: 'Snnny', introduction: null);
                    });
                  }
                },
              ),
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text("照相机"),
                onTap: () async {
                  var image = await ImagePicker.pickImage(source: ImageSource.camera);
                  if(image!= null) {
                    Navigator.of(context).pop();
                    setState(() {
                      _userInfo = UserInfo(avatar: image, username: 'Snnny', introduction: null);
                    });
                  }
                },
              ),
              new ListTile(
                title: Center(
                  child: Text('取消'),
                ),
                onTap: () async{
                  //  关闭弹层
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget _listItem(String label, dynamic content, String type, bool isLast, [Function callback]) {
    BorderSide borderSide = BorderSide(width: .5, color: Colors.black12);
    return GestureDetector(
      onTap: (){
        if(callback!=null) {
          callback();
        }
      },
      child: Container(
        height: 40.0,
        padding: EdgeInsets.fromLTRB(10, 4, 6, 4),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: isLast ? BorderSide.none : borderSide)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(label),
            Row(
              children: <Widget>[
                _listItemRight(content, type),
                Padding(
                  padding: EdgeInsets.only(left: 1),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black38,
                    size: 22,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _listItemRight(dynamic content, String type) {
    // 判断content是否是图片路径 还是本地文件    
    bool isRemote = content is String;
    return type == 'text'
        ? Text(
            content,
          style: TextStyle(color: Colors.black38),
        )
        : content == null
          ? Text('上传头像', style: TextStyle(color: Colors.black38),)
          : isRemote
            ? CircleAvatar(backgroundImage: NetworkImage(content), radius: 15.0,)
            : CircleAvatar(backgroundImage: FileImage(content), radius: 15.0,);
  }


  void motifyNickname() {
//    _focusNode.addListener((){
//      if(!_focusNode.hasFocus) {
//        Navigator.of(context).pop();
//      }
//    });
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        print('MediaQuery.of(context).viewInsets${MediaQuery.of(context).viewInsets}');
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: 150.0,
            color: Colors.black12,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(2.0))
                  ),
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    onChanged: _nameInput,
                    onSubmitted: (String value){
                      setState(() {
                        _userInfo = UserInfo(avatar: _userInfo.avatar, username: value, introduction: _userInfo.introduction);
                      });
                      Navigator.of(context).pop();
                    },
                    autofocus: true,
                    maxLength: 15,
                    maxLines: 2,
                    decoration: InputDecoration(
                        border: InputBorder.none,
//                        contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        '支持英文、数字'
                    ),
                    InkWell(
                      onTap: (){},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: InkWell(
                          onTap: (){
                            print('confirm~');
                            setState(() {
                              _userInfo = UserInfo(avatar: _userInfo.avatar, username: _nameController.text, introduction: _userInfo.introduction);
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('确定', style: TextStyle(color: Colors.white),
                        ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }

  _nameInput(String value) {
    print('_nameInput$value');
  }

}



class UserInfo {
  final dynamic avatar;
  final String username;
  final String introduction;

  UserInfo({this.avatar, this.username, this.introduction});
}


