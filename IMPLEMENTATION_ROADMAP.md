# EduTutor Implementation Guide - Complete Roadmap

## 📋 Project Status Summary

**Date:** November 27, 2025  
**Status:** ✅ Complete Architecture Implemented  
**Phase:** Foundation & Routing Setup Complete

---

## ✅ What's Been Completed

### 1. Architecture Foundation
- ✅ **System Architecture Document** (SYSTEM_ARCHITECTURE.md)
  - Complete use case analysis with «include» and «extend» relationships
  - Database schema design
  - User role definitions
  - Navigation flow diagrams

### 2. Data Models Created
- ✅ **Payment Model** (`lib/models/payment_model.dart`)
  - studentId, amount, paymentDate, status, paymentMethod
  - transactionId, createdAt, notes, receiptUrl
  - Methods: toMap(), fromMap(), copyWith()

- ✅ **Invoice Model** (`lib/models/invoice_model.dart`)
  - studentId, invoiceNumber, generatedDate, dueDate
  - monthlyFee, totalDue, amountPaid, balanceDue
  - Methods: isOverdue(), calculatePenalty()

- ✅ **Exam Model** (`lib/models/exam_model.dart`)
  - classId, teacherId, subject, scheduledDate, endTime
  - examType, status, totalQuestions, totalMarks
  - Methods: isUpcoming(), isOngoing(), getDurationInMinutes()

- ✅ **Result Model** (`lib/models/result_model.dart`)
  - studentId, examId, marksObtained, totalMarks, grade
  - remarks, resultDate, examType, isPublished
  - Methods: getPercentage(), getGradeColor()

- ✅ **Course Material Model** (`lib/models/material_model.dart`)
  - classId, teacherId, title, description, fileType
  - fileUrl, downloadUrl, uploadedAt, status
  - Methods: getFileIcon(), isAccessibleToStudent()

- ✅ **Class Schedule Model** (`lib/models/schedule_model.dart`)
  - classId, subject, teacherName, startTime, endTime
  - roomNumber, dayOfWeek, batchName, status
  - Methods: getFormattedTime(), getDurationInMinutes(), isOngoing()

- ✅ **Class Model** (`lib/models/class_model.dart`)
  - className, subject, capacity, level, academicYear
  - studentIds, teacherIds, status
  - Methods: hasCapacity(), getAvailableSeats(), getEnrollmentPercentage()

- ✅ **Reward Model** (`lib/models/reward_model.dart`)
  - Reward class: studentId, type, title, pointsEarned, earnedAt
  - ProgressReport class: overallScore, performanceLevel, subjectScores
  - Methods: getRewardEmoji(), getCategoryColor(), getPerformanceColor()

### 3. Routing System
- ✅ **Updated App Routes** (`lib/routes/app_routes.dart`)
  - All 35+ routes defined and imported
  - Complete navigation path for all modules
  - Proper route constants with meaningful names

### 4. Screen Placeholders Created (Ready for Implementation)
- ✅ **Student Screens** (5 screens)
  - ViewResultsScreen
  - ProgressReportScreen
  - RewardsScreen
  - ClassScheduleScreen
  - MaterialsScreen

- ✅ **Payment Screens** (3 screens)
  - StudentPaymentScreen
  - PaymentHistoryScreen
  - InvoiceViewScreen

- ✅ **Teacher Screens** (4 screens)
  - ScheduleExamScreen
  - UploadResultsScreen
  - UploadMaterialScreen
  - PaymentStatusScreen

- ✅ **Admin Screens** (5 screens)
  - UserRegistrationScreen
  - CreateClassScreen
  - ScheduleManagerScreen
  - ReportsScreen
  - InvoiceGeneratorScreen

### 5. Updated Existing Files
- ✅ **Payment Model** - Expanded from basic to comprehensive payment tracking
- ✅ **Payment Management Screen** - Updated to use new Payment model structure

---

## 🔄 Next Implementation Phases

### Phase 1: Student Module - Payment System (PRIORITY)
**Timeline:** 1-2 weeks

#### 1.1 StudentPaymentScreen
```
Features:
- Display student fee invoices
- Show payment status (Paid/Pending/Overdue)
- Select payment method (Card, Bank Transfer, Wallet)
- Payment gateway integration (Stripe/PayPal)
- Display transaction history

UI Components:
- Invoice Card Widget
- Payment Method Selection
- Payment History List
- Payment Processing Dialog
- Receipt Display
```

**Implementation:**
```dart
class StudentPaymentScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payments')),
      body: Column(
        children: [
          // Outstanding Invoices Section
          InvoiceCardsSection(),
          
          // Payment Methods Section
          PaymentMethodSelector(),
          
          // Recent Transactions Section
          RecentTransactionsList(),
          
          // Pay Button
          CustomButton(onPressed: () => _initiatePayment()),
        ],
      ),
    );
  }
}
```

#### 1.2 PaymentHistoryScreen
```
Features:
- Complete payment transaction history
- Filter by date range
- Search by transaction ID
- View payment receipts
- Download invoices as PDF
- Retry failed payments

Display:
- Transaction list with dates
- Payment method used
- Transaction ID
- Status badges
- Amount with currency
```

#### 1.3 InvoiceViewScreen
```
Features:
- Detailed invoice view
- Monthly fee breakdown
- Due date and penalties
- Payment status timeline
- Download as PDF
- Share invoice
- Mark as paid (admin override)

Invoice Template Shows:
- Student Name & ID
- Invoice Number & Date
- Fee Items (Monthly, Exam, Other)
- Total Amount Due
- Payment Terms
- Due Date
- Bank Details / Payment Instructions
```

**Payment Service Methods:**
```dart
class PaymentService {
  // Get all invoices for student
  Future<List<Invoice>> getStudentInvoices(String studentId)
  
  // Get payment history
  Future<List<Payment>> getPaymentHistory(String studentId)
  
  // Create payment
  Future<bool> createPayment(Payment payment)
  
  // Process payment via gateway
  Future<PaymentResult> processPayment(String invoiceId, String methodId)
  
  // Get invoice details
  Future<Invoice> getInvoiceDetails(String invoiceId)
  
  // Download invoice as PDF
  Future<String> downloadInvoicePDF(String invoiceId)
  
  // Send payment receipt via email
  Future<bool> sendPaymentReceipt(String paymentId, String email)
}
```

**Payment Provider Methods:**
```dart
class PaymentProvider extends ChangeNotifier {
  List<Invoice> invoices = [];
  List<Payment> paymentHistory = [];
  Invoice? selectedInvoice;
  bool isLoading = false;
  String? errorMessage;
  
  Future<void> loadInvoices(String studentId)
  Future<void> loadPaymentHistory(String studentId)
  Future<bool> makePayment(String invoiceId, String paymentMethod)
  Future<void> refreshData(String studentId)
}
```

---

### Phase 2: Student Module - Academic Features

#### 2.1 ViewResultsScreen
```
Features:
- List all exam results
- Display marks, grade, and remarks
- Filter by exam type or subject
- Trend analysis over time
- Download result as PDF
- View previous years results

Display:
- Result cards with:
  - Exam name
  - Subject
  - Marks obtained / Total marks
  - Grade (A, B, C, D, F)
  - Teacher remarks
  - Date of result
```

#### 2.2 ProgressReportScreen + RewardsScreen
```
ProgressReport Features:
- Overall performance score
- Performance level (Excellent/Good/Average/Needs Improvement)
- Pass rate percentage
- Subject-wise scores (Chart)
- Test statistics
- Trend visualization

Reward System:
- Points earned
- Badges awarded
- Performance level achievements
- Share achievements on feed

Reward Types:
1. Points-based:
   - Test completion: 10 points
   - Perfect score: 50 points
   - Streak bonus: 5 points/day
   
2. Badges:
   - First Perfect Score
   - Test Master (10 tests passed)
   - Consistency Champion
   - Top Performer
   
3. Performance Levels:
   - Excellent (≥90%)
   - Good (80-89%)
   - Average (70-79%)
   - Needs Improvement (<70%)
```

#### 2.3 ClassScheduleScreen
```
Features:
- Weekly calendar view
- Upcoming classes list
- Class details (time, teacher, room, subject)
- Set reminders for upcoming classes
- Mark attendance
- View past class recordings

Display Options:
1. Calendar View:
   - Day view showing all classes
   - Week view
   - Month view

2. List View:
   - Upcoming classes (next 7 days)
   - Past classes
   - Detailed class info card

3. Class Card Shows:
   - Class name/subject
   - Teacher name
   - Date & time
   - Duration
   - Room/Batch number
   - Status (scheduled/ongoing/completed)
```

#### 2.4 MaterialsScreen
```
Features:
- View all uploaded course materials
- Filter by type (PDF, Video, Notes, Links)
- Search materials
- Favorite/bookmark materials
- Download files
- Stream videos
- Sort by date uploaded

Material Card Shows:
- File icon based on type
- Title
- Description
- Date uploaded
- File size
- Download button
- View/Preview button
```

---

### Phase 3: Teacher Module

#### 3.1 ScheduleExamScreen
```
Features:
- Create new exams
- Set exam details (name, subject, date, time, marks)
- Define question count
- Add exam instructions
- Assign to specific classes
- Set exam type (midterm, final, unit test, quiz)
- Save draft or publish immediately
- View scheduled exams
- Edit/Cancel exams

Form Fields:
- Exam Name
- Subject
- Exam Type (dropdown)
- Total Marks
- Number of Questions
- Scheduled Date & Time
- End Time (auto-calculated)
- Instructions/Description
- Classes to Assign (multi-select)
```

#### 3.2 UploadResultsScreen
```
Features:
- Three input methods:
  1. Manual entry (form for each student)
  2. Bulk CSV upload
  3. Import from assessment platform

Manual Entry:
- Student dropdown/search
- Enter marks
- Add remarks
- Save individually
- Publish after all entries

CSV Upload:
- Download template
- File upload
- Preview before submission
- Validation checks
- Bulk save

Publishing:
- Notify students
- Set visibility date
- Add general remarks
```

#### 3.3 UploadMaterialScreen
```
Features:
- Upload multiple file types (PDF, Video, Images, Links)
- Add title and description
- Set access level:
  - All students in class
  - Specific batch
  - Individual students
- Schedule publication date
- Organize by unit/chapter
- Drag-and-drop upload
- File validation (size, format)

File Upload Form:
- File picker
- Title input
- Description textarea
- Access level selector
- Publication date picker
- Unit/Chapter dropdown
- Upload progress indicator
```

#### 3.4 PaymentStatusScreen
```
Features:
- View all assigned student payment status
- Filter by payment status
- Search by student name/ID
- Bulk update status
- Add notes/comments
- Generate payment report
- Send payment reminders

Display:
- Student list with:
  - Student Name & ID
  - Class
  - Outstanding amount
  - Due date
  - Last payment date
  - Payment status badge
```

---

### Phase 4: Admin Module

#### 4.1 UserRegistrationScreen
```
Features:
- Create student/teacher accounts
- Bulk import via CSV
- Set role and permissions
- Assign to class (students)
- Assign subjects (teachers)
- Auto-generate credentials
- Send login details via email
- Account status management

Creation Methods:
1. Single User:
   - Form with all details
   - Role selection
   - Auto-generate password
   - Send email

2. Bulk Import:
   - CSV template download
   - File upload
   - Preview records
   - Validation
   - Batch create
   - Email credentials in bulk
```

#### 4.2 CreateClassScreen
```
Features:
- Create new classes
- Set capacity (e.g., max 80 students)
- Assign teachers
- Add students
- Set class timing
- Define academic year/semester
- Manage archived classes

Form Fields:
- Class Name
- Subject
- Capacity (number input)
- Level (dropdown)
- Academic Year
- Semester
- Teacher Assignment (multi-select)
- Schedule/Batch Assignment
```

#### 4.3 ScheduleManagerScreen
```
Features:
- Create/edit class schedules
- Assign classes to batches
- Allocate teachers
- Set exact timings
- Manage resource allocation
- Handle schedule conflicts
- Enable notifications
- Bulk import from template

Schedule Editor:
- Weekly grid view
- Drag-to-assign schedule
- Time slot picker
- Teacher availability check
- Room/Resource selection
- Conflict detection
```

#### 4.4 ReportsScreen
```
Features:
- Generate custom reports:
  1. Attendance Reports
  2. Result Summaries
  3. Payment Reports
- Date range filtering
- Export to PDF/Excel
- Schedule recurring reports
- Email reports to stakeholders
- Send SMS notifications
- Use templates for notifications

Report Types:

Attendance Report:
- Student-wise attendance
- Class-wise summary
- Present/Absent/Leave counts
- Attendance percentage

Result Summary:
- Class-wise results
- Subject performance
- Grade distribution
- Top/Bottom performers
- Average scores

Payment Report:
- Pending payments
- Completed payments
- Outstanding dues
- Monthly collection
- By-class summary
```

#### 4.5 InvoiceGeneratorScreen
```
Features:
- Set fee structure per class
- Auto-generate monthly invoices
- Bulk generation for all students
- Calculate due amounts & penalties
- Customizable templates
- Overdue penalty rules
- Bulk email invoices
- Archive old invoices

Fee Configuration:
- Monthly fee amount
- Admission fee
- Exam fee
- Other fees
- Payment due date
- Penalty percentage/amount
- Terms and conditions

Invoice Generation:
- Select class/students
- Set month/period
- Calculate totals
- Add custom charges
- Generate batch
- Preview invoices
- Email to students
```

---

## 📊 Service Architecture

### Services to Implement

#### PaymentService
```dart
class PaymentService {
  // Firestore operations for payments
  Future<void> createPayment(Payment payment)
  Future<List<Payment>> getStudentPayments(String studentId)
  Future<void> updatePaymentStatus(String paymentId, String status)
  Future<void> deletePayment(String paymentId)
}
```

#### InvoiceService
```dart
class InvoiceService {
  // Firestore operations for invoices
  Future<void> createInvoice(Invoice invoice)
  Future<List<Invoice>> getStudentInvoices(String studentId)
  Future<void> updateInvoice(Invoice invoice)
  Future<void> generateBulkInvoices(List<String> studentIds, double amount)
  Future<String> generatePDF(Invoice invoice)
}
```

#### ExamService
```dart
class ExamService {
  Future<void> createExam(Exam exam)
  Future<List<Exam>> getClassExams(String classId)
  Future<void> updateExamStatus(String examId, String status)
  Future<void> publishResults(String examId)
}
```

#### ResultService
```dart
class ResultService {
  Future<void> uploadResult(Result result)
  Future<List<Result>> getStudentResults(String studentId)
  Future<void> publishResult(String resultId)
  Future<void> bulkUpload(List<Result> results)
}
```

#### MaterialService
```dart
class MaterialService {
  Future<void> uploadMaterial(CourseMaterial material)
  Future<List<CourseMaterial>> getClassMaterials(String classId)
  Future<void> updateMaterial(CourseMaterial material)
  Future<String> getDownloadUrl(String materialId)
}
```

#### ClassService
```dart
class ClassService {
  Future<void> createClass(ClassModel classModel)
  Future<List<ClassModel>> getAllClasses()
  Future<void> addStudentToClass(String classId, String studentId)
  Future<void> assignTeacherToClass(String classId, String teacherId)
}
```

#### ScheduleService
```dart
class ScheduleService {
  Future<void> createSchedule(ClassSchedule schedule)
  Future<List<ClassSchedule>> getClassSchedules(String classId)
  Future<void> updateSchedule(ClassSchedule schedule)
  Future<bool> checkConflicts(ClassSchedule schedule)
}
```

#### ReportService
```dart
class ReportService {
  Future<AttendanceReport> generateAttendanceReport(DateTime from, DateTime to)
  Future<ResultReport> generateResultReport(String classId)
  Future<PaymentReport> generatePaymentReport(DateTime from, DateTime to)
  Future<String> exportToPDF(Report report)
}
```

#### NotificationService
```dart
class NotificationService {
  Future<void> sendSMS(String phone, String message)
  Future<void> sendEmail(String email, String subject, String body)
  Future<void> sendPushNotification(String userId, String message)
}
```

---

## 📱 Provider Architecture

Each provider should be created as a ChangeNotifier:

```dart
class PaymentProvider extends ChangeNotifier {
  // State
  List<Invoice> invoices = [];
  List<Payment> payments = [];
  bool isLoading = false;
  String? errorMessage;
  
  // Methods
  Future<void> loadInvoices(String studentId)
  Future<void> loadPaymentHistory(String studentId)
  Future<bool> makePayment(String invoiceId, String methodId)
  Future<void> refreshData(String studentId)
}

class ExamProvider extends ChangeNotifier {
  // State
  List<Exam> exams = [];
  Exam? selectedExam;
  bool isLoading = false;
  
  // Methods
  Future<void> loadExams(String classId)
  Future<void> createExam(Exam exam)
  Future<void> publishExam(String examId)
}

// Similar for other providers:
class ResultProvider extends ChangeNotifier { }
class MaterialProvider extends ChangeNotifier { }
class ClassProvider extends ChangeNotifier { }
class ScheduleProvider extends ChangeNotifier { }
class ReportProvider extends ChangeNotifier { }
class StudentProvider extends ChangeNotifier { }
```

---

## 🎯 Implementation Priority

### Week 1-2: Payment Module (Critical)
- [ ] PaymentService
- [ ] PaymentProvider
- [ ] StudentPaymentScreen (Full implementation)
- [ ] PaymentHistoryScreen
- [ ] InvoiceViewScreen
- [ ] Basic Payment Gateway Integration

### Week 3-4: Academic Module
- [ ] ExamService, ExamProvider
- [ ] ResultService, ResultProvider
- [ ] ViewResultsScreen
- [ ] ScheduleExamScreen
- [ ] UploadResultsScreen

### Week 5-6: Admin & Reporting
- [ ] ClassService, ClassProvider
- [ ] AdminDashboard
- [ ] CreateClassScreen
- [ ] ScheduleManagerScreen
- [ ] ReportService, ReportProvider
- [ ] ReportsScreen

### Week 7-8: Polish & Testing
- [ ] Material upload implementation
- [ ] Rewards system
- [ ] Progress report dashboard
- [ ] Testing all features
- [ ] Performance optimization
- [ ] Security review

---

## 📂 File Structure (Complete)

```
lib/
├── models/
│   ├── user_model.dart ✅
│   ├── payment_model.dart ✅
│   ├── invoice_model.dart ✅
│   ├── exam_model.dart ✅
│   ├── result_model.dart ✅
│   ├── material_model.dart ✅
│   ├── schedule_model.dart ✅
│   ├── class_model.dart ✅
│   ├── reward_model.dart ✅
│   └── enrollment_model.dart ✅
│
├── services/
│   ├── auth_service.dart ✅
│   ├── firestore_service.dart (base)
│   ├── payment_service.dart (TODO)
│   ├── invoice_service.dart (TODO)
│   ├── exam_service.dart (TODO)
│   ├── result_service.dart (TODO)
│   ├── material_service.dart (TODO)
│   ├── class_service.dart (TODO)
│   ├── schedule_service.dart (TODO)
│   ├── report_service.dart (TODO)
│   └── notification_service.dart (TODO)
│
├── providers/
│   ├── auth_provider.dart ✅
│   ├── payment_provider.dart (TODO)
│   ├── invoice_provider.dart (TODO)
│   ├── exam_provider.dart (TODO)
│   ├── result_provider.dart (TODO)
│   ├── material_provider.dart (TODO)
│   ├── class_provider.dart (TODO)
│   ├── schedule_provider.dart (TODO)
│   ├── report_provider.dart (TODO)
│   └── student_provider.dart (TODO)
│
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart ✅
│   │   ├── register_screen.dart ✅
│   │   └── splash_screen.dart ✅
│   │
│   ├── student/
│   │   ├── student_dashboard_screen.dart ✅
│   │   ├── view_results_screen.dart ✅
│   │   ├── progress_report_screen.dart ✅
│   │   ├── rewards_screen.dart ✅
│   │   ├── class_schedule_screen.dart ✅
│   │   └── materials_screen.dart ✅
│   │
│   ├── payment/
│   │   ├── student_payment_screen.dart ✅
│   │   ├── payment_history_screen.dart ✅
│   │   └── invoice_view_screen.dart ✅
│   │
│   ├── teacher/
│   │   ├── teacher_dashboard_screen.dart ✅
│   │   ├── schedule_exam_screen.dart ✅
│   │   ├── upload_results_screen.dart ✅
│   │   ├── upload_material_screen.dart ✅
│   │   ├── payment_status_screen.dart ✅
│   │   └── teacher_profile_setup_screen.dart ✅
│   │
│   └── admin/
│       ├── admin_dashboard_screen.dart ✅
│       ├── user_registration_screen.dart ✅
│       ├── create_class_screen.dart ✅
│       ├── schedule_manager_screen.dart ✅
│       ├── reports_screen.dart ✅
│       ├── invoice_generator_screen.dart ✅
│       └── payment_management.dart ✅
│
├── widgets/
│   ├── custom_button.dart ✅
│   ├── custom_textfield.dart ✅
│   ├── payment_card.dart (TODO)
│   ├── result_card.dart (TODO)
│   ├── material_card.dart (TODO)
│   ├── schedule_card.dart (TODO)
│   ├── invoice_template.dart (TODO)
│   └── custom_report_widget.dart (TODO)
│
├── routes/
│   └── app_routes.dart ✅
│
├── config/
│   ├── colors.dart
│   ├── themes.dart
│   └── constants.dart
│
├── utils/
│   ├── validators.dart
│   ├── formatters.dart
│   └── constants.dart
│
├── firebase_options.dart ✅
├── main.dart ✅
└── pubspec.yaml ✅
```

---

## 🧪 Testing Strategy

### Unit Tests
- Service methods (Firebase operations)
- Model methods (calculations, conversions)
- Provider state management

### Widget Tests
- Screen rendering
- User interactions
- Form validation
- Navigation

### Integration Tests
- Complete payment flow
- User authentication
- Data persistence
- Cross-screen navigation

---

## 🚀 Deployment Checklist

- [ ] All services implemented
- [ ] All screens completed
- [ ] All providers set up
- [ ] Firebase configured
- [ ] Payment gateway integrated
- [ ] Error handling added
- [ ] Loading states implemented
- [ ] Security best practices
- [ ] Performance optimized
- [ ] Code reviewed
- [ ] All tests passing
- [ ] Documentation complete

---

## 📚 Documentation References

- See `SYSTEM_ARCHITECTURE.md` for complete architecture
- See model files for data structure details
- See individual screen implementations for UI logic

---

## 🔗 Quick Start Commands

```bash
# Get all dependencies
flutter pub get

# Format code
dart format .

# Analyze code
dart analyze

# Run tests
flutter test

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

---

**Document Version:** 2.0  
**Last Updated:** November 27, 2025  
**Status:** Ready for Phase 1 Implementation
