import 'package:smart_home/views/auth.dart';
import 'package:smart_home/views/home.dart';
import 'package:smart_home/views/setting.dart';

class PageNames {
  static const auth = "/";
  static const home = "/home";
  static const setting = "/setting";
}

dynamic getPages(context) {
  return {
    PageNames.auth: (context) => const Auth(),
    PageNames.home: (context) => const Home(),
    PageNames.setting: (context) => const Setting(),
  };
}
