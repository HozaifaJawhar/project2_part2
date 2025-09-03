import 'dart:async';
import 'package:ammerha_management/config/routes/app_routes.dart';
import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Provides the Ticker to drive the animation controller.
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller and animation for the fade effect.
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a duration.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Create a curved animation for a smooth ease-in effect.
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Start the animation.
    _animationController.forward();

    // Initialize app data and authentication state.
    _initializeApp();
  }

  @override
  void dispose() {
    // Dispose the controller to prevent memory leaks.
    _animationController.dispose();
    super.dispose();
  }

  // Checks for a saved token and navigates to the appropriate screen.
  Future<void> _initializeApp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authCheckFuture = authProvider.tryAutoLogin();

    final delayFuture = Future.delayed(const Duration(seconds: 3));
    await Future.wait([authCheckFuture, delayFuture]);

    // Navigate after async operations are complete, ensuring the widget is still mounted.
    if (mounted) {
      if (authProvider.token != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.homePage);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Apply the fade animation to the logo widget.
              FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/logos/logo2.png',
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
