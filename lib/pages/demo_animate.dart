import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app_928/widget/load_image.dart';

class DemoAnimate extends StatefulWidget {
  @override
  _DemoAnimateState createState() => _DemoAnimateState();
}

class _DemoAnimateState extends State<DemoAnimate> {

  Widget _switcher;
  bool isNormal = true;
  GlobalKey _buttonKey = GlobalKey();
  GlobalKey _buttonKey2 = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _switcher = getRender();
    });
    super.initState();
  }

  Widget getRender() {
    if(isNormal == true) {
      return Container(
        key: _buttonKey,
        width: 120,
        height: 120,
        color: Colors.blueAccent,
        child: FlatButton(
            onPressed: changeRender,
            child: Text('蓝色盒子')
        ),
      );
    } else {
      return Container(
        key: _buttonKey2,
        width: 120,
        height: 200,
        color: Colors.redAccent,
        child: FlatButton(
            onPressed:  changeRender,
            child: Text('红色盒子')
        ),
      );
    }
  }

  changeRender() {
    setState(() {
      isNormal = !isNormal;
      _switcher = getRender();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("动画演示"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ColorAnimate(),
            AnimationContainerDemo(),
            MultiAnimation(),
            SizedBox(height: 20,),
            RotateAnimation(),
            SizedBox(height: 20,),
            TransAnimation(),
//            TimeAnimation(),
            AnimatedSwitcher(
//              transitionBuilder: (child, anim){
//                return FadeTransition(child: opacity: anim.value);
//              },
              duration: Duration(milliseconds: 200),
              child: _switcher,
            ),
            AnimatedContainerDemo(),
            AnimatedFadeCrossDemo(),
//            TweennAnimationBuilderDemo(),
            SizedBox(height: 500,)
          ],
        ),
        ),
      ),
    );
  }
}


/// 颜色渐变
class ColorAnimate extends StatefulWidget {
  @override
  _ColorAnimateState createState() => _ColorAnimateState();
}

class _ColorAnimateState extends State<ColorAnimate> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<Color> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = ColorTween(begin: Colors.white, end: Colors.blueAccent).animate(controller)
    ..addListener((){
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  handleTap() {
    print('${animation.value}');
    controller.forward(from: 0).then((_) {
      Timer(Duration(milliseconds: 400),(){
        controller.reverse();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        color: animation.value
      ),
      child: FlatButton(
        onPressed: handleTap,
        child: Text('颜色渐变')
      ),
    );
  }
}

/// animationContainer的使用
class AnimationContainerDemo extends StatefulWidget {
  @override
  _AnimationContainerDemoState createState() => _AnimationContainerDemoState();
}

class _AnimationContainerDemoState extends State<AnimationContainerDemo> {

  Color color = Colors.white;
  double boxW = 100.0;

  changeColor() {
    setState(() {
      color = color == Colors.white ? Colors.purpleAccent : Colors.white;
      boxW = boxW == 100.0 ? 200.0 : 100.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: FlatButton(
        onPressed: changeColor,
        child: Text('AnimatedContainer')),
      width: boxW,
      height: 100,
      curve: Curves.easeInCirc,
      decoration: BoxDecoration(
        color: color
      ),
    );
  }
}


/// 多段动画
class MultiAnimation extends StatefulWidget {
  @override
  _MultiAnimationState createState() => _MultiAnimationState();
}

class _MultiAnimationState extends State<MultiAnimation> with TickerProviderStateMixin{
  Color startColor = Colors.grey[200];
  AnimationController controller1;
  AnimationController controller2;
  AnimationController controller3;
  Animation animation1;
  Animation animation2;
  Animation animation3;

  Animation curAnimation;

  Color curColor;


  @override
  void initState() {
    controller1 = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    controller2 = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    controller3 = AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    animation1 = Tween(begin: 1.0, end: 0.0).animate(controller1)
      ..addListener((){ // 必须写
        setState(() {
        });
      })
      ..addStatusListener((status){
      if(status == AnimationStatus.completed) {
        controller2.forward(from: 0);
        setState(() {
          curAnimation = animation2;
          curColor = Colors.redAccent;
        });
      }
    });
    animation2 = Tween(begin: 0.0, end: 1.2).animate(controller2)
      ..addListener((){
        setState(() {
        });
      })
      ..addStatusListener((status){
      if(status == AnimationStatus.completed) {
        controller3.forward(from: 0);
        setState(() {
          curAnimation = animation3;
        });
      }
    });
    animation3 = Tween(begin: 1.2, end: 1.0).animate(controller3)
      ..addListener((){
        setState(() {
        });
      })
      ..addStatusListener((status){
    });
    curAnimation = animation1;
    curColor = startColor;
    super.initState();
  }

  favorite() {
    controller1.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    print('${curAnimation.value}');
    return Container(
      color: Colors.grey[600],
      child: IconButton(
        icon: Icon(
          Icons.favorite,
          color: curColor,
          size: 30*curAnimation.value,
        ),
        onPressed: favorite
      ),
    );
  }
}

/// 旋转
class RotateAnimation extends StatefulWidget {
  @override
  _RotateAnimationState createState() => _RotateAnimationState();
}

class _RotateAnimationState extends State<RotateAnimation> with SingleTickerProviderStateMixin{

  Animation animation;
  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    return RotatedBox(
//      quarterTurns: 5,
//      child: Text('RotatedBox'),
//    );
    return RotationTransition(
      turns: animation,
      child: Container(
        height: 100,
        width: 100,
        color: Colors.blueAccent,
        child: FlatButton(
          onPressed: (){
            controller.forward(from: 0);
          },
          child: Text('点击旋转RotationTransition')
        ),
      ),
    );
  }
}


class TransAnimation extends StatefulWidget {
  @override
  _TransAnimationState createState() => _TransAnimationState();
}

class _TransAnimationState extends State<TransAnimation> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: .8,
      child: Container(
        height: 100,
        width: 100,
        color: Colors.blueAccent,
      ),
    );
  }
}

class TimeAnimation extends StatefulWidget {
  @override
  _ScaleAnimationState createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<TimeAnimation> with TickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation, sizeAnim;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 0.5, curve: Curves.ease)));
    sizeAnim = Tween<double>(
      begin: 100.0,
      end: 180.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));
    controller.forward(from: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Opacity(
            opacity: animation.value,
            child: FlutterLogo(size: sizeAnim.value)));
  }
}

class SwitchAnimation extends StatefulWidget {
  @override
  _SwitchAnimationState createState() => _SwitchAnimationState();
}

class _SwitchAnimationState extends State<SwitchAnimation> {
  bool isNormal = true;

  GlobalKey _buttonKey = GlobalKey();
  GlobalKey _buttonKey2 = GlobalKey();


  void changeType() {
    setState(() {
      isNormal = !isNormal;
    });
  }

  Widget getRender() {
    if(isNormal == true) {
      return Container(
        key: _buttonKey,
        width: 200,
        height: 120,
        color: Colors.blueAccent,
        child: FlatButton(
          onPressed: changeType,
          child: Text('蓝色盒子')
        ),
      );
    } else {
      return Container(
        key: _buttonKey2,
        width: 120,
        height: 200,
        color: Colors.redAccent,
        child: FlatButton(
          onPressed: changeType,
          child: Text('红色盒子')
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return getRender();
  }
}


class AnimatedContainerDemo extends StatefulWidget {
  @override
  _AnimatedContainerDemoState createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {

  bool _isBig = false;

  void changeSize() {
    setState(() {
      _isBig = !_isBig;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
//      width: _isBig ? 200 : 100,
//      height: _isBig ? 200 : 100,
      decoration: BoxDecoration(
//        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: _isBig ? Colors.grey[800]: Colors.grey[400],
        borderRadius:_isBig ?  BorderRadius.circular(20): BorderRadius.circular(10)
      ),
      duration: Duration(milliseconds: 300),
      child: FlatButton(onPressed: changeSize, child: Text('AnimatedContainer-demo')),
    );
  }
}

class TweennAnimationBuilderDemo extends StatefulWidget {
  @override
  _TweennAnimationBuilderDemoState createState() => _TweennAnimationBuilderDemoState();
}

class _TweennAnimationBuilderDemoState extends State<TweennAnimationBuilderDemo> {
  final _ColorTween = Tween<Color>(begin: Colors.white, end: Colors.greenAccent);

  double _sliderVal = 0;
  Color _newColor = Colors.redAccent;
  double _newPi =  2 * pi;

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    return Container(
      width: sw,
      height: sh,
      child: Stack(
        children: <Widget>[
          LoadAssetImage('sky',
            width: sw,
            height: sh,
            format: 'jpg', fit: BoxFit.cover,
          ),
          Center(
            // 旋转
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: _newPi),
              duration: Duration(seconds: 10),
//              curve: Curve,
              onEnd: (){
                print('end---');
                setState(() {
                  _newPi =  _newPi == 2*pi ? 0 : 2*pi;
                });
              },
              builder: (_, double angle, __){
                return Transform.rotate(
                  angle: angle,
                  child: LoadImage('earth', format: 'png',),
                );
              }
            ),
//            child: TweenAnimationBuilder(
//              tween: ColorTween(begin: Colors.white, end: _newColor),
//              duration: Duration(seconds: 2),
//              onEnd: (){
////               循环
//                setState(() {
//                  _newColor = _newColor == Colors.redAccent ? Colors.white : Colors.redAccent;
//                });
//              },
//              builder: (_, Color color, __) {
//                return ColorFiltered(
//                  colorFilter: ColorFilter.mode(color, BlendMode.modulate),
//                  child: LoadImage('earth', format: 'png',),
//                );
//              }
//            ),
          ),
          Slider.adaptive(
            value: _sliderVal,
            onChanged: (double newVal) {
              setState(() {
                _sliderVal = newVal;
                _newColor = Color.lerp(Colors.white, Colors.greenAccent, _sliderVal);

              });
            }
          )
        ],
      ),
    );
  }
}

class AnimatedFadeCrossDemo extends StatefulWidget {
  @override
  _AnimatedFadeCrossDemoState createState() => _AnimatedFadeCrossDemoState();
}

class _AnimatedFadeCrossDemoState extends State<AnimatedFadeCrossDemo> {

  bool showWelcome = true;

  void _skip() {
    setState(() {
      showWelcome = !showWelcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Column(
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            color: Colors.redAccent,
          ),
          GestureDetector(
            onTap: _skip,
            child:  Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20),
              height: 30,
              width: 300,
              color: Colors.greenAccent,
              child: Text('firstChild')
            ),
          ),
        ],
      ),
      secondChild: Column(
        children: <Widget>[
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: Colors.purpleAccent,
            ),
          ),
          GestureDetector(
            onTap: _skip,
            child:  Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 20),
                height: 30,
                width: 300,
                color: Colors.greenAccent,
                child: Text('secondChild')
            ),
          ),
        ],
      ),
      crossFadeState: showWelcome ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 300),
      firstCurve: Curves.easeOut,
      secondCurve: Curves.easeIn,
      layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey){
        return Stack(
          overflow: Overflow.visible,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(key: bottomChildKey,top: 0,child: bottomChild),
            Positioned(key: topChildKey,child: topChild)
          ],
        );
      },
    );
  }
}



