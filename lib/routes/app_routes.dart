import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/student/student_dashboard.dart';
import '../screens/teacher/teacher_dashboard.dart';
import '../screens/teacher/teacher_profile_screen.dart';
import '../screens/payment/payment_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String adminDashboard = '/admin-dashboard';
  static const String studentDashboard = '/student-dashboard';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String payment = '/payment';
  static const String teacherProfile = '/teacher-profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      adminDashboard: (context) => const AdminDashboard(),
      studentDashboard: (context) => const StudentDashboard(),
      teacherDashboard: (context) => const TeacherDashboard(),
      payment: (context) => const PaymentScreen(),
      teacherProfile: (context) => const TeacherProfileScreen(),
    };
  }
}
