import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../AccCust.dart';

import 'Model/customer.dart';

class ProfileUpdatePage extends StatefulWidget {
  final String customerId;

  ProfileUpdatePage({Key? key, required this.customerId}) : super(key: key);

  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchCustomerData();
  }

  // Replace this method with your actual logic to fetch customer data
  void fetchCustomerData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.43.220/plant/editProfCust.php?cust_id=${widget.customerId}'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          usernameController.text = data['cust_username'];
          fullnameController.text = data['cust_fullname'];
          phoneController.text = data['cust_phoneno'];
        });
      } else {
        print('Error fetching customer data: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Exception during customer data fetch: $e');
    }
  }

  Future<void> updateCustomerProfile() async {
    // Attempt to parse the customerId into an integer
    int? customerId;

    // Validate that widget.customerId is a valid integer string
    if (widget.customerId != null && int.tryParse(widget.customerId) != null) {
      try {
        customerId = int.parse(widget.customerId);
      } catch (e) {
        print('Error parsing customerId: $e');
        // Handle the error, e.g., show an error message to the user
        return;
      }
    } else {
      print('Invalid customerId format: ${widget.customerId}');
      // Handle the error, e.g., show an error message to the user
      return;
    }

    // Proceed only if the customerId is not null
    if (customerId != null) {
      // Prepare updated data
      Customer updatedCustomer = Customer(
        id: customerId,
        customerUsername: usernameController.text,
        customerFullname: fullnameController.text,
        phoneNo: phoneController.text,
        customerPassword: '', // You may add password field if needed
      );

      // Call the update method from the Customer class
      bool updateSuccessful = await updatedCustomer.update();

      if (updateSuccessful) {
        // Optionally, you can navigate back or show a success message
        print('Profile updated successfully');
        Navigator.pop(context); // Navigate back
      } else {
        print('Failed to update profile');
        // Optionally, you can show an error message to the user
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: fullnameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: updateCustomerProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF013B23), // Set your desired background color
              ),
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}