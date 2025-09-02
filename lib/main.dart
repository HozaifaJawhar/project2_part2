import 'package:ammerha_management/config/routes/app_routes.dart';
import 'package:ammerha_management/config/routes/route_generator.dart';
import 'package:ammerha_management/core/provider/Department_Provider.dart';
import 'package:ammerha_management/core/provider/auth_provider.dart';
import 'package:ammerha_management/screens/auth_screens/login.dart';

import 'config/theme/app_theme.dart';
import 'screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.loadToken();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DepartmentProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: LoginScreen(),
      initialRoute: AppRoutes.loginRoute,
      // Handles all named route generation via the RouteGenerator class.
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
