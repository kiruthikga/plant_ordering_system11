//customer_homepage.dart
import 'package:flutter/material.dart';
import 'package:pkant_ordering_system/About.dart';
import 'HelpCentre.dart';
import 'UpdateProfile.dart';
import 'customer_homepage.dart';

void main() {
  runApp(MaterialApp(
    home: AccCustScreen(customerId: null),
  ));
}

class AccCustScreen extends StatefulWidget {
  final int? customerId;

  AccCustScreen({required this.customerId});

  @override
  _AccCustScreen createState() => _AccCustScreen();
}

class _AccCustScreen extends State<AccCustScreen> {
  int _currentIndex = 0;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Setting'),
        backgroundColor: Color(0xFF013B23),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Use the appropriate icon for logout
          onPressed: () {},
        ),
      ),
      body: AccountPage(),
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
                MaterialPageRoute(builder: (context) => CustomerHomeScreen(customerId: widget.customerId)),
              );
            } else if (_currentIndex == 1) {
              // Navigate to the AccountPage when the "Account" icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccCustScreen(customerId: widget.customerId)),
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
          Spacer(),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              _showLogoutDialog(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF013B23), // Set the background color
            ),
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white), // Set the text color
            ),
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
                    MaterialPageRoute(builder: (context) =>
                        HelpCentreScreen(customerId: null,)),
                  );
                } else if (items[index] == 'About') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AboutScreen(customerId: null,)),
                  );
                } else if (items[index] == 'Homepage') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        CustomerHomeScreen(customerId: null)),
                  );
                } else if (items[index] == 'Account') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        ProfileUpdatePage(customerId: '')),
                  );
                }
              });
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout actions here
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

