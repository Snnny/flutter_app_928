import 'package:flutter/material.dart';

class DemoFadeAppbar extends StatefulWidget {
  @override
  _DemoFadeAppbarState createState() => _DemoFadeAppbarState();
}

const maxOffset = 100;

class _DemoFadeAppbarState extends State<DemoFadeAppbar> {

  double opacityValue = 0;

  void _onScrol(offset) {
    double alpha = offset / maxOffset;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      opacityValue = alpha;
    });
    print(offset);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: NotificationListener(
                child: ListView(
                  children: <Widget>[
                    Image.network(
                      'https://dpic.tiankong.com/r6/eb/QJ6154840181.jpg?x-oss-process=style/670ws',
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 800,
                      child: Text(
                        '渐变AppBar',
                        style: Theme.of(context).textTheme.display2,
                      ),
                    ),
                  ],
                )
            )
          ),
          Opacity(
            opacity: opacityValue,
            child: Container(
              height: 80,
              child: AppBar(
                title: Text('渐变ApBar'),
                centerTitle: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
