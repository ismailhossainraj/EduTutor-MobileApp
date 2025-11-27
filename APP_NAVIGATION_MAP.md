# 🗺️ App Navigation Map - Complete Flow

## 🎯 Full Navigation Structure

```
START: main.dart
  │
  └─ initialRoute: AppRoutes.splash
     │
     ▼
SPLASH SCREEN (Welcome Page)
  │ (3-second auto-navigation)
  │
  ├─────────────────────────────────┐
  │                                 │
  [USER LOGGED IN]        [USER NOT LOGGED IN]
  │                                 │
  └────────┬──────────────┬─────────┘
           │              │
           │              ▼
           │        ROLE SELECTION (on splash)
           │        ├─ 🎓 Login as Student
           │        ├─ 👨‍🏫 Login as Teacher
           │        ├─ ⚙️ Admin Login
           │        └─ Skip Selection
           │              │
           │              ▼
           │        LOGIN PAGE
           │        ├─ ← Back (returns to splash)
           │        ├─ Email input
           │        ├─ Password input
           │        ├─ [Login] button
           │        ├─ [Register] link
           │        └─ Forgot password link
           │              │
           │              ├─ [Register] → REGISTER PAGE
           │              │              ├─ ← Back (returns to login)
           │              │              ├─ Student tab
           │              │              │  ├─ First Name
           │              │              │  ├─ Last Name
           │              │              │  ├─ School
           │              │              │  ├─ Class
           │              │              │  ├─ Gender
           │              │              │  ├─ Email
           │              │              │  ├─ Password
           │              │              │  ├─ Confirm Password
           │              │              │  └─ [Register] button
           │              │              │     │
           │              │              │     ├─ Success → Student Dashboard
           │              │              │     └─ Error → Stay on form
           │              │              │
           │              │              └─ Teacher tab
           │              │                 ├─ First Name
           │              │                 ├─ Last Name
           │              │                 ├─ College
           │              │                 ├─ Education Level
           │              │                 ├─ University
           │              │                 ├─ Interest
           │              │                 ├─ Phone
           │              │                 ├─ Gender
           │              │                 ├─ Email
           │              │                 ├─ Password
           │              │                 ├─ Confirm Password
           │              │                 └─ [Register] button
           │              │                    │
           │              │                    ├─ Success → Teacher Profile Setup
           │              │                    └─ Error → Stay on form
           │              │
           │              └─ [Login] button → Login to dashboard
           │                    │
           │                    ├─ Admin role → Admin Dashboard
           │                    ├─ Teacher role → Teacher Dashboard
           │                    └─ Student role → Student Dashboard
           │
           └─ Direct to dashboard (auto-login)
              ├─ Admin Dashboard
              ├─ Teacher Dashboard
              └─ Student Dashboard
```

---

## 📱 **Screen-by-Screen Navigation**

### **1. SPLASH SCREEN** `/splash`
**Entry Point** - First screen user sees

```
┌────────────────────────┐
│    EduTutor Logo       │  (Animated)
│  Smart Tuition Mgmt    │  (Fading)
│  [🎓] [👨‍🏫] [⚙️]        │
│  Loading... (Spinner)  │
└────────────────────────┘
      ↓ (3 seconds)
      │
  ┌───┴──────────────┬──────────┐
  │                  │          │
  (Logged In)   (Not Logged In) (Role Selection)
```

**Navigation From Here**:
- ✅ Logged in: Routes to dashboard
- ✅ Not logged in: Shows role selection
- ✅ Buttons show role options

---

### **2. ROLE SELECTION** (on Splash Screen)
**Choose Registration/Login Type**

```
┌──────────────────────────┐
│  Welcome to EduTutor     │
│  Choose your role        │
│                          │
│  ┌────────────────────┐  │
│  │ 🎓 Login as Student│  │ → Login Page (student)
│  └────────────────────┘  │
│                          │
│  ┌────────────────────┐  │
│  │ 👨‍🏫 Login as Teacher│  │ → Login Page (teacher)
│  └────────────────────┘  │
│                          │
│  ┌────────────────────┐  │
│  │ ⚙️ Admin Login     │  │ → Login Page (admin)
│  └────────────────────┘  │
│                          │
│  Skip Selection          │ → Login Page (generic)
└──────────────────────────┘
```

**Navigation From Here**:
- ✅ Click role button: Goes to Login Page
- ✅ Click Skip: Goes to Login Page

---

### **3. LOGIN PAGE** `/login`
**User Authentication**

```
┌────────────────────────────┐
│ ← [Back to Splash]         │
├────────────────────────────┤
│      LOGIN                 │
│                            │
│  [Email Input Field]       │
│  [Password Input Field]    │
│                            │
│  [Login Button]            │
│                            │
│  [Register Link]  [Forgot] │ → Register Page / Forgot Page
│                            │
└────────────────────────────┘
```

**Navigation From Here**:
- ✅ ← Back button: Returns to Splash Screen
- ✅ [Register]: Goes to Register Page
- ✅ [Login] success: Routes to Dashboard
- ✅ [Login] fail: Shows error, stays on page
- ✅ [Forgot password]: Link (optional feature)

---

### **4. REGISTER PAGE** `/register`
**User Registration (Dual Role)**

```
┌──────────────────────────────┐
│ ← [Back to Login]            │
├──────────────────────────────┤
│  [Student] [Teacher] ← Tabs  │
├──────────────────────────────┤
│                              │
│  STUDENT TAB:                │
│  ┌────────────────────────┐  │
│  │ [First Name]           │  │
│  │ [Last Name]            │  │
│  │ [School/College]       │  │
│  │ [Class]                │  │
│  │ [Gender Dropdown]      │  │
│  │ [Email]                │  │
│  │ [Password]             │  │
│  │ [Confirm Password]     │  │
│  │ [Register Button]      │  │
│  └────────────────────────┘  │
│         ↓                    │
│    Success: Student Dashboard
│    Error: Show message       │
│                              │
│  TEACHER TAB:                │
│  ┌────────────────────────┐  │
│  │ [First Name]           │  │
│  │ [Last Name]            │  │
│  │ [College]              │  │
│  │ [Education Level]      │  │
│  │ [University]           │  │
│  │ [Interest]             │  │
│  │ [Phone Number]         │  │
│  │ [Gender Dropdown]      │  │
│  │ [Email]                │  │
│  │ [Password]             │  │
│  │ [Confirm Password]     │  │
│  │ [Register Button]      │  │
│  └────────────────────────┘  │
│         ↓                    │
│    Success: Teacher Profile Setup
│    Error: Show message       │
│                              │
└──────────────────────────────┘
```

**Navigation From Here**:
- ✅ ← Back button: Returns to Login Page
- ✅ [Register] success: Routes to Dashboard/Profile Setup
- ✅ [Register] error: Shows error, stays on form
- ✅ Tab switching: Student ↔ Teacher

---

### **5. TEACHER PROFILE SETUP** `/teacher-profile-setup`
**Teacher-specific Setup** (After teacher registration)

```
┌────────────────────────────┐
│  Teacher Profile Setup     │
│  (Custom configuration)    │
│                            │
│  [Profile fields...]       │
│  [Upload image]            │
│  [Save Profile]            │
└────────────────────────────┘
         ↓
    Teacher Dashboard
```

**Navigation From Here**:
- ✅ [Save]: Goes to Teacher Dashboard

---

### **6. DASHBOARDS** (Role-based)
**User Main Interface**

```
┌─────────────────────────────┐
│  STUDENT DASHBOARD          │
│  /student-dashboard         │
│                             │
│  [Profile]  [Courses]       │
│  [Progress] [Schedule]      │
│  [Messages] [Settings]      │
│                             │
│  [Logout] → Splash Screen   │
└─────────────────────────────┘

┌─────────────────────────────┐
│  TEACHER DASHBOARD          │
│  /teacher-dashboard         │
│                             │
│  [My Classes]  [Students]   │
│  [Assignments] [Schedule]   │
│  [Messages]    [Settings]   │
│                             │
│  [Logout] → Splash Screen   │
└─────────────────────────────┘

┌─────────────────────────────┐
│  ADMIN DASHBOARD            │
│  /admin-dashboard           │
│                             │
│  [Users]       [Analytics]  │
│  [Classes]     [Reports]    │
│  [Settings]    [Logs]       │
│                             │
│  [Logout] → Splash Screen   │
└─────────────────────────────┘
```

**Navigation From Here**:
- ✅ [Logout]: Returns to Splash Screen
- ✅ Menu navigation: Stay within dashboard

---

## 🔗 **Route Reference**

| Screen | Route | File | Purpose |
|--------|-------|------|---------|
| Splash | `/splash` | `splash_screen.dart` | Entry point, auth check |
| Login | `/login` | `login_screen.dart` | User authentication |
| Register | `/register` | `register_screen.dart` | New user registration |
| Teacher Setup | `/teacher-profile-setup` | `teacher_profile_setup_screen.dart` | Teacher configuration |
| Student DB | `/student-dashboard` | `student_dashboard_screen.dart` | Student interface |
| Teacher DB | `/teacher-dashboard` | `teacher_dashboard_screen.dart` | Teacher interface |
| Admin DB | `/admin-dashboard` | `admin_dashboard_screen.dart` | Admin interface |

---

## 🔐 **Authentication Flow**

```
┌─────────────────────────────────────┐
│    First Time User (New Account)    │
└──────────────┬──────────────────────┘
               │
               ▼
         [Splash Screen]
            ↓ 3 sec
         [No User Found]
            ↓
      [Role Selection]
      [Click Student/Teacher]
            ↓
         [Login Page]
      [Click Register]
            ↓
      [Register Page]
      [Fill Form + Register]
            ↓
      Check: Passwords match?
      Check: Email valid?
      Check: All required fields filled?
            │
      ┌─────┴─────┐
      │           │
     YES         NO
      │           │
      ▼           ▼
    [API      [Show Error]
    Register]  [Stay on form]
      │           
      ▼           
    Success       
      │
      ├─ Student → Student Dashboard
      └─ Teacher → Profile Setup → Teacher Dashboard
```

```
┌─────────────────────────────────────┐
│    Returning User (Has Account)     │
└──────────────┬──────────────────────┘
               │
               ▼
         [Splash Screen]
         [Auth Check]
            ↓ 3 sec
         [User Found]
            │
         Dashboard
         (by role)
            ├─ Admin → Admin Dashboard
            ├─ Teacher → Teacher Dashboard
            └─ Student → Student Dashboard
```

```
┌─────────────────────────────────────┐
│    Existing User Login (Logout)     │
└──────────────┬──────────────────────┘
               │
               ▼
         [Splash Screen]
         [Auth Check]
            ↓ 3 sec
      [No User Found]
         [Role Selection]
      [Click Student/Teacher]
            ↓
         [Login Page]
      [Enter Credentials]
            │
      ┌─────┴─────┐
      │           │
    Valid     Invalid
      │           │
      ▼           ▼
    [API      [Show Error]
    Login]    [Clear password]
      │       [Stay on page]
      ▼           
    Success       
      │
   Dashboard
   (by role)
```

---

## 📊 **Route States**

| State | User | Action | Route |
|-------|------|--------|-------|
| Fresh Install | None | Opens app | Splash |
| Auth Check | None | After 3s | Role Selection |
| New User | None | Click register | Register |
| Register Success | New | After register | Dashboard/Setup |
| Login | None | Click login | Login |
| Login Success | Existing | After login | Dashboard |
| Logged In | Existing | Opens app | Dashboard (auto) |
| Logout | Existing | Click logout | Splash |

---

## 🎯 **Quick Navigation Paths**

### **Path 1: New Student User**
```
Splash (3s) → Role Selection → Login → Register → Fill Student Form 
→ [Register] → Student Dashboard
```

### **Path 2: New Teacher User**
```
Splash (3s) → Role Selection → Login → Register → Fill Teacher Form 
→ [Register] → Teacher Profile Setup → Teacher Dashboard
```

### **Path 3: Returning Student User**
```
Splash (3s) → [User found] → Student Dashboard (auto)
```

### **Path 4: Returning Teacher User**
```
Splash (3s) → [User found] → Teacher Dashboard (auto)
```

### **Path 5: Switch Roles**
```
Dashboard → [Logout] → Splash (3s) → Role Selection → Login (different role)
```

### **Path 6: Go Back from Login**
```
Login → [← Back] → Splash → Role Selection (can choose again)
```

### **Path 7: Go Back from Register**
```
Register → [← Back] → Login
```

---

## 💻 **Code Navigation**

```dart
// Navigate to register from login
Navigator.pushNamed(context, AppRoutes.register);

// Go back to previous screen
Navigator.pop(context);

// Go back to splash (replace)
Navigator.pushReplacementNamed(context, AppRoutes.splash);

// Go to dashboard after login
Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);

// Go to teacher setup after registration
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const TeacherProfileSetupScreen(),
  ),
);
```

---

## ✅ **Navigation Checklist**

- [x] Splash → Role Selection works
- [x] Role Selection → Login works
- [x] Login → Register works
- [x] Login ← Back works
- [x] Register ← Back works
- [x] Register → Dashboard works
- [x] Register → Profile Setup works
- [x] Dashboard Logout → Splash works
- [x] Tab switching works (Register)
- [x] Password visibility toggle works
- [x] Form validation works
- [x] Error handling works
- [x] Loading states work

---

**Status**: ✅ COMPLETE NAVIGATION  
**Date**: November 27, 2025  
**All Routes**: Functional
