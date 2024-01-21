// login_customer.dart
import 'package:flutter/material.dart';
import 'package:pkant_ordering_system/signup_customer.dart';
import 'Controller/request_controller.dart';
import 'Model/customer_login.dart';
import 'customer_homepage.dart';

void main() {
  runApp(MaterialApp(
    home: CustomerScreen(),
  ));
}

Future<int> getCustomerIdFromDatabase(String username) async {
  try {
    String url = "/plant/customers_signup.php";
    RequestController req = RequestController(path: url);
    await req.get();
    if (req.status() == 200 && req.result() != null) {
      List<dynamic> customersData = req.result()['data'];

      for (var customer in customersData) {
        if (customer['cust_username'] == username && customer['cust_id'] != null) {
          return int.parse(customer['cust_id'].toString());
        }
      }
      print("No customer found with the given username: $username");
    } else {
      print("Error retrieving customer from the database: ${req.status()}, ${req.result()}");
    }
  } catch (e) {
    print("Exception: $e");
  }
  return -1;
}

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
        backgroundColor: Color(0xFF013B23),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/POS(2).png', // Replace with your actual image asset path
                  width: 250, // Adjust the width as needed
                  height: 250, // Adjust the height as needed
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ?
                      Icons.visibility :
                      Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      String username = _usernameController.text;
                      String password = _passwordController.text;

                      CustomerLogin customerLogin = CustomerLogin(0, username, password, '', '');
                      bool isAuthenticated = await customerLogin.save();

                      if (isAuthenticated) {
                        int customerId = await getCustomerIdFromDatabase(username);

                        if (customerId != -1) {
                          print('Logged in successfully. Customer ID: $customerId');
                          // Navigate to CustomerHomeScreen and pass customerId
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerHomeScreen(customerId: customerId),
                            ),
                          );
                        } else {
                          print('Failed to retrieve customer ID');
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid username or password'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF013B23), // Background color
                  ),
                  child: Text('Login'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Navigate to the sign-up screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  style: TextButton.styleFrom(
                    primary: Color(0xFF013B23), // Text color
                  ),
                  child: Text("Not a member? Sign Up now"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
