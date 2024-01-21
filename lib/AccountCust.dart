import 'package:flutter/material.dart';
import 'HelpCentre.dart'; // Import the HelpCentre widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Account Page'),
          backgroundColor: Color(0xFF013B23),
        ),
        body: AccountPage(),
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
              onTap: () {
                // Handle onTap for each item
                if (items[index] == 'Help Centre') {
                  // Navigate to Help Centre screen or perform an action
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpCentre()),
                  );
                } else if (items[index] == 'About') {
                  // Navigate to About screen or perform an action
                  print('User tapped on About');
                }
              },
            );
          },
        ),
      ],
    );
  }
}
