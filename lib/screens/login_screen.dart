import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_found_app/theme/app_colors.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'cas_login_screen.dart';
import '/components/form_input.dart';
import '/components/primary_button.dart';
import '/components/cas_button.dart';
import '/components/logo_header.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    final authState = ref.read(authProvider);
    if (authState.user != null) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
        );
      }
    } else if (authState.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${authState.error}')),
        );
      }
    }
  }

  void goToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  void loginCAS() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CasLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        iconTheme: const IconThemeData(color: kLogoDarkBlue),
        titleTextStyle: const TextStyle(
          color: kLogoDarkBlue,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LogoHeader(title: 'Добредојде'),
                const SizedBox(height: 12),
                const Text(
                  "Внеси ја твојата е-пошта за најава",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FormInput(label: "Е-пошта", controller: emailController),
                const SizedBox(height: 11),
                FormInput(
                  label: "Лозинка",
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 18),
                PrimaryButton(
                  label: "Најави се",
                  isLoading: authState.isLoading,
                  onPressed: () => login(),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Немаш профил? "),
                    GestureDetector(
                      onTap: goToSignup,
                      child: const Text(
                        "Регистрирај се",
                        style: TextStyle(
                          color: kLogoLightBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 9),
                      child: Text("или продолжи со",
                          style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),
                CasButton(onPressed: loginCAS),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
