import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_928/navigator/navigator.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  Timer _t;


  @override
  void initState() {
    super.initState();

    _t = Timer(const Duration(milliseconds: 1500),(){
      print('Timer-----');
      try{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context)=> TabNavigator()),
           (Route route)=> route == null);
      } catch(e) {
        print('Timer-----$e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 200.0),
              child: Image.network('https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1145362227,423865339&fm=26&gp=0.jpg'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 100.0),
              child: Text(
                '今日头条',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
