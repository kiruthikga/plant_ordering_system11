//addtocart.dart
import 'package:pkant_ordering_system/Model/plant_managment.dart';
import '../Controller/request_controller.dart';

class Cart {
  Plant plant;
  int cartId;
  int plantId;
  int customerId;
  int plantQuantity;
  String total;

  Cart({
    required this.cartId,
    required this.plantId,
    required this.customerId,
    required this.plantQuantity,
    required this.total,
    required this.plant,
  });

  // For loading data from JSON
  Cart.fromJson(Map<String, dynamic> json)
      : cartId = int.tryParse(json['cart_id'].toString()) ?? 0,
        plantId = int.tryParse(json['plant_id'].toString()) ?? 0,
        customerId = int.tryParse(json['customer_id'].toString()) ?? 0,
        plantQuantity = int.tryParse(json['plant_quantity'].toString()) ?? 0,
        total = json['total'] as String? ?? '0.0',
        plant = Plant.fromJson(json);

  // For converting to JSON
  Map<String, dynamic> toJson() =>
      {
        'cart_id': cartId,
        'plant_id': plantId,
        'plant': plant.toJson(),
        'customer_id': customerId,
        'plant_quantity': plantQuantity,
        'total': total,
      };


  Future<bool> addtocart() async {
    RequestController req = RequestController(path: "/plant/addtocart.php");
    req.setBody(toJson());

    await req.post();

    if (req.status() == 200) {
      dynamic result = req.result();

      if (result['message'] == 'add to cart created successfully.') {
        return true; // Cart added successfully
      } else {
        print('Error adding plant to cart: ${result['message']}');
        return false; // Cart creation failed
      }
    } else {
      print('Error adding plant to cart remotely: ${req.status()}, ${req.result()}');
      return false; // Request failed
    }
  }

  Future<bool> delete() async {
    RequestController req = RequestController(path: "/plant/addtocart.php?customerId=${customerId}&plant_id=${plantId}");

    try {
      // Delete from the remote database
      await req.delete({}); // Pass the required parameter if needed

      if (req.status() == 200 && req.result()['success'] == true) {
        print('Successfully deleted cart: ${req.result()}');
        return true;
      } else {
        print('Error deleting cart remotely: ${req.status()}, ${req.result()}');
        return false;
      }
    } catch (error) {
      print('Error deleting cart: $error');
      return false;
    }
  }




  static Future<List<Cart>> loadAll(int? customerId) async {
    List<Cart> result = [];
    RequestController req = RequestController(path: "/plant/addtocart.php");

    // Include the customer_id parameter in the URL
    if (customerId != null) {
      req.path += "?customer_id=$customerId";
    }

    await req.get();

    print("raw response: ${req.result()}");

    if (req.status() == 200 && req.result() != null) {
      try {
        dynamic responseData = req.result();
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data') &&
            responseData['data'] is List<dynamic>) {
          List<dynamic> cartsData = responseData['data'];
          for (var item in cartsData) {
            result.add(Cart.fromJson(item));
          }
        } else {
          print("Error loading carts: Data is not in the expected format");
        }
      } catch (e) {
        print("Error loading carts: $e");
      }
    } else {
      print("Error loading carts remotely: ${req.status()}, ${req.result()}");
    }
    return result;
  }
}
