# Home Screen - Quick Start & Developer Guide

## Quick Overview

The HomeScreen is a new comprehensive dashboard for student users in the EduTutor mobile app. It provides:

✅ **4 main sections**: Home, Classes, Payments, Profile  
✅ **Quick stats**: Classes enrolled, pending items, due payments, GPA  
✅ **Fast navigation**: Action buttons for common tasks  
✅ **Payment alerts**: Highlight pending payments  
✅ **User info**: Display student name and profile  
✅ **Logout**: Quick logout from app bar  

## Files Overview

### Created Files:
1. **`lib/screens/student/home_screen.dart`** (Main implementation)
   - 850+ lines of code
   - StatefulWidget with bottom navigation
   - 5 main methods for different tabs

### Modified Files:
1. **`lib/routes/app_routes.dart`**
   - Added: `import '../screens/student/home_screen.dart';`
   - Added: `static const String studentHome = '/student-home';`
   - Added: Route mapping in the routes Map

2. **`lib/screens/auth/login_screen.dart`**
   - Changed student role navigation from `studentDashboard` to `studentHome`

## Component Structure

```
HomeScreen (Main Widget)
├── initState()
│   └── Load user data from Firestore
├── _loadUserData() - Fetch user from database
├── _logout() - Sign out and return to login
├── _buildBody() - Switch between 4 tabs
├── _buildHomeTab() - Home/Dashboard view
├── _buildClassesTab() - Classes list
├── _buildPaymentsTab() - Payments & history
├── _buildProfileTab() - User profile
└── Helper Widgets
    ├── _buildStatCard()
    ├── _buildActionButton()
    ├── _buildClassCard()
    ├── _buildPaymentHistoryItem()
    └── _buildProfileMenuItem()
```

## Method Reference

### Main Lifecycle

```dart
@override
void initState() {
  // Called when widget is created
  currentUser = FirebaseAuth.instance.currentUser;
  _loadUserData();
}

Future<void> _loadUserData() {
  // Loads user data from Firestore collection 'users'
  // Sets userModel state
}

void _logout() {
  // Signs out from Firebase
  // Navigates back to login screen
}
```

### Tab Building

```dart
Widget _buildBody() {
  // Routes to correct tab based on _selectedIndex
}

Widget _buildHomeTab() {
  // Home/Dashboard with stats and quick actions
}

Widget _buildClassesTab() {
  // List of enrolled classes with progress
}

Widget _buildPaymentsTab() {
  // Payment alerts and history
}

Widget _buildProfileTab() {
  // User profile and settings
}
```

### Helper Widgets

```dart
// Displays stats in grid format
Widget _buildStatCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
})

// Action button with icon and navigation
Widget _buildActionButton(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
})

// Class card with progress bar
Widget _buildClassCard(
  BuildContext context, {
  required String title,
  required String teacher,
  required String schedule,
  required int progress,
})

// Payment history item
Widget _buildPaymentHistoryItem({
  required String title,
  required String amount,
  required String date,
  required String status,
  required Color statusColor,
})

// Profile menu items
Widget _buildProfileMenuItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
})
```

## Data Model Used

### UserModel Properties
```dart
UserModel {
  String uid;              // User ID
  String email;            // Email address
  String firstName;        // First name
  String lastName;         // Last name
  String fullName;         // Computed: firstName + lastName
  String? gender;          // Gender (optional)
  UserRole role;           // Role enum (student)
  DateTime createdAt;      // Account creation date
  String? schoolName;      // Student's school
  String? classLevel;      // Student's class level
}
```

## Navigation Routes

### Route Constant
```dart
AppRoutes.studentHome = '/student-home'
```

### Usage in Navigation
```dart
// After login - automatically navigates here
Navigator.pushReplacementNamed(context, AppRoutes.studentHome);

// From HomeScreen to other screens
Navigator.pushNamed(context, AppRoutes.studentPayments);
Navigator.pushNamed(context, AppRoutes.studentResults);
Navigator.pushNamed(context, AppRoutes.studentProgress);
Navigator.pushNamed(context, AppRoutes.studentSchedule);
```

## Color System

```dart
// Primary Colors
Colors.blue[700]    // #1976D2 - Main blue
Colors.blue[500]    // #2196F3 - Lighter blue
Colors.blue[100]    // #BBDEFB - Very light blue
Colors.blue[50]     // #E3F2FD - Extremely light

// Status Colors
Colors.green        // Success (Payments)
Colors.red          // Warning (Payments Due)
Colors.orange       // Info (Pending)

// Text Colors
Colors.grey[600]    // Secondary text
Colors.grey[400]    // Tertiary text
Colors.grey[300]    // Borders
```

## Layout System

### Spacing
```dart
const EdgeInsets.all(16)              // Standard padding
const EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 20,
)                                     // Directional padding
const SizedBox(height: 12)            // Spacing between items
const SizedBox(height: 24)            // Section spacing
```

### Border Radius
```dart
BorderRadius.circular(12)   // Cards and containers
BorderRadius.circular(8)    // Smaller elements
BorderRadius.circular(4)    // Badges and status
```

## State Management Pattern

```dart
class _HomeScreenState extends State<HomeScreen> {
  // State variables
  late User? currentUser;
  late UserModel? userModel;
  int _selectedIndex = 0;

  // Use setState() to update UI
  setState(() {
    _selectedIndex = newIndex;
  });
}
```

## Firebase Integration

### Load User Data
```dart
Future<void> _loadUserData() async {
  if (currentUser != null) {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      if (doc.exists) {
        setState(() {
          userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }
}
```

### Logout
```dart
void _logout() async {
  await FirebaseAuth.instance.signOut();
  if (mounted) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }
}
```

## Common Customization Points

### Change Welcome Message
```dart
Text(
  'Welcome Back!',  // ← Change this
  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
)
```

### Update Quick Stats Values
```dart
_buildStatCard(
  title: 'Classes',
  value: '3',      // ← Change this
  icon: Icons.school,
  color: Colors.blue,
)
```

### Modify Action Buttons
```dart
_buildActionButton(
  context,
  icon: Icons.payment,           // ← Change icon
  title: 'Make Payment',         // ← Change title
  subtitle: 'View and pay invoices',  // ← Change subtitle
  onTap: () {
    Navigator.pushNamed(context, AppRoutes.studentPayments);  // ← Change navigation
  },
)
```

### Update Class List
```dart
_buildClassCard(
  context,
  title: 'Mathematics 101',      // ← Change title
  teacher: 'Dr. Smith',          // ← Change teacher
  schedule: 'Mon, Wed, Fri - 10:00 AM',  // ← Change schedule
  progress: 75,                  // ← Change progress %
)
```

## Known Limitations & TODOs

### Implemented:
✅ Basic UI and navigation  
✅ Firebase user loading  
✅ Logout functionality  
✅ Static demo data  

### Not Yet Implemented (TODOs):
🟡 Real data from Firestore for:
  - Classes list
  - GPA calculation
  - Pending payments
  - Announcements

🟡 Profile action screens:
  - Edit Profile
  - Change Password
  - Notifications settings
  - Help & Support

## Testing Quick Commands

### Test Navigation
```dart
// From login, verify student goes to:
AppRoutes.studentHome

// Tap tabs and verify switches
// Tap actions and verify navigation
```

### Test Data Loading
```dart
// Check Firestore has user with:
collection: 'users'
document: currentUser.uid
fields: firstName, lastName, email, etc.
```

### Test Logout
```dart
// Tap logout button
// Verify user returns to LoginScreen
// Verify user is signed out from Firebase
```

## Debugging Tips

### Print User Data
```dart
print('Current User: ${userModel?.fullName}');
print('User Email: ${userModel?.email}');
print('User Role: ${userModel?.role}');
```

### Check State Changes
```dart
print('Selected Index: $_selectedIndex');
print('User Model Loaded: ${userModel != null}');
```

### Monitor Navigation
```dart
// Enable navigation logging
// Add breakpoints at Navigator.pushNamed()
// Check route names in AppRoutes
```

## Performance Considerations

- **Data Loading**: Loads once in initState
- **Rebuilds**: Only on setState() calls (tab switches)
- **Images**: Uses CircleAvatar (efficient)
- **Scrolling**: SingleChildScrollView (smooth)
- **Widgets**: Stateful containers minimize rebuilds

## Security Notes

- User data loaded only for authenticated users
- Logout signs out from Firebase securely
- Routes protected by auth checks in main.dart
- Sensitive data (password) not displayed

## Future Enhancements

1. Add real-time listeners for updates
2. Implement class enrollment
3. Add payment integration
4. Create progress analytics
5. Add notifications panel
6. Implement search functionality
7. Add filters and sorting
8. Create widgets for dashboard customization

---

**For full documentation, see:**
- `HOME_SCREEN_IMPLEMENTATION.md` - Detailed implementation
- `HOME_SCREEN_VISUAL_GUIDE.md` - UI/UX design guide
- `lib/screens/student/home_screen.dart` - Full source code

**Status**: ✅ Ready for Testing
