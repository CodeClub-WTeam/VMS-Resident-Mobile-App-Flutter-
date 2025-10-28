import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vms_resident_app/src/features/auth/providers/auth_provider.dart';
import 'package:vms_resident_app/src/features/visitor_codes/screens/generate_code_screen.dart';
import 'package:vms_resident_app/src/features/auth/presentation/pages/profile_screen.dart';
import 'package:vms_resident_app/src/features/visitor_codes/screens/history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final resident = authProvider.resident;

    if (resident == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.amber),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          "Welcome, ${resident.firstName}",
          style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amberAccent, width: 2),
              ),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.amber, size: 26),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏠 Greeting section
              Text(
                "Glad to have you back, ${resident.firstName}! 👋",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Manage your visitors and view your history easily below.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
              ),

              const SizedBox(height: 35),

              // ⚡ Quick Actions
              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 18),

              // 🎯 Animated Quick Actions
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    alignment: WrapAlignment.center,
                    children: [
                      _ModernActionCard(
                        icon: Icons.qr_code_2_rounded,
                        label: "Generate Code",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GenerateCodeScreen(),
                            ),
                          );
                        },
                      ),
                      _ModernActionCard(
                        icon: Icons.history_rounded,
                        label: "My History",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VisitHistoryScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🌟 Modernized Action Button
class _ModernActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ModernActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ModernActionCard> createState() => _ModernActionCardState();
}

class _ModernActionCardState extends State<_ModernActionCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: _isHovered ? Colors.amber.shade700 : Colors.amber.shade400,
        borderRadius: BorderRadius.circular(18),
        boxShadow: _isHovered
            ? [
                BoxShadow(
color: Colors.amber.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering) => setState(() => _isHovered = hovering),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 130,
          width: 140,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Colors.black,
                size: 45,
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
