import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vms_resident_app/src/features/auth/providers/auth_provider.dart';
import 'package:vms_resident_app/src/features/auth/presentation/pages/login_page.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Local state for settings that change in the UI
  bool _notificationsEnabled = true; 
  String _selectedLanguage = 'English'; 

  // Helper to safely get the primary color
  Color get _primaryColor => Theme.of(context).primaryColor;

  // FIX: Removed BuildContext context argument. 
  // Now using State.context property, which is implicitly guarded by 'mounted'.
  void _handleLogout() async {
    // Use the State's context property to read the provider before the async gap.
    // This is generally accepted as long as the state is only read, not used for navigation/UI.
    final authProvider = context.read<AuthProvider>();
    
    // Perform the async operation
    await authProvider.logout();

    // Guard the UI/Navigation use with 'mounted' check
    if (!mounted) return;

    // Use the State's context property for navigation after the check
    if (!authProvider.isLoggedIn) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          LoginPage.routeName, (Route<dynamic> route) => false);
    }
  }

  // Handles the 'Edit' button action (Implemented placeholder logic)
  void _handleEditAction(String field, BuildContext context) {
    debugPrint('📝 Edit action triggered for: $field');
    // Placeholder logic: Show a simple Snackbar confirmation.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped Edit for $field. Implementation pending.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final resident = authProvider.resident;

    final String userName = resident?.fullName ?? 'Loading...';
    final String userEmail = resident?.email ?? 'No email';
    final String userRole = resident?.role ?? 'Resident';
    final String? profileImage = resident?.profilePicture;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('EstateGuard'),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Text('My Profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: profileImage != null
                        ? NetworkImage(profileImage)
                        : null,
                    backgroundColor: Colors.grey,
                    child: profileImage == null
                        ? const Icon(Icons.person, size: 40, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        userEmail,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        'Role: $userRole',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            _buildSectionHeader(context, 'Account Settings'),
            
            // Username Setting Tile
            _buildSettingTile(
              title: 'Username:',
              value: userName,
              context: context,
              onEditPressed: () => _handleEditAction('Username', context),
              showDivider: true,
            ),
            
            // Password Setting Tile
            _buildSettingTile(
              title: 'Password:',
              value: '••••••••',
              context: context,
              onEditPressed: () => _handleEditAction('Password', context),
              showDivider: true,
            ),
            
            // Notifications Toggle
            _buildToggleSetting(
              title: 'Notifications',
              value: _notificationsEnabled, 
              onChanged: (bool newValue) {
                setState(() {
                  _notificationsEnabled = newValue;
                });
              },
              showDivider: true,
            ),
            
            // Language Setting
            _buildLanguageSetting(
              title: 'Language',
              value: _selectedLanguage, 
              context: context,
              onChanged: (String? newValue) {
                if (newValue != null && newValue != _selectedLanguage) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                }
              },
            ),
            
            const SizedBox(height: 30),
            
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // FIX: Removed the 'context' argument from the call
                  onPressed: () => _handleLogout(), 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Logout',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // -------------------------
  // Helper Widgets
  // -------------------------
  
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0, bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
      ),
    );
  }

  // Helper widget for editable tiles
  Widget _buildSettingTile({
    required String title,
    required String value,
    required BuildContext context,
    required VoidCallback onEditPressed,
    bool showDivider = false,
  }) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              Row(
                children: [
                  Text(value,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: onEditPressed,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(60, 30),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Edit', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 24, endIndent: 24),
      ],
    );
  }

  // Helper widget for a toggle setting 
  Widget _buildToggleSetting({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool showDivider = false,
  }) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: Colors.blue, 
                activeTrackColor: Colors.blue.shade200, 
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 24, endIndent: 24),
      ],
    );
  }

  // Helper widget for the language dropdown
  Widget _buildLanguageSetting({
    required String title,
    required String value,
    required BuildContext context,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                icon: const Icon(Icons.arrow_drop_down),
                items: <String>['English', 'Spanish', 'French']
                    .map((val) => DropdownMenuItem<String>(
                          value: val,
                          child: Text(val, style: const TextStyle(fontSize: 16)),
                        ))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}