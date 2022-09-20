import 'package:get/get.dart';
import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/screens/login.dart';
import 'package:user_app/screens/register.dart';

appRoutes() => [
      GetPage(
        name: '/home',
        page: () => HomeScreen(),
        // transition: Transition.leftToRightWithFade,
        // transitionDuration: Duration(milliseconds: 500),
      ),
      GetPage(
        name: '/login',
        page: () => const LoginScreen(),
      ),
      GetPage(
        name: '/signup',
        page: () => const SignUpScreen(),
      ),
    ];
