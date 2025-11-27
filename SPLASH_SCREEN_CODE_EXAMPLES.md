# 💻 Code Examples - Splash Screen Customization

## 1. Change Splash Duration

**File**: `lib/screens/auth/splash_screen.dart`

### Current (3 seconds)
```dart
void _checkAuthStatus() async {
  await Future.delayed(const Duration(seconds: 3));
  // ... navigation code
}
```

### Change to 2 seconds (faster)
```dart
await Future.delayed(const Duration(seconds: 2));
```

### Change to 5 seconds (slower)
```dart
await Future.delayed(const Duration(seconds: 5));
```

---

## 2. Change Gradient Colors

**File**: `lib/screens/auth/splash_screen.dart`

### Current Gradient (Blue)
```dart
gradient: LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    AppColors.primary,      // #0D47A1
    AppColors.secondary.withOpacity(0.8), // #1976D2
  ],
),
```

### Purple Gradient
```dart
colors: [
  const Color(0xFF7B1FA2), // Deep Purple
  const Color(0xFFAB47BC), // Light Purple
],
```

### Green Gradient
```dart
colors: [
  const Color(0xFF1B5E20), // Dark Green
  const Color(0xFF43A047), // Light Green
],
```

### Red/Orange Gradient
```dart
colors: [
  const Color(0xFFD32F2F), // Red
  const Color(0xFFFF6F00), // Orange
],
```

### Teal Gradient
```dart
colors: [
  const Color(0xFF00695C), // Dark Teal
  const Color(0xFF00897B), // Light Teal
],
```

---

## 3. Change Logo Icon

**File**: `lib/screens/auth/splash_screen.dart` (in `_buildSplashContent`)

### Current
```dart
child: const Icon(
  Icons.school,
  size: 70,
  color: AppColors.primary,
),
```

### Other Options

**Lightbulb (Innovation)**
```dart
child: const Icon(
  Icons.lightbulb,
  size: 70,
  color: AppColors.primary,
),
```

**Rocket (Growth)**
```dart
child: const Icon(
  Icons.rocket_launch,
  size: 70,
  color: AppColors.primary,
),
```

**Brain (Learning)**
```dart
child: const Icon(
  Icons.psychology,
  size: 70,
  color: AppColors.primary,
),
```

**Star (Excellence)**
```dart
child: const Icon(
  Icons.star,
  size: 70,
  color: AppColors.primary,
),
```

**Book (Education)**
```dart
child: const Icon(
  Icons.auto_stories,
  size: 70,
  color: AppColors.primary,
),
```

**Globe (Digital)**
```dart
child: const Icon(
  Icons.public,
  size: 70,
  color: AppColors.primary,
),
```

---

## 4. Add Custom Image Logo

### Step 1: Add Image to Project
```
assets/
  images/
    logo.png (add your logo here)
    student_cartoon.png
    teacher_cartoon.png
```

### Step 2: Update pubspec.yaml
```yaml
flutter:
  assets:
    - assets/images/logo.png
    - assets/images/student_cartoon.png
    - assets/images/teacher_cartoon.png
```

### Step 3: Replace Logo Icon with Image

In `_buildSplashContent()` method, replace:
```dart
Container(
  width: 120,
  height: 120,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white.withOpacity(0.95),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  ),
  child: const Center(
    child: Icon(
      Icons.school,
      size: 70,
      color: AppColors.primary,
    ),
  ),
),
```

**With this:**
```dart
ScaleTransition(
  scale: _scaleAnimation,
  child: Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(0.95),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: ClipOval(
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.cover,
      ),
    ),
  ),
),
```

---

## 5. Add Cartoon Images to Feature Cards

### Current Feature Cards
```dart
_buildFeatureCard(
  Icons.person_3,
  'Students',
  Colors.cyan,
),
```

### Add Cartoon Images

First, create new method for image cards:
```dart
Widget _buildFeatureImageCard(String imagePath, String label, Color color) {
  return Column(
    children: [
      Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white.withOpacity(0.9),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
```

Then use it in the Row:
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    _buildFeatureImageCard(
      'assets/images/student_cartoon.png',
      'Students',
      Colors.cyan,
    ),
    _buildFeatureImageCard(
      'assets/images/teacher_cartoon.png',
      'Teachers',
      Colors.orange,
    ),
    _buildFeatureImageCard(
      'assets/images/admin_cartoon.png',
      'Admin',
      Colors.pinkAccent,
    ),
  ],
),
```

---

## 6. Change Animation Speed

### Logo Animation Faster

Current (2 seconds):
```dart
_scaleController = AnimationController(
  duration: const Duration(milliseconds: 2000),
  vsync: this,
);
```

Make it faster (1.5 seconds):
```dart
_scaleController = AnimationController(
  duration: const Duration(milliseconds: 1500),
  vsync: this,
);
```

### Text Animation Slower

Current (1.5 seconds):
```dart
_fadeController = AnimationController(
  duration: const Duration(milliseconds: 1500),
  vsync: this,
);
```

Make it slower (2 seconds):
```dart
_fadeController = AnimationController(
  duration: const Duration(milliseconds: 2000),
  vsync: this,
);
```

---

## 7. Change Loading Indicator

### Current (Circular Spinner)
```dart
const CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  strokeWidth: 3,
),
```

### Linear Progress Bar
```dart
LinearProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  backgroundColor: Colors.white.withOpacity(0.2),
),
```

### Custom Styled Spinner
```dart
SizedBox(
  width: 50,
  height: 50,
  child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    strokeWidth: 4,
    backgroundColor: Colors.white.withOpacity(0.2),
  ),
),
```

---

## 8. Change Loading Text

Current:
```dart
Text(
  'Loading...',
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    color: Colors.white.withOpacity(0.8),
    fontSize: 14,
  ),
),
```

### Options:

**Show percentage (if you track progress):**
```dart
Text(
  'Loading... 25%',
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    color: Colors.white.withOpacity(0.8),
    fontSize: 14,
  ),
),
```

**Typing effect (requires animation):**
```dart
Text(
  'Initializing...',
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    color: Colors.white.withOpacity(0.8),
    fontSize: 14,
  ),
),
```

**Multiple messages rotating:**
```dart
Text(
  _loadingMessage, // Change this variable
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    color: Colors.white.withOpacity(0.8),
    fontSize: 14,
  ),
),
```

---

## 9. Add Different Animation Curves

### Current Logo Animation
```dart
CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
```

### Other Curve Options

**Smooth/Linear:**
```dart
CurvedAnimation(parent: _scaleController, curve: Curves.linear),
```

**Bouncy:**
```dart
CurvedAnimation(parent: _scaleController, curve: Curves.bounceOut),
```

**Accelerate:**
```dart
CurvedAnimation(parent: _scaleController, curve: Curves.easeInQuad),
```

**Decelerate:**
```dart
CurvedAnimation(parent: _scaleController, curve: Curves.easeOutQuad),
```

**Ease In Out:**
```dart
CurvedAnimation(parent: _scaleController, curve: Curves.easeInOutCubic),
```

---

## 10. Change Feature Card Icons

### Current
```dart
child: Icon(
  Icons.person_3,
  size: 40,
  color: Colors.white,
),
```

### Student Options
```dart
Icons.person_4,         // Another person icon
Icons.groups,           // Group of people
Icons.school,           // School
Icons.book,             // Book
Icons.reading,          // Reading
```

### Teacher Options
```dart
Icons.person_2,         // Current
Icons.psychology,       // Brain/Mind
Icons.lightbulb,        // Lightbulb
Icons.campaign,         // Announce
Icons.how_to_reg,       // Certification
```

### Admin Options
```dart
Icons.admin_panel_settings,  // Current
Icons.settings,              // Settings
Icons.security,              // Security
Icons.dashboard,             // Dashboard
Icons.manage_accounts,       // Manage accounts
```

---

## 11. Change Role Selection Button Design

### Current Style
```dart
_buildRoleButton(
  icon: Icons.person_3,
  title: 'Login as Student',
  subtitle: 'Access your courses and progress',
  color: Colors.cyan,
  onTap: () {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  },
),
```

### Make Button Larger
In `_buildRoleButton` method, increase padding:
```dart
padding: const EdgeInsets.all(24), // Was 16
```

### Add Button Color Overlay
In button Container, change colors:
```dart
container = Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: color.withOpacity(0.2), // Was 0.15
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: color.withOpacity(0.5), // Was white opacity
      width: 2, // Was 1.5
    ),
  ),
  // ...
);
```

---

## 12. Disable Role Selection Screen

If you want to skip role selection and always go to login:

Replace `_checkAuthStatus`:
```dart
void _checkAuthStatus() async {
  await Future.delayed(const Duration(seconds: 3));

  if (!mounted) return;

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
    // Always go to login (skip role selection)
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}
```

Then remove the role selection UI from build:
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary.withOpacity(0.8),
          ],
        ),
      ),
      child: _buildSplashContent(), // Remove the ternary operator
    ),
  );
}
```

---

## 13. Add App Version Display

Add this to bottom of splash screen:

```dart
Positioned(
  bottom: 20,
  left: 0,
  right: 0,
  child: Center(
    child: Text(
      'Version 1.0.0',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Colors.white.withOpacity(0.6),
        fontSize: 12,
      ),
    ),
  ),
),
```

---

## 14. Add Privacy/Terms Link

Add at bottom of role selection:

```dart
TextButton(
  onPressed: () {
    // Open privacy policy
  },
  child: Text(
    'Privacy Policy & Terms',
    style: Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Colors.white.withOpacity(0.7),
      decoration: TextDecoration.underline,
    ),
  ),
),
```

---

## 15. Change Feature Card Colors

Current:
```dart
_buildFeatureCard(Icons.person_3, 'Students', Colors.cyan),
_buildFeatureCard(Icons.person_2, 'Teachers', Colors.orange),
_buildFeatureCard(Icons.admin_panel_settings, 'Admin', Colors.pinkAccent),
```

### Use Custom Colors
```dart
_buildFeatureCard(Icons.person_3, 'Students', const Color(0xFF4CAF50)), // Green
_buildFeatureCard(Icons.person_2, 'Teachers', const Color(0xFF2196F3)), // Blue
_buildFeatureCard(Icons.admin_panel_settings, 'Admin', const Color(0xFFFFC107)), // Amber
```

### Use Your AppColors
```dart
_buildFeatureCard(Icons.person_3, 'Students', AppColors.secondary),
_buildFeatureCard(Icons.person_2, 'Teachers', AppColors.accent),
_buildFeatureCard(Icons.admin_panel_settings, 'Admin', AppColors.error),
```

---

## Complete Example: Custom Splash

Here's a complete customized example:

```dart
class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // ... existing code ...

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuthStatus();
  }

  void _setupAnimations() {
    // Faster animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000), // Faster
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500), // Faster
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  void _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Faster (was 3)

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.user != null) {
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
      setState(() {
        _showRoleSelection = true; // Show role selection
      });
    }
  }

  // ... rest of code ...
}
```

---

**Version**: 1.0  
**Last Updated**: November 27, 2025  
**Status**: ✅ COMPLETE EXAMPLES
