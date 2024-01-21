// main.dart
import 'package:flutter/material.dart';
import 'login_admin.dart';
import 'login_customer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Type Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserTypeSelectionScreen(),
    );
  }
}

class UserTypeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('PLANT ORDERING SYSTEM')),
        backgroundColor: Color(0xFF013B23),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to AdminScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF013B23), // Background color
              ),
              child: Text('Admin'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to CustomerScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF013B23), // Background color
              ),
              child: Text('Customer'),
            ),
          ],
        ),
      ),
    );
  }
}


