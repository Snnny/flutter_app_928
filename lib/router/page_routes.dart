import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_app_928/pages/my_detail_page.dart';
import 'package:flutter_app_928/splash.dart';
import 'package:flutter_app_928/pages/demo_get_widget_position.dart';
import 'package:flutter_app_928/pages/demo_douyin.dart';
import 'package:flutter_app_928/pages/demo_animate.dart';
import 'package:flutter_app_928/pages/demo_form_submit.dart';
import 'package:flutter_app_928/pages/demo_fade_appbar.dart';
import 'package:flutter_app_928/pages/demo_sticky.dart';

enum PageName {
  my_detail_page,
  splash,
  demo_get_widget_position,
  demo_douyin,
  demo_animate,
  demo_form_submit,
  demo_fade_appbar,
  demo_sticky,
}

final Map<String, Handler> pageRoutes = {
  "/my_detail_page": Handler(handlerFunc: (BuildContext context, params){
    return MyDetailPage();
  }),
  "/splash": Handler(handlerFunc: (BuildContext context, params){
    return SplashPage();
  }),
  "/demo_get_widget_position": Handler(handlerFunc: (BuildContext context, params){
    return GetWidgetPosition();
  }),
  "/demo_douyin": Handler(handlerFunc: (BuildContext context, params){
    return DouYin();
  }),
  "/demo_animate": Handler(handlerFunc: (BuildContext context, params){
    return DemoAnimate();
  }),
  "/demo_form_submit": Handler(handlerFunc: (BuildContext context, params){
    return DemoFormSubmit();
  }),
  "/demo_fade_appbar": Handler(handlerFunc: (BuildContext context, params){
    return DemoFadeAppbar();
  }),
  "/demo_sticky": Handler(handlerFunc: (BuildContext context, params){
    return DemoSticky();
  }),
};