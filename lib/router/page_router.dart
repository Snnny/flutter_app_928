import 'package:fluro/fluro.dart';
import 'package:flutter_app_928/router/page_routes.dart';

class PageRouter {
  static final router = Router();

  static setupRoutes() {
    pageRoutes.forEach((path, handler){
      router.define(path, handler: handler, transitionType: TransitionType.inFromRight);
    });
  }
}