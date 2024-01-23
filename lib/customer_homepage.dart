//customer_homepage.dart
import 'package:flutter/material.dart';
import 'AccCust.dart';
import 'Model/addtocart.dart';
import 'Model/plant_managment.dart';

void main() {
  runApp(MaterialApp(
    home: CustomerHomeScreen(customerId: null),
  ));
}

class CustomerHomeScreen extends StatefulWidget {
  final int? customerId;

  CustomerHomeScreen({required this.customerId});

  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'All'; // Initialize with 'All'
  late Future<List<Plant>> _plantsFuture;

  void _markCartItemsAsPurchased() async {
    // Get the cart items for the customer
    List<Cart> cartItems = await Cart.loadAll(widget.customerId);

    // Mark each cart item as purchased (delete them)
    for (var item in cartItems) {
      bool success = await item.delete();
      if (success) {
        print("Item ${item.plant.plantname} removed from cart.");
      } else {
        print("Error removing item ${item.plant.plantname} from cart.");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _plantsFuture = Plant.loadAll();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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

  void _showCartDialog() async {
    List<Cart> cartItems = await Cart.loadAll(widget.customerId);
    Map<int, Cart> groupedCartItems = {};
    Map<int, double> plantTotalSum = {};

    for (var item in cartItems) {
      if (groupedCartItems.containsKey(item.plant.id)) {
        groupedCartItems[item.plant.id]!.plantQuantity += item.plantQuantity;
        plantTotalSum[item.plant.id] =
            (plantTotalSum[item.plant.id] ?? 0) + double.parse(item.total);
      } else {
        groupedCartItems[item.plant.id] = item;
        plantTotalSum[item.plant.id] = double.parse(item.total);
      }
    }
    double totalSum = 0.0;
    plantTotalSum.forEach((plantId, total) {
      totalSum += total;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shopping Cart',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                if (groupedCartItems.isNotEmpty)
                  for (var item in groupedCartItems.values)
                    Dismissible(
                      key: Key('${item.plantId}-${item.customerId}'),
                      onDismissed: (direction) async {
                        bool success = await item.delete();
                        if (success) {
                          print("success");
                        }
                        else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerHomeScreen(customerId: widget.customerId),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Add to cart Item deleted successfully'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 2.0,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(8.0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                'http://192.168.43.220/plant/uploads/${item.plant.plantimagename}',
                                width: 60.0,
                                height: 60.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item.plant.plantname,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('RM ${item.plant.plantprice.toStringAsFixed(2)}'),
                                Text('Quantity: ${item.plantQuantity}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${item.plantQuantity}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                else
                  Text('No items in the cart.'),
                SizedBox(height: 16.0),
                Text(
                  'Total: RM ${totalSum.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        // Calculate the total sum of items in the cart
                        double totalSum = 0.0;
                        plantTotalSum.forEach((plantId, total) {
                          totalSum += total;
                        });

                        // Navigate to the payment screen and pass the total sum
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                          totalAmount: totalSum,
                          markCartItemsCallback: _markCartItemsAsPurchased,
                          ),
                         )
                        );
                      },
                      child: Text('Proceed to payment'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _viewPlantDetails(Plant plant, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantDetailsScreen(plant: plant, customerId: widget.customerId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
        backgroundColor: Color(0xFF013B23),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Use the appropriate icon for logout
          onPressed: () {
            _showLogoutDialog();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              _showCartDialog();
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: _currentIndex == 0 ? Colors.green : Colors.grey,
        unselectedItemColor: _currentIndex == 0 ? Colors.grey : Colors.green,
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

  Widget _buildBody() {
    return FutureBuilder<List<Plant>>(
      future: _plantsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading plants: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No plants available'),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryDropdown(snapshot.data!), // New widget for the category dropdown
              Expanded(
                child: _buildPlantGrid(snapshot.data!),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildCategoryDropdown(List<Plant> plants) {
    Set<String> categories = plants.map((plant) => plant.planttype).toSet();
    List<String> categoryList = ['All', ...categories.toList()];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: _selectedCategory,
        onChanged: (String? newValue) {
          setState(() {
            _selectedCategory = newValue ?? 'All'; // Update the selected category
          });
        },
        items: categoryList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlantGrid(List<Plant> plants) {
    List<Plant> filteredPlants = _selectedCategory == 'All'
        ? plants
        : plants.where((plant) => plant.planttype == _selectedCategory).toList();

    Map<String, List<Plant>> groupedPlants = {};
    plants.forEach((plant) {
      if (!groupedPlants.containsKey(plant.planttype)) {
        groupedPlants[plant.planttype] = [];
      }
      groupedPlants[plant.planttype]!.add(plant);
    });

    return ListView.builder(
      itemCount: groupedPlants.length,
      itemBuilder: (context, index) {
        String plantType = groupedPlants.keys.elementAt(index);
        List<Plant> typePlants = groupedPlants[plantType]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Plant Type: $plantType',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: typePlants.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _GridItem(plant: typePlants[index], onPressed: _viewPlantDetails);
              },
            ),
            Divider(),
          ],
        );
      },
    );
  }
}

class PaymentScreen extends StatelessWidget {
  final double totalAmount;
  final Function()? markCartItemsCallback;

  PaymentScreen({required this.totalAmount, this.markCartItemsCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Amount: RM ${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Add payment details and confirmation button here
            ElevatedButton(
              onPressed: () {
                // Perform payment processing logic here
                // Generate a receipt and display it
                _showReceiptDialog(context);
              },
              child: Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReceiptDialog(BuildContext context) {
    markCartItemsCallback?.call();
    // Implement receipt generation logic and display it in a dialog
    // Include details such as customer name, date, items purchased, total amount, etc.

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Receipt')),
          content: Column(
            children: [
              // Include receipt details here
              Text('Thank you for your purchase!'),
              Text('Date: ${DateTime.now()}'),
              Text('Total Amount: RM ${totalAmount.toStringAsFixed(2)}'),
              // Add other receipt details here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerHomeScreen(customerId: null,))
                );
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}


class _GridItem extends StatelessWidget {
  final Plant plant;
  final Function(Plant, BuildContext) onPressed;

  _GridItem({required this.plant, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed(plant, context);
      },
      child: Card(
        elevation: 2.0,
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'http://192.168.43.220/plant/uploads/${plant.plantimagename}',
                width: double.infinity,
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                plant.plantname, // Corrected field name
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantDetailsScreen extends StatefulWidget {
  final Plant plant;
  final int? customerId;

  PlantDetailsScreen({required this.plant, this.customerId});

  @override
  _PlantDetailsScreenState createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  int selectedQuantity = 1;

  double calculateTotalPrice() {
    return selectedQuantity * widget.plant.plantprice; // Corrected field name
  }

  void _showPlantDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Plant Details',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                ListTile(
                  title: Text('Plant Type'),
                  subtitle: Text(widget.plant.planttype),
                ),
                ListTile(
                  title: Text('Plant Name'),
                  subtitle: Text(widget.plant.plantname),
                ),
                ListTile(
                  title: Text('Quantity'),
                  subtitle: Text(selectedQuantity.toString()),
                ),
                ListTile(
                  title: Text('Total Price'),
                  subtitle: Text('RM ${calculateTotalPrice().toStringAsFixed(2)}'),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (widget.customerId != null) {
                          Cart customer = Cart(
                            cartId: 0,
                            plantId: widget.plant.id,
                            customerId: widget.customerId!,
                            plantQuantity: selectedQuantity,
                            total: calculateTotalPrice().toStringAsFixed(2),
                            plant: widget.plant,  // Assuming widget.plant is a Plant object
                          );


                          bool addToCartSuccess = await customer.addtocart();
                          if (addToCartSuccess) {
                            // Display success message using SnackBar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Successfully added plant to cart'),
                              ),
                            );

                            // Delay the navigation to the homepage
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomerHomeScreen(customerId: widget.customerId,)));
                            });
                          } else {
                            // Display an error message if needed
                            print('Error adding plant to cart');
                          }
                        } else {
                          print('Customer ID is null. Unable to add to cart.');
                          // Handle the case where customerId is null, e.g., show an error message
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF013B23),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Add to Cart'),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant.planttype), // Corrected field name
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                child: Image.network(
                  'http://192.168.43.220/plant/uploads/${widget.plant.plantimagename}', // Corrected field name
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.plant.plantname, // Corrected field name
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      'Customer ID: ${widget.customerId ?? 'N/A'}', // Accessing customer ID here
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text(
                          'Quantity: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (selectedQuantity > 1) {
                                selectedQuantity--;
                              }
                            });
                          },
                        ),
                        Text(
                          '$selectedQuantity',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              if (selectedQuantity <
                                  widget.plant.plantquantity) { // Corrected field name
                                selectedQuantity++;
                              }
                            });
                          },
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          '${widget.plant.plantquantity.toString()} plants available', // Corrected field name
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text(
                          'Price: \RM ${widget.plant.plantprice.toStringAsFixed(2)}', // Corrected field name
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.local_shipping,
                              color: Color(0xFF013B23),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              '   Free Shipping',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow),
                            Icon(Icons.star, color: Colors.yellow),
                            Icon(Icons.star, color: Colors.yellow),
                            Icon(Icons.star, color: Colors.yellow),
                            Icon(Icons.star_border),
                            SizedBox(width: 8.0),
                            Text(
                              '5.0',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          color: Color(0xFF013B23),
                        ),
                        Text(
                          '     Shipping :  RM 0.00',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showPlantDetailsDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF013B23),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text('Add to Cart'),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text(
                          'Total: \RM ${calculateTotalPrice().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}