import 'package:flutter/material.dart';
import 'package:flutter_app_928/res/resources.dart';
import 'package:flutter_app_928/utils/utils.dart';
import 'package:flutter_app_928/widget/load_image.dart';
import 'package:flutter_app_928/widget/popup_window.dart';

/// 搜索栏

enum SearchBarType { home, normal }
class SearchBar extends StatefulWidget {
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar({
    Key key,
    this.searchBarType = SearchBarType.home,
    this.hint,
    this.defaultText,
    this.inputBoxClick,
    this.onChanged
  }):super(key: key);


  _SearchBarState createState()=> _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  bool showClear = false;
  final TextEditingController _controller = TextEditingController();
  GlobalKey _searchKey = GlobalKey();

  @override
  void initState() {
    if(widget.defaultText!=null) {
      _controller.text = widget.defaultText;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.home
    ? _genHomeSearchbar()
    : _genNormalSearchbar();
  }

  _genHomeSearchbar() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      color: Colors.redAccent,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _popButton(),
        ],
      ),
    );
  }

  _genNormalSearchbar() {
     return null;
  }

  _inputBox() {
    return Container(
      height: 35,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: Color(0xffa9a9a9),
          ),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
            ? TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onChanged,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.w300
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(5,0, 5, 0),
                border: InputBorder.none,
                hintText: widget.hint??'',
                hintStyle: TextStyle(fontSize: 15)
              ),
            )
            : _wrapTap(
              Text(
                widget.defaultText,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              )
              , widget.inputBoxClick),
          ),
          // showClear
          // ?_wrapTap(
          //   Icon(
          //     Icons.clear,
          //     size: 22,
          //     color: Colors.grey,
          //   )
          //   , (){
          //     setState(() {
          //       _controller.clear();            
          //     });
          //     _onChanged('');
          //   })
          // :null
        ],
      ),
    );
  }

  _popButton() {
    return Padding(
      key: _searchKey,
      padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
      child: GestureDetector(
        onTap: (){
          _showMenu(_searchKey);
        },
        child: Column(
          children: <Widget>[
            Icon(
              Icons.camera,
              size: 26,
              color: Colors.white,
            ),
            Text(
              '发布',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _popButtonItem(String title, IconData icon, bool last) {
    BorderSide borderSide = BorderSide(width: 0.5, color: Colors.black38);
    return Container(
      height: 30,
      decoration: BoxDecoration(
        // color: Colors.black45
        border: Border(bottom: last? BorderSide.none : borderSide)
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: Icon(icon, size: 14,),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }

  _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: (){
        if(callback!= null) {
          callback();
        }
      },
      child: child,
    );
  }

  _onChanged(String text) {
    if(text.length > 0) {
      setState(() {
        showClear = true;    
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  _showMenu(GlobalKey key){
    final RenderBox button = key.currentContext.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    /*
    * ancestor: 指定对象
    * 如果传的话，返回的是指定对象的位置，否则返回根节点的位置
    * */
    var a =  button.localToGlobal(Offset(button.size.width, button.size.height), ancestor: overlay);
    var b =  button.localToGlobal(button.size.bottomLeft(Offset(0, 12.0)), ancestor: overlay);
    var pos = button.localToGlobal(Offset(button.size.width, button.size.height));

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(a, b),
      Offset.zero & overlay.size,
    );
    final Color backgroundColor = MyUtils.getBackgroundColor(context);
    final Color _iconColor = MyUtils.getDarkColor(context, Colours.dark_text);
    final RelativeRect _mypos = RelativeRect.fromLTRB(pos.dx - 120.0, pos.dy, pos.dx - 120.0, pos.dy);
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

