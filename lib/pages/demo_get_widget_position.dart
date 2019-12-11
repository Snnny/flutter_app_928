import 'package:flutter/material.dart';
import 'package:flutter_app_928/res/resources.dart';
import 'package:flutter_app_928/widget/app_bar.dart';
import 'package:flutter_app_928/widget/load_image.dart';
import 'package:flutter_app_928/widget/my_button.dart';
import 'package:flutter_app_928/utils/utils.dart';
import 'package:flutter_app_928/widget/popup_window.dart';

class GetWidgetPosition extends StatefulWidget {
  @override
  _GetWidgetPositionState createState() => _GetWidgetPositionState();
}

class _GetWidgetPositionState extends State<GetWidgetPosition> {

  GlobalKey _buttonKey = GlobalKey();
  GlobalKey _buttonKey2 = GlobalKey();
  GlobalKey _buttonKey3 = GlobalKey();
  String dx0 = '';
  String dy0 = '';
  String dx1 = '';
  String dy1 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: '获取widget位置',),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: MyButton(
              key: _buttonKey,
              onPressed: (){
                _showAddMenu(_buttonKey);
              },
              text: '测试按钮1',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: MyButton(
              key: _buttonKey2,
              onPressed: (){
                _showAddMenu(_buttonKey2);
              },
              text: '测试按钮2',
            ),
          ),
          Center(
            child: InkWell(
              key: _buttonKey3,
              onTap: (){
                _getPos(_buttonKey3);
              },
              child: Container(
                width: 50.0,
                height: 50.0,
                color: Colors.redAccent,
                alignment: Alignment.center,
                child: Text('按钮3'),
              ),
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                Text('左上角x坐标$dx0'),
                Text('左上角y坐标$dy0'),
                Text('右下角x坐标$dx1'),
                Text('右下角x坐标$dy1')
              ],
            ),
          )
        ],
      ),
    );
  }

  _getPos(GlobalKey key) {
    final RenderBox button = key.currentContext.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    var pos = button.localToGlobal(Offset(button.size.width, button.size.height));
    var pos2 = button.localToGlobal(Offset.zero);
    setState(() {
      dx0 = pos2.dx.toString();
      dy0 = pos2.dy.toString();
      dx1 = pos.dx.toString();
      dy1 = pos.dy.toString();
    });

  }

  /// design/4商品/index.html#artboard4
  _showAddMenu(GlobalKey key){
    // 携带key的元素
    final RenderBox button = key.currentContext.findRenderObject();
    // 携带key的元素的上下文(root node)
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    /*
    * ancestor: 指定对象
    * 如果传的话，返回的是指定对象的位置，否则返回根节点的位置
    * */
    var a =  button.localToGlobal(Offset(button.size.width, button.size.height), ancestor: overlay);
    var b =  button.localToGlobal(button.size.bottomLeft(Offset.zero), ancestor: overlay);
//    var pos = button.localToGlobal(Offset(button.size.width, button.size.height));
    /*
//    * RelativeRect.fromRect
    * left : 子widget距离父布局左边框的距离
    * top :  子widget的左边框距离父布局上边框的距离
    * right : 子widget的左边框距离父布局右边框的距离
    * bottom : 子 widget的左边框距离父布局下边框的距离
    * 【Rect.fromPoints(a, b)】子widget 即按钮区域
    * 【Offset.zero & overlay.size】父布局尺寸
    * */
    /*
    *
    * rect 矩形
    * Rect.fromLTRB(left,top, right, bottom) 分别对应矩形区域的左上角的X，Y,右下角的X，Y
    * Reat.fromPointers(Offset a, Offset b) 分别对应矩形区域的左上角左表 右下角坐标
    * */
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(a, b),
      Offset.zero & overlay.size,
    );
    final Color backgroundColor = MyUtils.getBackgroundColor(context);
    final Color _iconColor = MyUtils.getDarkColor(context, Colours.dark_text);
//    final RelativeRect _mypos = RelativeRect.fromLTRB(pos.dx - 120.0, pos.dy, pos.dx - 120.0, pos.dy);
    print('height:${overlay.size.height}');
    print('popup位置:$position');
    print('父布局尺寸：${Offset.zero & overlay.size}');
    print('子尺寸：${Rect.fromPoints(a, b)}');
    showPopupWindow(
      context: context,
      fullWidth: false,
      isShowBg: true,
      position: position,
//      position: _mypos,
      elevation: 0.0,
      child: GestureDetector(
        onTap: (){
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: LoadAssetImage("goods/jt", width: 8.0, height: 4.0,
                color: MyUtils.getDarkColor(context, Colours.dark_bg_color),
              ),
            ),
            SizedBox(
              width: 120.0,
              height: 40.0,
              child: FlatButton.icon(
                  textColor: Theme.of(context).textTheme.body1.color,
                  onPressed: (){
                  },
                  color: backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                  ),
                  icon: LoadAssetImage("goods/scanning", width: 16.0, height: 16.0, color: _iconColor,),
                  label: const Text("扫码添加")
              ),
            ),
            Container(width: 120.0, height: 0.6, color: Colours.line),
            SizedBox(
              width: 120.0,
              height: 40.0,
              child: FlatButton.icon(
                  textColor: Theme.of(context).textTheme.body1.color,
                  color: backgroundColor,
                  onPressed: (){
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                  ),
                  icon: LoadAssetImage("goods/add2", width: 16.0, height: 16.0, color: _iconColor,),
                  label: const Text("添加商品")
              ),
            ),
          ],
        ),
      ),
    );
  }

}
