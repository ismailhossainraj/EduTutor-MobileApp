import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.user != null) {
      // Navigate to appropriate dashboard based on user role
      switch (authProvider.user!.role) {
        case UserRole.admin:
          Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
          break;
        case UserRole.teacher:
          Navigator.pushReplacementNamed(context, AppRoutes.teacherDashboard);
          break;
        case UserRole.student:
          Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);
          break;
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 20),
            Text(
              'EduTutor',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
