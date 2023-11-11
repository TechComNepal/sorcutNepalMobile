import 'package:flutter/material.dart';
import 'package:sortcutnepal/utils/colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white54,
        width: double.infinity,
        // height: MediaQuery.of(context).size.height * 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/sortcut.png',
              height: 70,
            ),
            const SizedBox(
              height: 80,
            ),
            const CircularProgressIndicator(
              color: AppColors.mainColor,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Please Wait ...',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
