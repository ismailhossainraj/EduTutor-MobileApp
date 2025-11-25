import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/student/student_dashboard_screen.dart';
import '../screens/teacher/teacher_dashboard_screen.dart';
import '../screens/teacher/teacher_profile_setup_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String adminDashboard = '/admin-dashboard';
  static const String studentDashboard = '/student-dashboard';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String teacherProfileSetup = '/teacher-profile-setup';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      adminDashboard: (context) => const AdminDashboardScreen(),
      studentDashboard: (context) => const StudentDashboardScreen(),
      teacherDashboard: (context) => const TeacherDashboardScreen(),
      teacherProfileSetup: (context) => const TeacherProfileSetupScreen(),
    };
  }
}
