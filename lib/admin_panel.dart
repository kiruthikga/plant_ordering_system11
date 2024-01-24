import 'package:flutter/material.dart';
import 'package:pkant_ordering_system/admin_homepage_managment.dart';
import 'login_admin.dart';
import '../Controller/request_controller.dart';

class Utils {
  static void logout(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AdminScreen()),
    );
  }
}

class AdminPanel extends StatelessWidget {
  Future<void> _showCustomerDetails(BuildContext context) async {
    try {
      List<dynamic>? customersData = await getCustomers();
      if (customersData != null && customersData.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerDetailsScreen(
              customersData: customersData,
            ),
          ),
        );
      } else {
        print('No customers found');
      }
    } catch (e) {
      print('Error fetching customers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Color(0xFF013B23),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Color(0xFF013B23)),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminHomeScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout, color: Color(0xFF013B23)),
              onPressed: () {
                Utils.logout(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/POS(2).png',
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showCustomerDetails(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF013B23),
                  ),
                  child: Text('Customer Details'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminHomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF013B23),
                  ),
                  child: Text('Plant List'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomerDetailsScreen extends StatelessWidget {
  final List<dynamic>? customersData;

  CustomerDetailsScreen({this.customersData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          title: Text('Customer Details'),
          backgroundColor: Color(0xFF013B23),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (customersData != null && customersData!.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: customersData!.length,
                    itemBuilder: (context, index) {
                      var customer = customersData![index];
                      return InkWell(
                        onTap: () {
                          _navigateToCustomerDetails(context, customer);
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 5.0,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: ListTile(
                            title: Text('Customer Name: ${customer['cust_fullname']}'),
                            subtitle: Text('Username: ${customer['cust_username']}'),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Text('No customers found'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Color(0xFF013B23)),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminHomeScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout, color: Color(0xFF013B23)),
              onPressed: () {
                Utils.logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCustomerDetails(BuildContext context, dynamic customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerInformationScreen(customer: customer),
      ),
    );
  }
}

class PlantListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant List'),
        backgroundColor: Color(0xFF013B23),
      ),
      body: Center(
        child: Text('Welcome to Plant List Page'),
      ),
    );
  }
}

class CustomerInformationScreen extends StatelessWidget {
  final dynamic customer;

  CustomerInformationScreen({required this.customer});

  @override
  Widget build(BuildContext context) {
    String phoneNo = customer['cust_phoneno'];
    List<dynamic>? orderDetails = customer['order_details'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Information'),
        backgroundColor: Color(0xFF013B23),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoCard('Customer Name', customer['cust_fullname']),
            _buildInfoCard('Username', customer['cust_username']),
            _buildInfoCard('Phone Number', phoneNo),
            if (orderDetails != null && orderDetails.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text('Order Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  for (var order in orderDetails)
                    _buildOrderDetailsCard(order['product'], order['quantity']),
                ],
              )
            else
              Text('No order details available', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Color(0xFF013B23)),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminHomeScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout, color: Color(0xFF013B23)),
              onPressed: () {
                Utils.logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      color: Colors.white,
      elevation: 5.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: Text('$label: $value'),
      ),
    );
  }

  Widget _buildOrderDetailsCard(String product, int quantity) {
    return Card(
      color: Colors.white,
      elevation: 5.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: Text('Product: $product'),
        subtitle: Text('Quantity: $quantity'),
      ),
    );
  }
}
