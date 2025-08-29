import 'package:ammerha_management/config/routes/app_routes.dart';
import 'package:ammerha_management/screens/auth_screens/login.dart';
import 'package:ammerha_management/screens/home_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Arguments can be passed to a route using `settings.arguments`.
    // final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());

      default:
        // If the route name is not found, navigate to an error screen.
        return _errorRoute();
    }
  }

  /// Returns a statically defined error route widget.
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error'), centerTitle: true),
          body: const Center(child: Text('Page Not Found')),
        );
      },
    );
  }
}
