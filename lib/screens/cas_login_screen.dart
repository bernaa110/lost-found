import 'package:flutter/material.dart';
import '/components/form_input.dart';
import '/components/primary_button.dart';

class CasLoginScreen extends StatefulWidget {
  const CasLoginScreen({super.key});
  @override
  State<CasLoginScreen> createState() => _CasLoginScreenState();
}

class _CasLoginScreenState extends State<CasLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void loginCAS() async {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/cas_icon.png", height: 65),
                    SizedBox(width: 20),
                    Text(
                      "Central Authentication\nSystem (CAS)",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                FormInput(label: "E-пошта", controller: emailController),
                SizedBox(height: 11),
                FormInput(
                  label: "Лозинка",
                  controller: passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 18),
                PrimaryButton(
                  label: "Најави се",
                  onPressed: loginCAS,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
