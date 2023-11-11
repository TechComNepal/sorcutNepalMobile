import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white54,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/nointernet.png',
              height: 200,
            ),
            Text(
              'Whoops!',
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Slow or no internet connection.',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 5,
            ),
            Text('Please Check your internet settings.'),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/main-bottom-nav');
                },
                child: Text(
                  'Try Again',
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
