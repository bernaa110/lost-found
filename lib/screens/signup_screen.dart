import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_found_app/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../components/form_input.dart';
import '../components/primary_button.dart';
import '../components/cas_button.dart';
import '../components/logo_header.dart';
import 'cas_login_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  void signUp() async {
    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.signUp(
      emailController.text.trim(),
      passwordController.text.trim(),
      nameController.text.trim(),
    );

    final authState = ref.read(authProvider);
    if (authState.error == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${authState.error}')),
        );
      }
    }
  }

  void goToLogin() {
    Navigator.pop(context);
  }

  void loginCAS() {
    Navigator.pushReplacement(
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LogoHeader(title: 'Креирај профил'),
                const SizedBox(height: 12),
                const Text(
                  "Внеси ги твоите податоци за регистрација",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FormInput(label: "Име", controller: nameController),
                const SizedBox(height: 11),
                FormInput(label: "Е-пошта", controller: emailController),
                const SizedBox(height: 11),
                FormInput(
                  label: "Лозинка",
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 18),
                PrimaryButton(
                  label: "Регистрирај се",
                  isLoading: authState.isLoading,
                  onPressed: authState.isLoading ? null : () => signUp(),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Веќе имаш профил? "),
                    GestureDetector(
                      onTap: goToLogin,
                      child: const Text(
                        "Најави се",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}