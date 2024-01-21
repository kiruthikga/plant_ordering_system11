import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'admin_homepage_managment.dart';

void main() {
  runApp(MaterialApp(
    home: AdminHomeScreen(),
  ));
}

class AddPlantScreen extends StatefulWidget {
  final VoidCallback onPlantAdded;

  const AddPlantScreen({Key? key, required this.onPlantAdded}) : super(key: key);

  @override
  _AddPlantScreenState createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  TextEditingController _plantNameController = TextEditingController();
  TextEditingController _plantPriceController = TextEditingController();
  int _quantity = 0;
  XFile? _image;
  String _selectedPlantType = 'Choose one'; // Default value
  List<String> _plantTypes = ['Choose one', 'Rose', 'Fern', 'Mossy', 'Cactus', 'White Lily'];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
  }

  //method save and upload image
  Future<void> _uploadPlant() async {
    String plantName = _plantNameController.text;
    double plantPrice = double.tryParse(_plantPriceController.text) ?? 0.0;
    int plantQuantity = _quantity;

    if (_image == null) {
      print('Image not selected');
      return;
    }

    String apiUrl = 'http://192.168.43.220/plant/plant.php'; // Replace with your server address

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['plantname'] = plantName;
    request.fields['planttype'] = _selectedPlantType;
    request.fields['plantprice'] = plantPrice.toString();
    request.fields['plantquantity'] = plantQuantity.toString();

    var file = await http.MultipartFile.fromPath('image', _image!.path);
    request.files.add(file);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Plant saved successfully!');
        print('Image uploaded successfully!');

        // Call the callback to refresh the plant list
        widget.onPlantAdded();

        // Show a dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Plant Added Successfully'),
              content: Text('Your plant has been added successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                    // Navigate back to the previous screen
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Error saving plant remotely: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error saving plant: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Plant Details'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Handle home button click
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                // Handle account button click
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _plantNameController,
              decoration: InputDecoration(labelText: 'Plant Name'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedPlantType,
              onChanged: (value) {
                setState(() {
                  _selectedPlantType = value!;
                });
              },
              items: _plantTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Plant Type',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _plantPriceController,
              decoration: InputDecoration(labelText: 'Plant Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Quantity'),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _decrementQuantity,
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 16.0),
                Text('$_quantity'),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _incrementQuantity,
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            _image != null
                ? Image.file(
              File(_image!.path),
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Text('Image not available');
              },
            )
                : SizedBox(height: 0, width: 0),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadPlant,
              child: Text('Add Plant'),
            ),
          ],
        ),
      ),
    );
  }
}
