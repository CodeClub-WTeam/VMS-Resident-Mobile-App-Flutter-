// lib/src/features/auth/presentation/pages/forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vms_resident_app/src/features/auth/providers/auth_provider.dart';
import 'package:vms_resident_app/src/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>(); 
    final email = _emailController.text.trim();

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final success = await authProvider.requestPasswordReset(email);

    if (!mounted) return;

    if (success) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Password reset link sent to $email!'),
          backgroundColor: Colors.green,
        ),
      );
      navigator.pop();
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Failed to send reset link.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ FIX 1: Corrected 'appAppBar' to 'appBar'
      appBar: AppBar( 
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter your email address to receive a password reset link.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: _emailController,
                labelText: 'Email',
                // ❌ FIX 2: Removed the undefined 'keyboardType' parameter.
                // If you need to enforce email input, you must add 'keyboardType' 
                // to the constructor of your custom AppTextField widget first.
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return authProvider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text('Send Reset Link');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}