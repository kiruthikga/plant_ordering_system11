import 'package:flutter/material.dart';

import 'AccCust.dart';
import 'customer_homepage.dart';

void main() {
  runApp(MaterialApp(
    home: AboutScreen(customerId: null),
  ));
}

class AboutScreen extends StatefulWidget {
  final int? customerId;

  AboutScreen({required this.customerId});

  @override
  _AboutScreen createState() => _AboutScreen();
}

class _AboutScreen extends State<AboutScreen> {
  int _currentIndex = 0;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('About US'),
          backgroundColor: Color(0xFF013B23),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Use the appropriate icon for logout
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccCustScreen(customerId: null,)),
              );
            },
          ),
        ),
        body: About(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: _currentIndex == 1 ? Colors.green : Colors.grey,
          unselectedItemColor: _currentIndex == 1 ? Colors.grey : Colors.green,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (_currentIndex == 0) {
                // Navigate to the AccountPage when the "Home" icon is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerHomeScreen(customerId: null,)),
                );
              } else if (_currentIndex == 1) {
                // Navigate to the AccountPage when the "Account" icon is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccCustScreen(customerId: null,)),
                );
              }
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
          selectedLabelStyle: TextStyle(color: Colors.green),
        ),
      ),
    );
  }
}

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Us',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'The Plant Ordering System is an innovative online platform designed to streamline the process of purchasing a wide variety of plants. This system caters to gardening enthusiasts, landscapers, and individuals looking to enhance their living spaces with greenery. Users can create accounts, explore an extensive catalog of plants, and easily place orders through a user-friendly interface. The platform offers detailed product information, allowing users to make informed decisions about the type, size, and care requirements of each plant. The ordering process is secure, with multiple payment options available. Additionally, the system provides real-time tracking for shipped orders, ensuring customers stay informed about the status of their deliveries. A robust return policy is in place, outlining procedures for addressing issues such as damaged or incorrect items. The Plant Ordering System is committed to user privacy, employing stringent data security measures. Regular updates and a responsive customer support system contribute to a seamless and satisfying plant shopping experience for users.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


