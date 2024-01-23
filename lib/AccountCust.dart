// account_cust.dart
import 'package:flutter/material.dart';
import 'HelpCentre.dart';
import 'customer_homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    CustomerHomeScreen(customerId: null), // Home screen
    AccountPage(),
    // Add more screens as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Page'),
        backgroundColor: Color(0xFF013B23),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
        onTap: (index) {
          setState(() {
            // Only change the index if it's not the same as the current index
            if (_currentIndex != index) {
              _currentIndex = index;
            }
          });

          // Check if the "Account" tab is tapped, and navigate accordingly
          if (index == 1 && _currentIndex != 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountPage()),
            );
          }
        },
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        children: [
          // Your existing AccountPage content goes here
          MyCategoryTile(
            categoryName: 'Account User',
            items: ['Account', 'Address'],
          ),
          MyCategoryTile(
            categoryName: 'Support',
            items: ['Help Centre', 'About'],
          ),
        ],
      ),
    );
  }
}

class MyCategoryTile extends StatelessWidget {
  final String categoryName;
  final List<String> items;

  MyCategoryTile({
    required this.categoryName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(categoryName),
      children: [
        // Sublist for each category
        ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
              leading: _getIconForItem(items[index]), // Use a function to get the icon
              onTap: () {
                // Handle onTap for each item
                if (items[index] == 'Help Centre') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpCentre()),
                  );
                } else if (items[index] == 'About') {
                  print('User tapped on About');
                } else if (items[index] == 'Homepage') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerHomeScreen(customerId: null)),
                  );
                } else if (items[index] == 'Account') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountPage()),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }

  // Function to get the icon based on the item name
  Widget _getIconForItem(String itemName) {
    switch (itemName) {
      case 'Help Centre':
        return Icon(Icons.help);
      case 'About':
        return Icon(Icons.info);
      case 'Homepage':
        return Icon(Icons.home);
      case 'Account':
        return Icon(Icons.account_circle);
      default:
        return Icon(Icons.star); // Default icon, you can change this
    }
  }
}