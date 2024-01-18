import 'package:flutter/material.dart';
import 'Model/plant_managment.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'addplant.dart';

void main() {
  runApp(MaterialApp(
    home: AdminHomeScreen(),
  ));
}

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  late Future<List<Plant>> _plantsFuture;
  String ipaddress = "172.20.10.4";

  @override
  void initState() {
    super.initState();
    _plantsFuture = Plant.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home Screen'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddPlantScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPlantScreen(
                onPlantAdded: _refreshPlants,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
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
          return _buildPlantList(snapshot.data!);
        }
      },
    );
  }

  //group the plant type by display in mengikut play type
  Widget _buildPlantList(List<Plant> plants) {
    Map<String, List<Plant>> groupedPlants = {};
    plants.forEach((plant) {
      if (!groupedPlants.containsKey(plant.planttype)) {
        groupedPlants[plant.planttype] = [];
      }
      groupedPlants[plant.planttype]!.add(plant);
    });

    List<Widget> plantWidgets = [];
    groupedPlants.forEach((type, typePlants) {
      plantWidgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Plant Type: $type',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
      plantWidgets.addAll(typePlants.map((plant) => _buildPlantItem(plant)));
    });

    return ListView.separated(
      itemCount: plantWidgets.length,
      itemBuilder: (context, index) => plantWidgets[index],
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget _buildPlantItem(Plant plant) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        // Show confirmation dialog before deleting
        _showDeleteConfirmationDialog(plant);
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
      child: GestureDetector(
        onLongPress: () {
          _editPlantDetails(plant);
        },
        child: Card(
          elevation: 2.0,
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(plant.plantname),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'http://$ipaddress/plant/uploads/${plant.plantimagename}',
                    scale: 1.0,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Failed to load image: $error');
                      print('Image URL: http://$ipaddress/plant/uploads/${plant.plantimagename}');
                      return Text('Failed to load image: $error');
                    },
                  ),
                ),
                SizedBox(height: 8.0),
                Text('Type: ${plant.planttype}'),
                Text('Price: \RM${plant.plantprice.toString()}'),
                Text('Quantity: ${plant.plantquantity.toString()}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Plant plant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Plant'),
          content: Text('Are you sure you want to delete ${plant.plantname}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _refreshPlants();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Remove the plant from the database and update the UI
                _deletePlant(plant);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }





  void _deletePlant(Plant plant) async {
    try {
      // Delete the plant from the remote database
      bool success = await plant.delete({
        'id': plant.id,
      });

      if (success) {
        // Refresh the plant list
        _refreshPlants();
      } else {
        print('Error deleting plant remotely.');
      }
    } catch (error) {
      print('Error deleting plant: $error');
    }
  }

  void _editPlantDetails(Plant plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlantScreen(plant: plant, onPlantUpdated: _refreshPlants),
      ),
    );
  }

  void _refreshPlants() {
    setState(() {
      _plantsFuture = Plant.loadAll();
    });
  }
}




class EditPlantScreen extends StatefulWidget {
  final Plant plant;
  final VoidCallback onPlantUpdated;

  EditPlantScreen({required this.plant, required this.onPlantUpdated});

  @override
  _EditPlantScreenState createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends State<EditPlantScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  String _selectedType = '';
  List<String> plantTypes = [];
  File? _selectedImage;
  String? _selectedImageName;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.plant.plantname;
    _priceController.text = widget.plant.plantprice.toString();
    _quantityController.text = widget.plant.plantquantity.toString();

    _loadPlantTypesFromDatabase();
  }

  void _loadPlantTypesFromDatabase() async {
    try {
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        plantTypes = ['Rose', 'Fern', 'Mossy', 'Cactus', 'White Lily'];
        if (!plantTypes.contains(widget.plant.planttype)) {
          plantTypes.add(widget.plant.planttype);
        }
      });

      _selectedType = widget.plant.planttype;
    } catch (error) {
      print('Error loading plant types: $error');
    }
  }

  Future<void> uploadImageFile(File imageFile, String filename) async {
    try {
      // Assuming your server endpoint for handling file uploads is /upload
      var url = Uri.parse('http://172.20.10.4/plant/plant.php');

      // Create a multipart request
      var request = http.MultipartRequest('POST', url);

      // Attach the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: filename, // Use the desired filename on the server
        ),
      );

      // Send the request
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Plant Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Plant Name'),
            ),
            SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _selectedType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
              items: plantTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Plant Type',
              ),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _updateQuantity(-1);
                    },
                    child: Text('-'),
                  ),
                  SizedBox(width: 8.0),
                  Container(
                    width: 60.0,
                    child: TextField(
                      controller: _quantityController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      _updateQuantity(1);
                    },
                    child: Text('+'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _pickImage();
              },
              child: Text('Upload Image'),
            ),
            _buildImageWidget(),
            ElevatedButton(
              onPressed: () async {
                // Get the updated values from the controllers
                String updatedName = _nameController.text;
                String updatedType = _selectedType;
                double updatedPrice = double.parse(_priceController.text);
                int updatedQuantity = int.parse(_quantityController.text);

                try {
                  if (_selectedImage != null) {
                    widget.plant.plantimagename = _selectedImageName!;
                    await uploadImageFile(_selectedImage!, widget.plant.plantimagename);
                  }

                  // Update the plant details
                  widget.plant.plantname = updatedName;
                  widget.plant.planttype = updatedType;
                  widget.plant.plantprice = updatedPrice;
                  widget.plant.plantquantity = updatedQuantity;
                  // Image
                  widget.plant.plantimagename = _selectedImageName.toString();

                  await widget.plant.update();
                  widget.onPlantUpdated();

                  // Show success dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: Text('Plant details updated successfully!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.of(context).pop(); // Go back to the previous screen
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } catch (error) {
                  // Handle error if necessary
                  print('Error updating plant: $error');
                }
              },
              child: Text('Save Changes'),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    return Container(
      height: 200,
      width: 200,
      child: _selectedImage != null
          ? Image.file(_selectedImage!, fit: BoxFit.cover)
          : Image.network(
        'http://172.20.10.4/plant/uploads/${widget.plant.plantimagename}',
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _selectedImageName = pickedFile.path.split('/').last; // Use a suitable method to get the file name
      });
    }
  }

  void _updateQuantity(int amount) {
    setState(() {
      int quantity = int.parse(_quantityController.text);
      _quantityController.text = (quantity + amount).clamp(0, 999).toString();
    });
  }
}
