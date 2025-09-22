import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset("assets/logo.png", height: 250),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 170,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text("Најави се",
                        style:
                        TextStyle(color: Colors.white, fontSize: 15)),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen())),
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 170,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text("Регистрирај се",
                        style:
                        TextStyle(color: Colors.white, fontSize: 15)),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignupScreen())),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Услови за користење | Политика за приватност",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
