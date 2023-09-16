import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:parkit/Screens/home.dart';
import 'package:parkit/Screens/signin_screen.dart';
import 'package:parkit/Screens/signup_screen.dart';

import 'Screens/splash_screen.dart';
final routes =[
  GetPage(
    name: '/',
    page: () => const SplashScreen(),
  ),
  GetPage(
    name:'/home',
    page: ()=> HomeScreen(),
  ),
  GetPage(name: '/login', page:()=> SignIn()),
  GetPage(name: '/signup', page: ()=>SignupScreen())
];