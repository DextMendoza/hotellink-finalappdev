import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project_in_appdev/screens/employee_management.dart';
import 'package:final_project_in_appdev/screens/attendance_manager.dart';
import 'package:final_project_in_appdev/screens/payroll_management.dart';
import 'package:final_project_in_appdev/screens/profile_page.dart';
import 'package:final_project_in_appdev/screens/login_screen.dart';
import 'package:final_project_in_appdev/utils/constants.dart';
import 'dart:async';
import 'package:final_project_in_appdev/models/attendance_record.dart';
import 'package:final_project_in_appdev/utils/attendance_storage.dart';
import 'package:final_project_in_appdev/utils/payroll_service.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    // Main dashboard layout with gradient background and grid menu
    return Container(
      decoration: const BoxDecoration(
        gradient: Constants.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Dashboard'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            // Profile button in the app bar
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),
          ],
        ),
        drawer: const NavigationDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              final crossAxisCount = isWide ? 3 : 2;

              // Dashboard grid menu
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
                shrinkWrap: true,
                children: [
                  _AnimatedTile(
                    icon: Icons.people,
                    label: 'Employee Management',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EmployeeManagement()),
                    ),
                  ),
                  _AnimatedTile(
                    icon: Icons.note,
                    label: 'Attendance Manager',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AttendanceManager()),
                    ),
                  ),
                  _AnimatedTile(
                    icon: Icons.receipt_long,
                    label: 'Payroll Management',
                    onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PayrollReport()),
                   );
                 },
                ),
                  _DateTimeTile(), // New date/time tile
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Animated tile for dashboard grid
class _DateTimeTile extends StatefulWidget {
  const _DateTimeTile({Key? key}) : super(key: key);

  @override
  State<_DateTimeTile> createState() => _DateTimeTileState();
}

class _DateTimeTileState extends State<_DateTimeTile> {
  late String _currentTime;
  late String _currentDate;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('hh:mm:ss a').format(now);
      _currentDate = DateFormat('EEE, MMM d y').format(now);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(207, 255, 255, 255),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(54, 0, 0, 0),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.access_time, size: 48, color: Constants.primaryColor),
          const SizedBox(height: 12),
          Text(
            _currentTime,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Constants.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentDate,
            style: const TextStyle(
              fontSize: 16,
              color: Constants.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AnimatedTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_AnimatedTile> createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<_AnimatedTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation = _controller.drive(Tween(begin: 1.0, end: 0.95));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.reverse();
  void _onTapUp(_) => _controller.forward();

  @override
  Widget build(BuildContext context) {
    // Tile with scale animation on tap
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (details) {
        _onTapUp(details);
        widget.onTap();
      },
      onTapCancel: _controller.forward,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(221, 255, 255, 255),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(57, 0, 0, 0),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 48, color: Constants.primaryColor),
              const SizedBox(height: 12),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Constants.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Drawer for navigation between app sections
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
     // Drawer with navigation options
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Constants.primaryColor,
              image: DecorationImage(
                image: AssetImage('assets/images/drawer_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: const [
                  Icon(Icons.lock_clock, color: Colors.white, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'HotelLink HRIS',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _AnimatedDrawerTile(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  onTap: () => Navigator.pop(context),
                ),
                _AnimatedDrawerTile(
                  icon: Icons.people,
                  label: 'Employee Management',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EmployeeManagement()),
                    );
                  },
                ),
                _AnimatedDrawerTile(
                  icon: Icons.access_time,
                  label: 'Attendance Manager',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AttendanceManager()),
                    );
                  },
                ),
                _AnimatedDrawerTile(
                  icon: Icons.receipt_long,
                    label: 'Payroll Management',
                      onTap: () {
                      Navigator.pop(context);
                        Navigator.push(
                          context,
                           MaterialPageRoute(builder: (context) => const PayrollReport()),
                      );
                    },
                  ),
                _AnimatedDrawerTile(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Animated tile for drawer navigation
class _AnimatedDrawerTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AnimatedDrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_AnimatedDrawerTile> createState() => _AnimatedDrawerTileState();
}

class _AnimatedDrawerTileState extends State<_AnimatedDrawerTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Drawer tile with slide and fade animation
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ListTile(
          leading: Icon(widget.icon, color: Constants.primaryColor),
          title: Text(widget.label),
          onTap: widget.onTap,
        ),  
      ),
    );
  }
}
