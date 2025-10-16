import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vms_resident_app/src/features/auth/providers/auth_provider.dart';
import 'package:vms_resident_app/src/features/shell/presentation/shell_screen.dart';
import 'package:vms_resident_app/src/widgets/app_text_field.dart';
// Imp
import 'package:vms_resident_app/src/features/auth/presentation/pages/forgot_password_screen.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'auth/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use dummy data for testing
    _emailController.text = 'jane.resident1@example.com';
    _passwordController.text = 'Password123A';
  }

  // Dispose controllers to prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resident Login')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _emailController,
                labelText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Login Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Using context.read is often preferred for actions over Provider.of(..., listen: false)
                    final authProvider = context.read<AuthProvider>();
                    final navigator = Navigator.of(context);
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    await authProvider.login(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (!mounted) return;

                    if (authProvider.isLoggedIn) {
                      navigator.pushReplacementNamed(ShellScreen.routeName);
                    } else {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            authProvider.errorMessage ??
                                'An unknown error occurred.',
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 8),

              // Forgot Password Link
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamed(ForgotPasswordScreen.routeName);
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),

              const SizedBox(height: 16),
              // Loading Indicator
              Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isLoading) {
      return const Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      );
    }
    return const SizedBox.shrink();
  },
),

            ],
          ),
        ),
      ),
    );
  }
}
