// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_app/providers/auth_provider.dart';
import 'package:taskflow_app/providers/company_provider.dart';
import 'package:taskflow_app/providers/dashboard_provider.dart';
import 'package:taskflow_app/providers/report_provider.dart';
import 'package:taskflow_app/providers/task_provider.dart';
import 'package:taskflow_app/providers/user_provider.dart';
import 'package:taskflow_app/screens/auth/login_screen.dart';
import 'package:taskflow_app/screens/dashboard/dashboard_screen.dart';
import 'package:taskflow_app/splash_screens/splash.dart';
import 'package:taskflow_app/theme/app_theme.dart';
import 'package:taskflow_app/utils/routes.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      themeMode: ThemeMode.light,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return authProvider.isAuthenticated
              ? const Splashscreen()
              : const LoginScreen();
        },
      ),
    );
  }
}