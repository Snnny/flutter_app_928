import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_928/res/resources.dart';
import 'package:flutter_app_928/router/fluro_navigator.dart';
import 'package:flutter_app_928/utils/toast.dart';
import 'package:flutter_app_928/utils/utils.dart';
import 'package:flutter_app_928/widget/click_item.dart';
import 'package:flutter_app_928/widget/load_image.dart';
import 'package:flutter_app_928/widget/my_button.dart';
import 'package:flutter_app_928/widget/app_bar.dart';
import 'package:flutter_app_928/widget/my_card.dart';
import 'package:flutter_app_928/widget/popup_window.dart';
import 'package:flutter_app_928/widget/selected_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app_928/widget/selected_text.dart';
import 'package:flutter_app_928/utils/image_utils.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MelonVideoPage extends StatefulWidget {
  @override
  _MelonVideoPageState createState() => _MelonVideoPageState(); 

}

class _MelonVideoPageState extends State<MelonVideoPage> {

  File _imageFile;
  bool _check = false;
  var _selectValue = [0];
  int _sendType = 0;
  String _sendPrice = "0.00";
  String _freePrice = "0.00";
  String _phone = "";
  String _shopIntroduction = "零食铺子坚果饮料美酒佳肴…";
  String _securityService = "假一赔十";
  String _address = "陕西省 西安市 长安区 郭杜镇郭北村韩林路圣方医院斜对面";
  GlobalKey _hintKey = GlobalKey();
  PanelController panel = PanelController();
  double offsetDistance = 0.0;
  double offsetY=0;



  @override
  void initState() {
    // TODO: implement initState
    // 获取Build完成状态监听
//    var widgetsBinding = WidgetsBinding.instance;
//    widgetsBinding.addPostFrameCallback((callback){
//      _showPop();
//    });
    super.initState();
  }


  void _getImage() async{
    try {
      _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 95);
      setState(() {});
    } catch (e) {
      Toast.show("没有权限，无法打开相册！");
    }
  }

  @override
  Widget build(BuildContext context) {

//    return Scaffold(
//      appBar: AppBar(
//        title: Text("SlidingUpPanelExample"),
//      ),
//      body: SlidingUpPanel(
//        minHeight: 0,
//        controller: panel,
//        borderRadius: BorderRadius.only(
//          topLeft: Radius.circular(24.0),
//          topRight: Radius.circular(24.0)
//        ),
//        panel: Center(
//          child: Text("这里是抽屉区"),
//        ),
//        body: GestureDetector(
//          onVerticalDragDown: (details){
//            offsetDistance=details.globalPosition.dy;
//          },
//          onVerticalDragUpdate: (details){
//            print('onVerticalDragUpdate');
//            offsetY=details.globalPosition.dy-offsetDistance;
//            if(offsetY>0){
//              print("向下"+offsetY.toString());
//            }else{
//              print("向上"+offsetY.toString());
//              double position=offsetY.abs()/300;
//              position=position>1?1:position;
//              panel.setPanelPosition(position);
//              if(position>0.4){
//                panel.open();
//              }
//            }
//          },
//          child: ConstrainedBox(
//            constraints: BoxConstraints.expand(),
//            child: Text("这么是页面区"),
//          ),
//        )
//      ),
//    );
//  }

    return Scaffold(
      // 防止键盘弹出，提交按钮升起。。。
      resizeToAvoidBottomInset: false,
      appBar: const MyAppBar(title: '测试页面',),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, 'demo_get_widget_position');
              },
              child: Text('获取widget位置'),
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, 'demo_douyin');
              },
              child: Text('抖音交互'),
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, 'demo_animate');
              },
              child: Text('动画效果'),
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, 'demo_form_submit');
              },
              child: Text('表单提交'),
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, 'demo_fade_appbar');
              },
              child: Text('渐隐渐现appbar'),
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, 'demo_sticky');
              },
              child: Text('吸顶'),
            ),

          ],
        ),
      )
    );

  }

}
