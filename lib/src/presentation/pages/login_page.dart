import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_cubit.dart';
import '../widgets/app_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 4),
                Text('مرحبا', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('تسجيل الدخول إلى حسابك', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70)),
                const SizedBox(height: 28),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'الرجاء إدخال البريد الإلكتروني';
                              if (!v.contains('@')) return 'البريد الإلكتروني غير صالح';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(labelText: 'كلمة المرور'),
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'الرجاء إدخال كلمة المرور';
                              if (v.length < 6) return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthAuthenticated) {
                                Navigator.of(context).pushReplacementNamed('/home');
                              }
                              if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                              }
                            },
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;
                              return SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: isLoading
                                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              // app icon from assets
                                              Container(
                                                width: 28,
                                                height: 28,
                                                margin: const EdgeInsetsDirectional.only(end: 10),
                                                child: Image.asset('assets/images/logo.png', fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.storefront_rounded, color: Colors.white)),
                                              ),
                                              Flexible(
                                                child: Text('تسجيل الدخول', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
