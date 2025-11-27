# Home Screen Visual Guide & Quick Reference

## Screen Layout Structure

```
┌─────────────────────────────────────┐
│         EduTutor App Bar            │
│ (Home | Classes | Payments | Profile)
├─────────────────────────────────────┤
│                                     │
│   ┌─ Welcome Header Card ──┐       │
│   │ Welcome Back!          │       │
│   │ Student Name           │       │
│   └────────────────────────┘       │
│                                     │
│   Quick Stats (2x2 Grid)            │
│   ┌──────────────┬──────────────┐   │
│   │ Classes: 3   │ Pending: 2   │   │
│   ├──────────────┼──────────────┤   │
│   │ Due: $150    │ GPA: 3.8     │   │
│   └──────────────┴──────────────┘   │
│                                     │
│   Quick Actions                     │
│   ┌────────────────────────────┐   │
│   │ 💰 Make Payment            │   │
│   │    View and pay invoices   │   │
│   └────────────────────────────┘   │
│   ┌────────────────────────────┐   │
│   │ 📊 View Results            │   │
│   │    Check exam results      │   │
│   └────────────────────────────┘   │
│   ┌────────────────────────────┐   │
│   │ 📈 Progress Report         │   │
│   │    Track your progress     │   │
│   └────────────────────────────┘   │
│   ┌────────────────────────────┐   │
│   │ 📅 Class Schedule          │   │
│   │    View timetable          │   │
│   └────────────────────────────┘   │
│                                     │
│   Recent Announcements              │
│   ┌────────────────────────────┐   │
│   │ Exam Schedule Released     │   │
│   │ Final exams will be held   │   │
│   │ from Dec 10-20...          │   │
│   │ 2 days ago                 │   │
│   └────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  🏠 Home | 📚 Classes | 💳 Payments │ Profile
│         (Bottom Navigation Bar)      │
└─────────────────────────────────────┘
```

## Tab Views

### 1. Home Tab (Default)
**Features:**
- Welcome header with gradient background
- Quick stats cards (2-column grid)
- Action buttons for common tasks
- Recent announcements section
- Single-column scrollable layout

**Colors:**
- Background: White (#FFFFFF)
- Header Gradient: Blue (#1976D2 → #1565C0)
- Icons: Blue accents
- Text: Dark gray/black

---

### 2. Classes Tab
**Features:**
- List of enrolled classes
- Each class card shows:
  - Class title
  - Instructor name
  - Schedule/timing
  - Progress bar with percentage
- Scrollable list

**Card Elements:**
```
┌─────────────────────────────────┐
│ Mathematics 101                 │
│ 👤 Dr. Smith                    │
│ 📅 Mon, Wed, Fri - 10:00 AM    │
│ ██████░░░░░░░░░░░░░░ 75%      │
└─────────────────────────────────┘
```

---

### 3. Payments Tab
**Features:**
- Alert card showing pending payment
  - Amount due: $150.00
  - Quick "Pay Now" button
- Payment history section
- Each history item shows:
  - Payment type
  - Amount
  - Date
  - Status badge (Paid/Pending)

**Alert Design:**
```
┌─────────────────────────────────┐
│ ⚠️  Pending Payment              │
│ Amount Due: $150.00    [Pay Now]│
└─────────────────────────────────┘
```

**History Item:**
```
┌─────────────────────────────────┐
│ Tuition Fee           $500.00   │
│ Nov 15, 2025         [✓ Paid]  │
└─────────────────────────────────┘
```

---

### 4. Profile Tab
**Features:**
- User avatar with initials
- Name and email display
- Clickable menu items:
  - Edit Profile
  - Change Password
  - Notifications
  - Help & Support
  - About
- Menu items have arrow indicators

**Profile Header:**
```
┌─────────────────────────────────┐
│           ┌─────┐               │
│           │  S  │ (Avatar)      │
│           └─────┘               │
│                                 │
│     Student Full Name           │
│     student@email.com           │
└─────────────────────────────────┘
```

**Menu Item:**
```
┌─────────────────────────────────┐
│ 👤 Edit Profile            →    │
├─────────────────────────────────┤
│ 🔒 Change Password         →    │
├─────────────────────────────────┤
│ 🔔 Notifications           →    │
└─────────────────────────────────┘
```

---

## Color Palette

| Element | Color | Hex Code |
|---------|-------|----------|
| Primary Blue | Blue | #1976D2 |
| Dark Blue | Darker Blue | #1565C0 |
| Light Blue | Light Blue | #E3F2FD |
| Success Green | Green | #4CAF50 |
| Warning Red | Red | #F44336 |
| Info Orange | Orange | #FF9800 |
| Background | White | #FFFFFF |
| Text Primary | Dark Gray | #212121 |
| Text Secondary | Gray | #757575 |
| Border | Light Gray | #BDBDBD |
| Disabled | Very Light Gray | #EEEEEE |

---

## Navigation Flow

```
┌─────────────────────────────────────────────────┐
│                 Login Screen                    │
│         (UserRole.student selected)             │
└─────────────────┬───────────────────────────────┘
                  │
                  ├──→ Student Login
                  │
                  │
┌─────────────────▼───────────────────────────────┐
│         ✨ HOME SCREEN (NEW) ✨                │
├─────────────────────────────────────────────────┤
│                                                 │
│ Bottom Navigation:                              │
│ ├─→ Home Tab (Current)                         │
│ ├─→ Classes Tab                                │
│ ├─→ Payments Tab                               │
│ └─→ Profile Tab                                │
│                                                 │
│ Action Buttons from Home Tab:                   │
│ ├─→ Make Payment → StudentPaymentScreen        │
│ ├─→ View Results → ViewResultsScreen           │
│ ├─→ Progress Report → ProgressReportScreen     │
│ └─→ Class Schedule → ClassScheduleScreen       │
│                                                 │
│ Profile Menu Items:                             │
│ ├─→ Edit Profile (TODO)                        │
│ ├─→ Change Password (TODO)                     │
│ ├─→ Notifications (TODO)                       │
│ ├─→ Help & Support (TODO)                      │
│ └─→ About (TODO)                               │
│                                                 │
│ App Bar:                                        │
│ └─→ Logout Button → Returns to Login           │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## Widget Component Tree

```
HomeScreen (StatefulWidget)
├── Scaffold
│   ├── AppBar
│   │   ├── Title: "EduTutor"
│   │   ├── Logout Button
│   │   └── Profile Button
│   ├── Body (SingleChildScrollView)
│   │   └── Column
│   │       ├── Welcome Card
│   │       ├── Quick Stats (Grid)
│   │       │   ├── StatCard (Classes)
│   │       │   ├── StatCard (Pending)
│   │       │   ├── StatCard (Due Payment)
│   │       │   └── StatCard (GPA)
│   │       ├── Quick Actions Section
│   │       │   ├── ActionButton (Payment)
│   │       │   ├── ActionButton (Results)
│   │       │   ├── ActionButton (Progress)
│   │       │   └── ActionButton (Schedule)
│   │       └── Announcements Section
│   │           └── Announcement Card
│   └── BottomNavigationBar
│       ├── Home Item
│       ├── Classes Item
│       ├── Payments Item
│       └── Profile Item
```

---

## Key Interactions

### Bottom Navigation
- **Tap Tab** → Switches between 4 main sections
- **Visual Feedback** → Selected tab highlighted in blue
- **State Persisted** → Remains on selected tab

### Action Buttons
- **On Tap** → Navigate to specific screen
- **Visual Feedback** → Color change on press
- **Icons** → Indicate button purpose

### Logout
- **On Tap** → Sign out from Firebase
- **Navigation** → Return to LoginScreen
- **Confirmation** → Optional implementation

### Profile Menu
- **On Tap** → Navigate to respective screen
- **Arrow Indicator** → Shows navigation available
- **Clear Labels** → Descriptive menu items

---

## Responsive Behavior

- **Padding**: Consistent 16pt horizontal margins
- **Scrolling**: SingleChildScrollView for overflow content
- **Grid**: 2-column layout for stats (scales with device)
- **Spacing**: Proportional gaps using SizedBox
- **Text**: Uses Theme.of(context) for scalable typography

---

## State Management

### Managed Variables:
- `currentUser` - Current Firebase user
- `userModel` - User data loaded from Firestore
- `_selectedIndex` - Currently selected bottom nav tab

### Data Loading:
```dart
Future<void> _loadUserData() {
  // Loads user data from Firestore using currentUser.uid
}
```

---

## Testing Checklist

- [ ] App launches to HomeScreen after student login
- [ ] Bottom navigation tabs switch views smoothly
- [ ] User name and email display correctly
- [ ] All action buttons navigate to correct screens
- [ ] Logout button signs out user
- [ ] Profile menu items clickable
- [ ] Responsive on small/large devices
- [ ] No layout overflow issues
- [ ] Images/avatars load properly
- [ ] Animations smooth (navigation transitions)

---

## Quick Access Routes

| Action | Route | Constants |
|--------|-------|-----------|
| Login → Home | /student-home | `AppRoutes.studentHome` |
| Make Payment | /student-payments | `AppRoutes.studentPayments` |
| View Results | /student-results | `AppRoutes.studentResults` |
| Progress | /student-progress | `AppRoutes.studentProgress` |
| Schedule | /student-schedule | `AppRoutes.studentSchedule` |
| Admin Dashboard | /admin-dashboard | `AppRoutes.adminDashboard` |
| Teacher Dashboard | /teacher-dashboard | `AppRoutes.teacherDashboard` |

---

**This guide provides a complete visual and functional overview of the HomeScreen implementation.**
