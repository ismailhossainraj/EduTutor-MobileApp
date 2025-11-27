# EduTutor - Quick Reference Guide

## 🎯 System Overview in 60 Seconds

**EduTutor** is a Tuition Management System with 3 user roles:

| Role | Dashboard | Key Features |
|------|-----------|--------------|
| **Student** | `/student-dashboard` | Pay fees, view results, track progress, download materials |
| **Teacher** | `/teacher-dashboard` | Schedule exams, upload results & materials, manage payments |
| **Admin** | `/admin-dashboard` | Manage users, classes, schedules, generate reports & invoices |

---

## 📍 Complete Route Map

### Authentication Routes
```
/                    → SplashScreen (Entry point)
/login               → LoginScreen
/register            → RegisterScreen
```

### Student Routes
```
/student-dashboard        → StudentDashboard (Main hub)
/student-results          → ViewResultsScreen
/student-progress         → ProgressReportScreen
/student-rewards          → RewardsScreen
/student-schedule         → ClassScheduleScreen
/student-materials        → MaterialsScreen
/student-payments         → StudentPaymentScreen
/payment-history          → PaymentHistoryScreen
/invoice-view             → InvoiceViewScreen
```

### Teacher Routes
```
/teacher-dashboard        → TeacherDashboard (Main hub)
/teacher-profile-setup    → TeacherProfileSetupScreen (First time)
/schedule-exam            → ScheduleExamScreen
/upload-results           → UploadResultsScreen
/upload-material          → UploadMaterialScreen
/payment-status           → PaymentStatusScreen
```

### Admin Routes
```
/admin-dashboard          → AdminDashboard (Main hub)
/user-registration        → UserRegistrationScreen
/create-class             → CreateClassScreen
/schedule-manager         → ScheduleManagerScreen
/reports                  → ReportsScreen
/invoice-generator        → InvoiceGeneratorScreen
```

---

## 📦 Data Models at a Glance

### Payment
- studentId, amount, paymentDate, status, paymentMethod
- transactionId, createdAt, notes, receiptUrl

### Invoice
- studentId, invoiceNumber, monthlyFee, totalDue
- amountPaid, balanceDue, status, dueDate

### Exam
- classId, teacherId, subject, scheduledDate
- examType, status, totalMarks, totalQuestions

### Result
- studentId, examId, marksObtained, totalMarks
- grade, remarks, examType, isPublished

### CourseMaterial
- classId, teacherId, title, description
- fileType, fileUrl, status, downloadCount

### ClassSchedule
- classId, subject, teacherName, startTime/endTime
- roomNumber, dayOfWeek, batchName, status

### ClassModel
- className, subject, capacity, level
- studentIds[], teacherIds[], status, academicYear

### Reward & ProgressReport
- studentId, type (points/badges/performance)
- pointsEarned, earnedAt, category

---

## 🔄 Use Case Relationships (IMPORTANT)

### «include» - MANDATORY Features
```
Login
  ├─ includes → Verify Email and Password
  
View Progress Report
  └─ includes → Reward System

Create Class
  └─ includes → Set Capacity

Create/Update Schedule
  ├─ includes → Assign Batch
  ├─ includes → Assign Class
  ├─ includes → Adjust Time
  └─ includes → Allocate Teacher

Generate Report
  ├─ includes → Notify Student
  └─ includes → Notify Parents
```

### «extend» - OPTIONAL/CONDITIONAL Features
```
Online Payment
  ├─ extends → Send Notification (after successful payment)
  └─ extends → Generate Fee Invoice

Result Publishing
  └─ extends → Send Notification to Parents
```

---

## 💾 Database Collections

### Firestore Structure
```
users/
├── {userId}/
│   ├── email, firstName, lastName, phone
│   ├── role (student|teacher|admin)
│   └── [role-specific fields]

classes/
├── {classId}/
│   ├── className, subject, capacity
│   ├── studentIds[], teacherIds[]
│   └── status, academicYear, semester

exams/
├── {examId}/
│   ├── classId, teacherId, subject
│   ├── scheduledDate, examType
│   └── status, totalMarks

results/
├── {resultId}/
│   ├── studentId, examId, marksObtained
│   ├── grade, remarks
│   └── resultDate, isPublished

payments/
├── {paymentId}/
│   ├── studentId, amount, paymentDate
│   ├── status, paymentMethod
│   └── transactionId, receiptUrl

invoices/
├── {invoiceId}/
│   ├── studentId, invoiceNumber, monthlyFee
│   ├── totalDue, amountPaid
│   └── status, dueDate

materials/
├── {materialId}/
│   ├── classId, teacherId, title
│   ├── fileType, fileUrl, status
│   └── uploadedAt, downloadCount

schedules/
├── {scheduleId}/
│   ├── classId, teacherId, subject
│   ├── startTime, endTime, roomNumber
│   └── dayOfWeek, status

rewards/
├── {rewardId}/
│   ├── studentId, type, title
│   ├── pointsEarned, earnedAt
│   └── category, imageUrl
```

---

## 🎨 Feature Summary by Module

### Student Module

#### Payments
- 💳 Make online payments (Card, Bank Transfer, Wallet)
- 📋 View payment history and receipts
- 📄 View and download invoices
- 📧 Automatic payment notifications

#### Academic
- 📊 View exam results with grades
- 📈 Progress report with performance level
- 🏆 Reward system (Points, Badges, Performance levels)
- 📚 Download course materials (PDF, Video, Notes)
- 📅 View class schedule

### Teacher Module

#### Exams & Results
- 📝 Schedule exams with detailed info
- 📊 Upload results (manual, bulk CSV, platform import)
- ✅ Publish results with notifications

#### Materials
- 📤 Upload course materials (PDF, Video, Images, Links)
- 🔐 Set access levels (All students, Specific batch, Individual)
- 📅 Schedule publication date

#### Payments
- 💰 View student payment status
- 📝 Update payment status (mark paid/unpaid)
- 📊 Generate payment reports

### Admin Module

#### User Management
- 👤 Create student accounts
- 👨‍🏫 Create teacher accounts
- 📥 Bulk import via CSV
- 📧 Auto-send credentials

#### Class Management
- 🏫 Create classes with capacity limits
- 👥 Assign teachers and students
- 🔄 Manage class schedules
- 📅 Batch and timing setup

#### Reports
- 📊 Attendance reports
- 📈 Result summaries
- 💳 Payment reports
- 📧 Email reports to stakeholders
- 📱 Send SMS notifications

#### Finance
- 📄 Create fee structure
- 🧾 Generate invoices monthly
- ⏰ Auto-calculate penalties for overdue
- 📤 Bulk email invoices

---

## 🛠️ Implementation Status

### ✅ Completed
- System architecture design
- All 9 data models created
- 35+ routes configured
- 18 screen placeholders created
- Payment model enhanced
- Routing system updated

### 🔄 Next Phase (Payment Module)
- PaymentService implementation
- PaymentProvider implementation
- Full StudentPaymentScreen implementation
- Payment gateway integration
- Invoice PDF generation

### 📅 Future Phases
- Academic module (Results, Progress, Materials, Schedule)
- Teacher features (Exam, Materials, Results)
- Admin features (Reports, Invoicing, User Management)
- Testing & optimization

---

## 🚀 Getting Started

### 1. Run the app
```bash
flutter run
```

### 2. Navigate through screens
- Start at Splash screen
- Login as student/teacher/admin
- Navigate to module-specific screens
- All screens are connected and routable

### 3. Implement Phase 1 (Payment)
- Follow IMPLEMENTATION_ROADMAP.md for detailed steps
- Create PaymentService and PaymentProvider
- Implement StudentPaymentScreen with full UI
- Integrate payment gateway

---

## 📱 Screen Templates

### Student Payment Screen
- Outstanding invoices section
- Payment method selector
- Recent transactions list
- Pay now button
- Download/Share options

### Teacher Exam Scheduler
- Form for exam details
- Date/time picker
- Class selector
- Exam type and marks
- Instructions field

### Admin Invoice Generator
- Fee structure configuration
- Date range selector
- Student/Class multi-select
- Penalty calculator
- Bulk email option

---

## 🔐 Security Notes

1. **Authentication**: All screens behind Firebase Auth
2. **Authorization**: Role-based access control
3. **Data**: Firestore rules per role
4. **Payments**: PCI-DSS compliant gateway
5. **Sensitive Data**: Server-side processing where needed

---

## 📞 Common Actions

### Create Payment
1. Student selects "Pay Fee"
2. System shows outstanding invoices
3. Student selects payment method
4. System processes payment
5. Notification sent
6. Receipt generated

### Schedule Exam
1. Teacher clicks "Schedule Exam"
2. Fills exam details
3. Selects date and classes
4. Sets total marks
5. Publishes exam
6. Notification sent to students

### Generate Invoice
1. Admin accesses invoice generator
2. Sets fee structure
3. Selects month and classes
4. Reviews calculated amounts
5. Generates invoices
6. Emails to students

---

## 🧭 Quick Navigation for Developers

| Need | File | Location |
|------|------|----------|
| Route reference | app_routes.dart | lib/routes/ |
| Data models | *_model.dart | lib/models/ |
| UI screens | *_screen.dart | lib/screens/{module}/ |
| Business logic | auth_provider.dart | lib/providers/ |
| API calls | firestore_service.dart | lib/services/ |

---

## 📚 Documentation Files

- `SYSTEM_ARCHITECTURE.md` - Complete system design with use cases
- `IMPLEMENTATION_ROADMAP.md` - Detailed phase-by-phase implementation guide
- `APP_NAVIGATION_MAP.md` - Navigation flows and route details
- `REGISTER_PAGE_GUIDE.md` - Registration system guide
- This file - Quick reference

---

**Last Updated:** November 27, 2025  
**Version:** 1.0  
**Status:** Foundation Complete - Ready for Phase 1 Implementation
