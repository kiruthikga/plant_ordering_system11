import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Account Page'),
          backgroundColor: Color(0xFF013B23),
        ),
        body: HelpCentre(),
      ),
    );
  }
}

class HelpCentre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        children: [
          HelpTile(
            categoryName: 'Introduction',
            items: ['[Welcome message] Briefly introduce users to the plant ordering system.',
              '[Overview of the help center] Explain the purpose and benefits of the help center.'],
          ),
          HelpTile(
            categoryName: 'Getting Started',
            items: ['[Account creation] Step-by-step guide on how to create an account.',
              '[Navigating the platform] Overview of the main features and functionalities.'],
          ),
          HelpTile(
            categoryName: 'Ordering Plants',
            items: ['[Browse and search] Tips on finding plants using the search and browse functions.',
              '[Product details] How to view detailed information about each plant.',
            '[Adding to cart] Instructions on how to add plants to the shopping cart'],
          ),
          HelpTile(
            categoryName: 'Checkout Process',
            items: ['[Reviewing the cart] Guidance on reviewing and editing the order.',
              '[Shipping options] Explanation of available shipping methods.',
              '[Payment methods] Information on accepted payment methods.'],
          ),
          HelpTile(
            categoryName: 'Terms and Policies',
            items:
              ['Welcome to our Plant Ordering System! By utilizing our platform,'
                  ' users agree to adhere to the following terms and policies.'
                  ' Users are responsible for accurate and up-to-date information '
                  'during account creation, ensuring the security of their login '
                  'credentials. The ordering process involves accurate product '
                  'information, payment confirmation, and adherence to specified'
                  'pricing, taxes, and fees. We commit to providing transparent '
                  'shipping and delivery details, with users able to track orders. '
                  'Our return policy outlines conditions for returns and the refund'
                  ' process. Users are expected to comply with system rules,'
                  ' maintain data accuracy, and acknowledge our privacy and data '
                  'security practices. Intellectual property rights and limitations'
                  ' of liability are specified, with the governing law and jurisdiction'
                  ' clearly defined. We reserve the right to update terms, with '
                  'continued use implying acceptance of changes. For customer '
                  'support and legal inquiries, contact information is provided.'
                  ' These terms and policies are effective as of [Effective Date].',
              ],
          ),
        ],
      ),
    );
  }
}

class HelpTile extends StatelessWidget {
  final String categoryName;
  final List<String> items;

  HelpTile({
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
              // onTap: () {
              //   // Handle onTap for each item
              //   if (items[index] == 'Help Centre') {
              //     // Navigate to Help Centre screen or perform an action
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => HelpCentre()),
              //     );
              //   } else if (items[index] == 'About') {
              //     // Navigate to About screen or perform an action
              //     print('User tapped on About');
              //   }
              // },
            );
          },
        ),
      ],
    );
  }
}
