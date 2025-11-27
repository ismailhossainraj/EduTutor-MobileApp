# EduTutor - Tuition Management System Architecture

## System Overview
A comprehensive Tuition Management System with three distinct user roles, each with specific use cases and functionalities.

---

## Table of Contents
1. [User Roles & Actors](#user-roles--actors)
2. [Common Features](#common-features)
3. [Student Module](#student-module)
4. [Teacher Module](#teacher-module)
5. [Admin Module](#admin-module)
6. [Use Case Relationships](#use-case-relationships)
7. [Database Schema](#database-schema)
8. [Implementation Status](#implementation-status)
9. [Project Structure](#project-structure)
10. [Navigation Flow](#navigation-flow)

---

## User Roles & Actors

### Three Primary Actors:
1. **Student** - Learner accessing academic content, payments, and results
2. **Teacher** - Educator managing classes, exams, and materials
3. **Admin** - System administrator managing all users, classes, and reports

---

## Common Features

### ✅ LOGIN (All Users)
**Use Case:** Log In  
**Includes:** Verify Email and Password (MANDATORY)  
**Purpose:** Authenticate users before system access

**Implementation:**
- **Screen:** `LoginScreen` (`lib/screens/auth/login_screen.dart`)
- **Backend:** Firebase Auth
- **Inputs:** Email + Password
- **Validation:**
  - Email format verification
  - Password non-empty check
  - Credentials verification against Firebase

**Role-Based Redirection:**
```
Student → Student Dashboard (/student-dashboard)
Teacher → Teacher Dashboard (/teacher-dashboard)
Admin → Admin Dashboard (/admin-dashboard)
```

**Code Flow:**
```dart
Future<void> _login() async {
  // 1. Validate form
  // 2. Call authProvider.login()
  // 3. Check user.role
  // 4. Route to appropriate dashboard
}
```

---

## Student Module

### A) Payments

#### 1️⃣ Online Payment
**Use Cases:**
- Online Payment
- View Payment History
- Verify Account
- Send Notification (EXTENSION - Optional)
- Generate Fee Invoice (Visible to student)

**Screens to Implement:**
```
✅ PaymentActivity → lib/screens/payment/student_payment_screen.dart
✅ PaymentHistoryActivity → lib/screens/payment/payment_history_screen.dart
✅ InvoiceViewActivity → lib/screens/payment/invoice_view_screen.dart
```

**Data Models:**
```dart
class Payment {
  String id;
  String studentId;
  double amount;
  DateTime paymentDate;
  String status; // pending, completed, failed
  String paymentMethod; // card, bank_transfer, etc
  String transactionId;
  DateTime createdAt;
}

class Invoice {
  String id;
  String studentId;
  double feeAmount;
  DateTime dueDate;
  String status; // unpaid, paid, overdue
  List<Payment> payments;
  DateTime generatedAt;
}
```

**Flow:**
```
Student Dashboard → Payment Section
  ↓
Student clicks "Pay Fee"
  ↓
System verifies account (VPA/Bank details)
  ↓
Payment gateway integration (Stripe/PayPal)
  ↓
Process payment
  ↓
Send notification (SMS/Push notification)
  ↓
Update invoice status
  ↓
View updated invoice with receipt
```

#### 2️⃣ View Payment History
- List all past payments
- Filter by date range
- View payment method used
- Download receipts

#### 3️⃣ Verify Account
- Show account status
- Display linked payment methods
- Allow adding new payment methods

#### 4️⃣ Send Notification (EXTENSION)
- Triggered after successful payment
- SMS notification
- Push notification
- Email receipt

#### 5️⃣ Generate Fee Invoice
- Monthly fee invoice
- Due date display
- Penalty calculation if overdue

---

### B) Academic Features

#### 1️⃣ View Result
**Screen:** `ResultActivity` → `lib/screens/student/view_results_screen.dart`

**Data Model:**
```dart
class Result {
  String id;
  String studentId;
  String classId;
  String subjectId;
  double marksObtained;
  double totalMarks;
  String grade; // A, B, C, D, F
  String remarks;
  DateTime resultDate;
  String examType; // midterm, final, unit_test
}
```

**Features:**
- Display exam marks
- Show calculated grade
- Display teacher remarks
- Filter by exam type/subject
- Download result as PDF

#### 2️⃣ View Progress Report
**Screens:**
```
ProgressReportActivity → lib/screens/student/progress_report_screen.dart
RewardActivity → lib/screens/student/rewards_screen.dart
```

**Includes:** Reward (MANDATORY)

**Data Models:**
```dart
class ProgressReport {
  String id;
  String studentId;
  double overallScore;
  String performanceLevel; // excellent, good, average, needs_improvement
  int totalTests;
  int passedTests;
  double averageScore;
  DateTime generatedDate;
}

class Reward {
  String id;
  String studentId;
  String type; // points, badges, performance_level
  String title;
  String description;
  int pointsEarned;
  DateTime earnedAt;
}

enum PerformanceLevel {
  excellent,
  good,
  average,
  needsImprovement
}
```

**Reward System:**
- **Points:** Earned for completing assignments, tests, participation
- **Badges:** Achievement badges (First 100%, Perfect Attendance, etc)
- **Performance Level:** Overall classification based on scores

**Features:**
- Timeline of progress
- Grade trend visualization
- Reward display and tracking
- Performance comparison

#### 3️⃣ View Class Schedule
**Screen:** `ScheduleActivity` → `lib/screens/student/class_schedule_screen.dart`

**Data Model:**
```dart
class ClassSchedule {
  String id;
  String classId;
  String subject;
  String teacherName;
  DateTime startTime;
  DateTime endTime;
  String roomNumber;
  String status; // scheduled, ongoing, completed, cancelled
}
```

**Features:**
- Weekly calendar view
- Class details (time, teacher, room)
- Notifications for upcoming classes
- Mark attendance status

#### 4️⃣ Download/View Online Material
**Screen:** `MaterialsActivity` → `lib/screens/student/materials_screen.dart`

**Data Model:**
```dart
class CourseMaterial {
  String id;
  String classId;
  String teacherId;
  String title;
  String description;
  String fileType; // pdf, video, image, link, notes
  String fileUrl;
  String downloadUrl;
  DateTime uploadedAt;
  String status; // published, draft
}
```

**Storage:** Firebase Storage / Cloudinary

**Features:**
- View all uploaded materials by teacher
- Filter by type (PDF, Video, Notes, Links)
- Download files
- Stream videos
- Search materials
- Favorite materials for quick access

---

## Teacher Module

### A) Exam & Evaluation

#### 1️⃣ Schedule Exam
**Screen:** `ExamScheduleActivity` → `lib/screens/teacher/schedule_exam_screen.dart`

**Data Model:**
```dart
class Exam {
  String id;
  String classId;
  String teacherId;
  String subject;
  DateTime scheduledDate;
  DateTime endTime;
  String examType; // midterm, final, unit_test, quiz
  String description;
  String status; // scheduled, in_progress, completed, cancelled
  int totalQuestions;
  double totalMarks;
}
```

**Features:**
- Create new exam
- Set exam date and time
- Define total marks
- Assign to specific classes
- Set exam type
- Save as draft or publish

#### 2️⃣ Make/Upload Result
**Screen:** `ResultUploadActivity` → `lib/screens/teacher/upload_results_screen.dart`

**Features:**
- Enter marks for each student
- Add remarks/feedback
- Bulk upload via CSV
- Calculate grades automatically
- Publish results to students
- Edit results if needed

**Data Entry Methods:**
```
Option 1: Manual Entry
  - Single student form
  - Add marks and remarks
  
Option 2: Bulk Upload
  - Upload CSV file
  - Parse student IDs, marks, remarks
  - Preview before submission
  
Option 3: Import from Assessment Tool
  - Integration with online exam platform
  - Auto-import marks
```

---

### B) Study Materials

#### 1️⃣ Upload Materials
**Screen:** `MaterialUploadActivity` → `lib/screens/teacher/upload_material_screen.dart`

**Supported File Types:**
- PDF documents
- Images (JPG, PNG)
- Video files (MP4, MOV)
- Notes/Text files
- Links to external resources

**Features:**
- Drag-and-drop upload
- File validation (size, format)
- Add title and description
- Set access level (all students, specific class, specific students)
- Schedule publication date
- Organize by unit/chapter

---

### C) Payment Related

#### 1️⃣ Update Payment Status
**Screen:** `PaymentStatusActivity` → `lib/screens/teacher/payment_status_screen.dart`

**Purpose:**
- View student payment status
- Mark students as paid/unpaid
- Used for admin override cases
- Generate payment reports

**Features:**
- View all assigned students
- Filter by payment status
- Bulk update payment status
- Add notes/comments
- Generate payment receipt

---

## Admin Module

Admin has complete control. Screens and use cases below:

### A) User Management

#### 1️⃣ User Registration
**Screen:** `UserRegistrationActivity` → `lib/screens/admin/user_registration_screen.dart`

**Creates:**
- Student accounts
- Teacher accounts

**Data Model:**
```dart
class UserRegistration {
  String firstName;
  String lastName;
  String email;
  String phone;
  String role; // student, teacher, admin
  String password;
  // Role-specific fields filled based on role
}
```

**Features:**
- Create individual user
- Bulk import via CSV
- Set role and permissions
- Assign to class (for students)
- Assign subjects (for teachers)
- Auto-generate credentials
- Send login details via email

---

### B) Class Management

#### 1️⃣ Create Class
**Screen:** `CreateClassActivity` → `lib/screens/admin/create_class_screen.dart`

**Includes:** Set Capacity (MANDATORY)

**Data Model:**
```dart
class ClassModel {
  String id;
  String className; // e.g., "Class 10-A"
  String subject;
  int capacity; // e.g., 80 students max
  String level; // primary, secondary, senior_secondary
  DateTime createdAt;
  List<String> studentIds;
  List<String> teacherIds;
  String status; // active, inactive, archived
}
```

**Features:**
- Enter class name
- Set total capacity (e.g., 80 students)
- Assign teachers
- Add students
- Set class timing
- Define academic year/semester
- Archive old classes

#### 2️⃣ Create/Update Schedule
**Screen:** `ScheduleManagerActivity` → `lib/screens/admin/schedule_manager_screen.dart`

**Includes:**
- Assign Batch (MANDATORY)
- Assign Class (MANDATORY)
- Adjust Time (MANDATORY)
- Allocate Teacher (MANDATORY)

**Features:**
- Create weekly/monthly schedules
- Assign classes to batches
- Allocate specific teachers
- Set exact timings (start/end time)
- Manage room/resource allocation
- Handle schedule conflicts
- Enable schedule notifications

---

### C) Reports & Notifications

#### 1️⃣ Generate Report
**Screen:** `ReportActivity` → `lib/screens/admin/reports_screen.dart`

**Includes:**
- Notify Student (MANDATORY)
- Notify Parents (MANDATORY)

**Report Types:**

**a) Attendance Report**
- Student-wise attendance
- Class-wise attendance
- Date range filtering
- Download as PDF/Excel

**b) Result Summary**
- Class-wise results
- Subject-wise performance
- Grade distribution
- Top performers
- Low performers

**c) Payment Report**
- Pending payments
- Completed payments
- Outstanding dues
- Monthly collection summary
- By-class payment status

**Features:**
- Generate custom reports
- Schedule recurring reports
- Email to stakeholders
- Send SMS notifications
- Notification templates
- Delivery confirmation

---

### D) Finance

#### 1️⃣ Generate Fee Invoice
**Screen:** `InvoiceGeneratorActivity` → `lib/screens/admin/invoice_generator_screen.dart`

**Data Model:**
```dart
class FeeStructure {
  String id;
  String classId;
  double monthlyFee;
  double admissionFee;
  double examFee;
  double otherFees;
  DateTime effectiveFrom;
}

class Invoice {
  String id;
  String studentId;
  String invoiceNumber;
  DateTime generatedDate;
  DateTime dueDate;
  double monthlyFee;
  double totalDue;
  double amountPaid;
  double balanceDue;
  String status; // unpaid, paid, overdue, partial
}
```

**Generates:**
- Monthly fee invoices
- Bulk invoices for all students
- Calculate due amounts
- Penalty for overdue payments
- Invoice templates

**Features:**
- Set fee structure per class
- Auto-generate monthly invoices
- Customizable invoice templates
- Overdue penalty calculation
- Payment terms configuration
- Bulk email invoices to students
- Invoice history and archival

---

## Use Case Relationships

### «include» (Mandatory)
These use cases MUST occur:
```
Login → includes → Verify Email and Password
View Progress Report → includes → Reward
Create Class → includes → Set Capacity
Create/Update Schedule → includes → Assign Batch, Assign Class, Adjust Time, Allocate Teacher
Generate Report → includes → Notify Student, Notify Parents
```

### «extend» (Optional/Conditional)
These use cases occur conditionally:
```
Online Payment → may extend → Send Notification
                            → Generate Fee Invoice
Result → may extend → Send Notification to Parents
```

---

## Database Schema

### Collections (Firebase):

#### 1. **users**
```
users/
├── {userId}/
│   ├── email
│   ├── firstName
│   ├── lastName
│   ├── phone
│   ├── role (student|teacher|admin)
│   ├── status (active|inactive)
│   ├── createdAt
│   └── [role-specific fields]
│       ├── (student) classId, enrollmentDate
│       ├── (teacher) subjects, classIds
│       └── (admin) permissions
```

#### 2. **classes**
```
classes/
├── {classId}/
│   ├── className
│   ├── subject
│   ├── capacity
│   ├── level
│   ├── studentIds[] 
│   ├── teacherIds[]
│   ├── status
│   └── createdAt
```

#### 3. **exams**
```
exams/
├── {examId}/
│   ├── classId
│   ├── teacherId
│   ├── subject
│   ├── scheduledDate
│   ├── examType
│   └── status
```

#### 4. **results**
```
results/
├── {resultId}/
│   ├── studentId
│   ├── examId
│   ├── classId
│   ├── marksObtained
│   ├── totalMarks
│   ├── grade
│   └── remarks
```

#### 5. **payments**
```
payments/
├── {paymentId}/
│   ├── studentId
│   ├── amount
│   ├── paymentDate
│   ├── status
│   ├── paymentMethod
│   └── transactionId
```

#### 6. **invoices**
```
invoices/
├── {invoiceId}/
│   ├── studentId
│   ├── invoiceNumber
│   ├── generatedDate
│   ├── dueDate
│   ├── monthlyFee
│   ├── totalDue
│   └── status
```

#### 7. **materials**
```
materials/
├── {materialId}/
│   ├── classId
│   ├── teacherId
│   ├── title
│   ├── fileType
│   ├── fileUrl (Firebase Storage)
│   ├── uploadedAt
│   └── status
```

#### 8. **schedules**
```
schedules/
├── {scheduleId}/
│   ├── classId
│   ├── teacherId
│   ├── subject
│   ├── dayOfWeek
│   ├── startTime
│   ├── endTime
│   └── roomNumber
```

#### 9. **rewards**
```
rewards/
├── {rewardId}/
│   ├── studentId
│   ├── type (points|badges|performance)
│   ├── title
│   ├── pointsEarned
│   └── earnedAt
```

---

## Implementation Status

### ✅ COMPLETED
- [x] Authentication System (Login Screen)
- [x] Splash Screen with animations
- [x] Role-based navigation
- [x] User Model with roles

### 🔄 IN PROGRESS / TODO

#### Phase 1: Student Module - Payments (PRIORITY)
- [ ] Payment Screen
- [ ] Payment History Screen
- [ ] Invoice View Screen
- [ ] Payment Models & Services

#### Phase 2: Student Module - Academic
- [ ] View Results Screen
- [ ] Progress Report Screen
- [ ] Rewards Screen
- [ ] Class Schedule Screen
- [ ] Materials Screen

#### Phase 3: Teacher Module
- [ ] Schedule Exam Screen
- [ ] Upload Results Screen
- [ ] Upload Material Screen
- [ ] Payment Status Screen

#### Phase 4: Admin Module
- [ ] User Registration Screen
- [ ] Create Class Screen
- [ ] Schedule Manager Screen
- [ ] Reports Screen
- [ ] Invoice Generator Screen

#### Phase 5: Services & Providers
- [ ] PaymentService
- [ ] ExamService
- [ ] MaterialService
- [ ] ClassService
- [ ] ReportService
- [ ] Respective Providers

#### Phase 6: Widgets & Components
- [ ] Custom report widgets
- [ ] Invoice templates
- [ ] Material cards
- [ ] Result cards
- [ ] Schedule widgets

---

## Project Structure

```
lib/
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart ✅
│   │   ├── splash_screen.dart ✅
│   │   └── register_screen.dart ✅
│   ├── student/
│   │   ├── student_dashboard_screen.dart
│   │   ├── view_results_screen.dart
│   │   ├── progress_report_screen.dart
│   │   ├── rewards_screen.dart
│   │   ├── class_schedule_screen.dart
│   │   └── materials_screen.dart
│   ├── payment/
│   │   ├── student_payment_screen.dart
│   │   ├── payment_history_screen.dart
│   │   └── invoice_view_screen.dart
│   ├── teacher/
│   │   ├── teacher_dashboard_screen.dart
│   │   ├── schedule_exam_screen.dart
│   │   ├── upload_results_screen.dart
│   │   ├── upload_material_screen.dart
│   │   └── payment_status_screen.dart
│   └── admin/
│       ├── admin_dashboard_screen.dart
│       ├── user_registration_screen.dart
│       ├── create_class_screen.dart
│       ├── schedule_manager_screen.dart
│       ├── reports_screen.dart
│       └── invoice_generator_screen.dart
├── models/
│   ├── user_model.dart ✅
│   ├── payment_model.dart
│   ├── exam_model.dart
│   ├── result_model.dart
│   ├── material_model.dart
│   ├── schedule_model.dart
│   ├── class_model.dart
│   ├── reward_model.dart
│   └── invoice_model.dart
├── providers/
│   ├── auth_provider.dart ✅
│   ├── payment_provider.dart
│   ├── exam_provider.dart
│   ├── material_provider.dart
│   ├── class_provider.dart
│   ├── report_provider.dart
│   └── student_provider.dart
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── payment_service.dart
│   ├── exam_service.dart
│   ├── material_service.dart
│   ├── class_service.dart
│   ├── report_service.dart
│   └── notification_service.dart
├── widgets/
│   ├── custom_button.dart ✅
│   ├── custom_textfield.dart ✅
│   ├── payment_card.dart
│   ├── result_card.dart
│   ├── material_card.dart
│   ├── schedule_card.dart
│   ├── invoice_template.dart
│   └── custom_report_widget.dart
├── routes/
│   └── app_routes.dart ✅
├── config/
│   ├── colors.dart
│   └── themes.dart
├── utils/
│   ├── validators.dart
│   ├── formatters.dart
│   └── constants.dart
└── main.dart ✅
```

---

## Navigation Flow

### Complete User Journey

```
SplashScreen (/)
    ↓
[User Authenticated?]
    ├─ NO → RoleSelectionScreen (if needed)
    │        ↓
    │        LoginScreen (/login)
    │        ↓
    │        RegisterScreen (/register)
    │
    └─ YES → Check Role
             ├─ STUDENT → StudentDashboard (/student-dashboard)
             │             ├→ View Results (/student-results)
             │             ├→ Progress Report (/student-progress)
             │             ├→ Rewards (/student-rewards)
             │             ├→ Class Schedule (/student-schedule)
             │             ├→ Materials (/student-materials)
             │             └→ Payments (/student-payments)
             │                 ├→ Payment History (/payment-history)
             │                 └→ Invoice View (/invoice-view)
             │
             ├─ TEACHER → TeacherDashboard (/teacher-dashboard)
             │             ├→ Schedule Exam (/schedule-exam)
             │             ├→ Upload Results (/upload-results)
             │             ├→ Upload Material (/upload-material)
             │             └→ Payment Status (/payment-status)
             │
             └─ ADMIN → AdminDashboard (/admin-dashboard)
                         ├→ User Registration (/user-registration)
                         ├→ Create Class (/create-class)
                         ├→ Schedule Manager (/schedule-manager)
                         ├→ Reports (/reports)
                         └→ Invoice Generator (/invoice-generator)

[Logout] → SplashScreen (/)
```

---

## Key Features Summary

### Authentication
- ✅ Email/Password Login
- ✅ Role-based access control
- ✅ Session management
- ✅ Secure password handling

### Student Features
- View exam results with grades
- Track academic progress with rewards
- Download class materials
- View class schedules
- Make online payments
- View payment history
- Download invoices

### Teacher Features
- Schedule exams
- Upload and manage results
- Upload course materials
- View and manage student payments
- Generate performance reports

### Admin Features
- Create and manage users
- Create and manage classes
- Manage class schedules
- Generate comprehensive reports
- Create fee invoices
- Send notifications

---

## Next Steps

1. **Create All Models** - Implement data models for each entity
2. **Build Services** - Create Firestore interaction services
3. **Implement Providers** - State management for each module
4. **Build Screens** - Implement UI screens in order of priority
5. **Add Widgets** - Create reusable UI components
6. **Setup Navigation** - Configure all routes
7. **Testing** - Unit tests for services and providers
8. **Optimization** - Performance and security improvements

---

## Notes

- All screens follow Material Design 3 principles
- Use Provider for state management
- Firebase Firestore for database
- Firebase Storage for file uploads
- Responsive design for all screen sizes
- Proper error handling and user feedback
- Loading states for all async operations

---

**Document Version:** 1.0  
**Last Updated:** November 27, 2025  
**Status:** Complete Architecture Definition
