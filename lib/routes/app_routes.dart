import 'package:flutter/material.dart';
import 'package:ukk_kantin/pages/siswa/cart_page.dart';
import 'package:ukk_kantin/pages/siswa/home_page_siswa.dart';
import 'package:ukk_kantin/pages/siswa/main_screen_siswa_page.dart';
import 'package:ukk_kantin/pages/stan/manage_product_page.dart';
import 'package:ukk_kantin/pages/stan/home_page_stan.dart';
import 'package:ukk_kantin/pages/stan/main_screen_page.dart';
import 'package:ukk_kantin/pages/stan/manage_discount_page.dart';
import 'package:ukk_kantin/pages/stan/order_list_page.dart';
import 'package:ukk_kantin/pages/stan/profil_page.dart';
import 'package:ukk_kantin/pages/userlogin/choice_page.dart';
import 'package:ukk_kantin/pages/userlogin/login_page.dart';
import 'package:ukk_kantin/pages/userlogin/register_page_siswa.dart';
import 'package:ukk_kantin/pages/userlogin/register_page_stan.dart';
import 'package:ukk_kantin/services/auth/auth_gate.dart';

class AppRoutes {
  // userlogin
  static const String choicePage = '/choice_page';
  static const String registerPageStan = '/register_stan';
  static const String registerPageSiswa = '/register_siswa';
  static const String loginPage = '/login';

  // siswa
  static const String homePageSiswa = '/home_customer';
  static const String mainScreenSiswaPage = '/screen_siswa';
  static const String orderPageSiswa = '/order_page_siswa';
  static const String cartPage = '/cart';

  // stan
  static const String homePageStan = '/home_stan';
  static const String orderListPage = '/order_list';
  static const String profilPage = '/profil';
  static const String mainScreenPage = '/screen_stan';
  static const String manageProductPage = '/add_product';
  static const String manageDiscountPage = '/manage_discount';

  // initial route
  static const String initialRoute = '/';

  static Map<String, WidgetBuilder> routes = {
    // userlogin
    choicePage: (context) => const ChoicePage(),
    registerPageStan: (context) => const RegisterPageStan(),
    registerPageSiswa: (context) => const RegisterPageSiswa(),
    loginPage: (context) => const LoginPage(),

    // stan
    homePageStan: (context) => const HomePageStan(),
    mainScreenPage: (context) => const MainScreenPage(),
    profilPage: (context) => const ProfilPage(),
    orderListPage: (context) => const OrderListPage(),
    manageProductPage: (context) => const ManageProductPage(),
    manageDiscountPage: (context) => const ManageDiscountPage(),

    // siswa
    homePageSiswa: (context) => const HomePageSiswa(),
    mainScreenSiswaPage: (context) => const MainScreenCustomerPage(),
    orderPageSiswa: (context) => const OrderListPage(),
    cartPage: (context) => const CartPage(),

    // initial route
    initialRoute: (context) => const AuthGate(),
  };
}
