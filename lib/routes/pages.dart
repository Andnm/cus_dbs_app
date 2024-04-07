import 'package:cus_dbs_app/middlewares/router_auth.dart';
import 'package:cus_dbs_app/pages/auth/customer/otp_confirm/otp_customer_binding.dart';
import 'package:cus_dbs_app/pages/auth/customer/otp_confirm/otp_customer_view.dart';
import 'package:cus_dbs_app/pages/auth/customer/register/index.dart';
import 'package:cus_dbs_app/pages/auth/customer/signin/sigin_customer_binding.dart';
import 'package:cus_dbs_app/pages/auth/customer/signin/sigin_customer_view.dart';
import 'package:cus_dbs_app/pages/auth/driver/signin/signin_driver_binding.dart';
import 'package:cus_dbs_app/pages/auth/driver/signin/signin_driver_view.dart';
import 'package:cus_dbs_app/pages/choose_role/choose_role_binding.dart';
import 'package:cus_dbs_app/pages/choose_role/choose_role_view.dart';
import 'package:cus_dbs_app/pages/main/account/customer/customer_profile_view.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_identity_card/customer_update_identity_view.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_identity_card/customer_update_identity_binding.dart';
import 'package:cus_dbs_app/pages/main/account/customer/update_profile/index.dart';
import 'package:cus_dbs_app/pages/main/main_binding.dart';
import 'package:cus_dbs_app/pages/main/main_view.dart';
import 'package:cus_dbs_app/pages/welcome/welcome_binding.dart';
import 'package:cus_dbs_app/pages/welcome/welcome_view.dart';
import 'package:cus_dbs_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/auth/driver/register/register_driver_binding.dart';
import '../pages/auth/driver/register/register_driver_view.dart';
import '../pages/main/home/customer/home_customer_binding.dart';
import '../pages/main/home/customer/home_customer_view.dart';
import '../pages/main/home/driver/home_driver_binding.dart';
import '../pages/main/home/driver/home_driver_view.dart';

class AppPages {
  static final RouteObserver<Route> observer = RouteObserver();
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
        name: AppRoutes.initial,
        page: () => const WelcomePage(),
        binding: WelcomeBinding()),
    GetPage(
        name: AppRoutes.chooseRole,
        page: () => const ChooseRole(),
        binding: ChooseRoleBinding()),
    GetPage(
      name: AppRoutes.customerSignIn,
      page: () => const CustomerSignInPage(),
      binding: CustomerSignInBinding(),
    ),
    GetPage(
      name: AppRoutes.customerRegister,
      page: () => const CustomerRegisterPage(),
      binding: CustomerRegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.viewCustomerProfile,
      page: () => const CustomerProfileView(),
    ),
    GetPage(
      name: AppRoutes.updateCustomerProfile,
      page: () => CustomerUpdateProfilePage(),
      binding: CustomerUpdateProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.updateCustomerIdentityCard,
      page: () => CustomerUpdateIdentityPage(),
      binding: CustomerUpdateIdentityBinding(),
    ),
    GetPage(
      name: AppRoutes.customerHome,
      page: () => const CustomerHomePage(),
      binding: CustomerHomeBinding(),
    ),

    GetPage(
      name: AppRoutes.driverSignIn,
      page: () => const DriverSignInPage(),
      binding: DriverSignInBinding(),
    ),
    GetPage(
      name: AppRoutes.driverRegister,
      page: () => const DriverRegisterPage(),
      binding: DriverRegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.driverHome,
      page: () => const DriverHomePage(),
      binding: DriverHomeBinding(),
    ),
    GetPage(
      name: AppRoutes.otpConfirm,
      page: () => const OtpConfirmPage(),
      binding: OtpConfirmBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.map,
    //   page: () => const MapPage(),
    //   binding: MapBinding(),
    // ),
    GetPage(
        name: AppRoutes.main,
        page: () => const MainPage(),
        binding: MainBinding(),
        middlewares: [RouteAuthMiddleware(priority: 1)]),
  ];
}
