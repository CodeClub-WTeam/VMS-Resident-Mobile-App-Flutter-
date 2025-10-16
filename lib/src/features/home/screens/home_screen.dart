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
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Welcome, ${resident.firstName}",
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 👋 Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Glad to have you back, ${resident.firstName}!",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),

                GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  },
  child: CircleAvatar(
    radius: 25,
    backgroundColor: Colors.blue.shade100,
    child: Icon(Icons.person, color: Colors.blue.shade800, size: 28),
  ),
),

                ],
              ),

              const SizedBox(height: 30),

              // ⚡ Quick Actions
              Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),

              // ✅ Make Row Responsive
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 360) {
                    // For small devices, wrap actions
                    return Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _ActionButton(
                          icon: Icons.qr_code_2,
                          label: "Generate Code",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const GenerateCodeScreen(),
                              ),
                            );
                          },
                        ),
                        _ActionButton(
                          icon: Icons.history,
                          label: "My History",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const VisitHistoryScreen(),
                              ),
                            );
                          },
                        ),
                        
                      ],
                    );
                  } else {
                    // For normal or wide screens
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ActionButton(
                          icon: Icons.qr_code_2,
                          label: "Generate Code",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const GenerateCodeScreen(),
                              ),
                            );
                          },
                        ),
                        _ActionButton(
                          icon: Icons.history,
                          label: "My History",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const VisitHistoryScreen(),
                              ),
                            );
                          },
                        ),
                        
                      ],
                    );
                  }
                },
              ),

              const SizedBox(height: 30),

            
            ],
          ),
        ),
      ),
    );
  }
}

// 🎨 Reusable Components
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.blue.shade700, size: 50),
          ),
          const SizedBox(height: 15),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
