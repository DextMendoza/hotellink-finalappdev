import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/screens/employee_management.dart';
import 'package:final_project_in_appdev/screens/attendance_manager.dart';
import 'package:final_project_in_appdev/screens/payroll_management.dart';
import 'package:final_project_in_appdev/screens/profile_page.dart';
import 'package:final_project_in_appdev/screens/login_screen.dart';
import 'package:final_project_in_appdev/utils/constants.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
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
                    icon: Icons.access_time,
                    label: 'Attendance Manager',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AttendanceManager()),
                    ),
                  ),
                  _AnimatedTile(
                    icon: Icons.receipt_long,
                    label: 'Payroll Management',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PayrollReport()),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
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
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
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

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Constants.primaryColor,
            ),
            child: Text(
              'Payroll Management',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: const Text('Employee Management'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmployeeManagement()),
              );
            },
          ),
          ListTile(
            title: const Text('Attendance Manager'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AttendanceManager()),
              );
            },
          ),
          ListTile(
            title: const Text('Payroll Report'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PayrollReport()),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
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
    );
  }
}
