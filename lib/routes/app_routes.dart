import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/student/student_dashboard_screen.dart';
import '../screens/teacher/teacher_dashboard_screen.dart';
import '../screens/teacher/teacher_profile_setup_screen.dart';
// Student Screens
import '../screens/student/view_results_screen.dart';
import '../screens/student/progress_report_screen.dart';
import '../screens/student/rewards_screen.dart';
import '../screens/student/class_schedule_screen.dart';
import '../screens/student/materials_screen.dart';
import '../screens/student/home_screen.dart';
// Payment Screens
import '../screens/payment/student_payment_screen.dart';
import '../screens/payment/payment_history_screen.dart';
import '../screens/payment/invoice_view_screen.dart';
// Teacher Screens
import '../screens/teacher/schedule_exam_screen.dart';
import '../screens/teacher/upload_results_screen.dart';
import '../screens/teacher/upload_material_screen.dart';
import '../screens/teacher/payment_status_screen.dart';
// Admin Screens
import '../screens/admin/user_registration_screen.dart';
import '../screens/admin/create_class_screen.dart';
import '../screens/admin/schedule_manager_screen.dart';
import '../screens/admin/reports_screen.dart';
import '../screens/admin/invoice_generator_screen.dart';

class AppRoutes {
  // Auth Routes
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';

  // Dashboard Routes
  static const String adminDashboard = '/admin-dashboard';
  static const String studentDashboard = '/student-dashboard';
  static const String studentHome = '/student-home';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String teacherProfileSetup = '/teacher-profile-setup';

  // Student Routes
  static const String studentResults = '/student-results';
  static const String studentProgress = '/student-progress';
  static const String studentRewards = '/student-rewards';
  static const String studentSchedule = '/student-schedule';
  static const String studentMaterials = '/student-materials';

  // Payment Routes
  static const String studentPayments = '/student-payments';
  static const String paymentHistory = '/payment-history';
  static const String invoiceView = '/invoice-view';

  // Teacher Routes
  static const String scheduleExam = '/schedule-exam';
  static const String uploadResults = '/upload-results';
  static const String uploadMaterial = '/upload-material';
  static const String paymentStatus = '/payment-status';

  // Admin Routes
  static const String userRegistration = '/user-registration';
  static const String createClass = '/create-class';
  static const String scheduleManager = '/schedule-manager';
  static const String reports = '/reports';
  static const String invoiceGenerator = '/invoice-generator';

  static Map<String, WidgetBuilder> get routes {
    return {
      // Auth Routes
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),

      // Dashboard Routes
      adminDashboard: (context) => const AdminDashboardScreen(),
      studentDashboard: (context) => const StudentDashboardScreen(),
      studentHome: (context) => const HomeScreen(),
      teacherDashboard: (context) => const TeacherDashboardScreen(),
      teacherProfileSetup: (context) => const TeacherProfileSetupScreen(),

      // Student Routes
      studentResults: (context) => const ViewResultsScreen(),
      studentProgress: (context) => const ProgressReportScreen(),
      studentRewards: (context) => const RewardsScreen(),
      studentSchedule: (context) => const ClassScheduleScreen(),
      studentMaterials: (context) => const MaterialsScreen(),

      // Payment Routes
      studentPayments: (context) => const StudentPaymentScreen(),
      paymentHistory: (context) => const PaymentHistoryScreen(),
      invoiceView: (context) => const InvoiceViewScreen(),

      // Teacher Routes
      scheduleExam: (context) => const ScheduleExamScreen(),
      uploadResults: (context) => const UploadResultsScreen(),
      uploadMaterial: (context) => const UploadMaterialScreen(),
      paymentStatus: (context) => const PaymentStatusScreen(),

      // Admin Routes
      userRegistration: (context) => const UserRegistrationScreen(),
      createClass: (context) => const CreateClassScreen(),
      scheduleManager: (context) => const ScheduleManagerScreen(),
      reports: (context) => const ReportsScreen(),
      invoiceGenerator: (context) => const InvoiceGeneratorScreen(),
    };
  }
}
