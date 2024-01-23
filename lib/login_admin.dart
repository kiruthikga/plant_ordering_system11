import 'package:flutter/material.dart';
import 'Model/admin_login.dart';
import 'admin_homepage_managment.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Flag to toggle password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, Admin'),
        backgroundColor: Color(0xFF013B23),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/plantos.png', // Replace with your actual image asset path
                width: 350, // Adjust the width as needed
                height: 350, // Adjust the height as needed
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_isPasswordVisible) {
                    setState(() {
                      _isPasswordVisible = false;
                    });
                  }

                  // Retrieve username and password
                  String username = _usernameController.text;
                  String password = _passwordController.text;

                  // Create an instance of AdminLogin
                  AdminLogin adminLogin = AdminLogin(username, password, '');

                  // Call the save method for authentication
                  bool isAuthenticated = await adminLogin.save();

                  if (isAuthenticated) {
                    // Navigate to the admin home screen on successful login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AdminHomeScreen()),
                    );
                  } else {
                    // Show an error message for unsuccessful login
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid username or password'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF013B23), // Background color
                ),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
