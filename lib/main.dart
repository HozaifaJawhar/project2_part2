import 'package:ammerha_management/config/routes/app_routes.dart';
import 'package:ammerha_management/config/routes/route_generator.dart';
import 'package:ammerha_management/core/helper/api.dart';
import 'package:ammerha_management/core/provider/%20events%20management/events_provider.dart';
import 'package:ammerha_management/core/provider/Department_Provider.dart';
import 'package:ammerha_management/core/provider/auth_provider.dart';
import 'package:ammerha_management/core/services/events_service.dart';
import 'config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DepartmentProvider()),
        ChangeNotifierProvider(
          create: (_) => EventsProvider(EventsService(Api())),
        ),
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
      // home: LoginScreen(),
      initialRoute: AppRoutes.splashRoute,
      // Handles all named route generation via the RouteGenerator class.
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
