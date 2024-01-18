//plant_managment.dart
import '../Controller/request_controller.dart';


class Plant {
  int id;  // Add the 'id' property
  String plantname;
  String plantimagename;
  String planttype;
  double plantprice;
  int plantquantity;

  Plant({
    required this.id,
    required this.plantname,
    required this.plantimagename,
    required this.planttype,
    required this.plantprice,
    required this.plantquantity,
  });

  // For loading data from JSOn
  Plant.fromJson(Map<String, dynamic> json)
      : id = int.tryParse(json['plant_id'] as String) ?? 0, // Assuming the key in JSON is 'plant_id'
        plantname = json['plant_name'] as String? ?? '',
        plantimagename = json['plant_image_name'] as String? ?? '',
        planttype = json['plant_type'] as String? ?? '',
        plantprice = double.tryParse(json['plant_price'] as String) ?? 0.0,
        plantquantity = int.tryParse(json['plant_quantity'] as String) ?? 0;

  // For converting to JSON
  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'plantname': plantname,
        'plantimagename': plantimagename,
        'planttype': planttype,
        'plantprice': plantprice,
        'plantquantity': plantquantity,
      };
  // CRUD operations
  Future<bool> update() async {
    RequestController req = RequestController(path: "/plant/plant.php");

    // Include the request body
    req.setBody(toJson());

    try {
      // Update the plant in the remote database
      await req.put();

      if (req.status() == 200 && req.result()['success'] == true) {
        print('Successfull update : ${req.result()}');
        return true;
      } else {
        print('Error updating plant remotely: ${req.status()}, ${req.result()}');
        return false;
      }
    } catch (error) {
      print('Error updating plant: $error');
      return false;
    }
  }

  Future<bool> delete(Map<String, dynamic> requestBody) async {
    RequestController req = RequestController(path: "/plant/plant.php?id=${id}");

    // Include the request body
    req.setBody(toJson());

    // Delete from remote database
    await req.delete(requestBody);
    if (req.status() != 200) {
      print("Error deleting plant remotely: ${req.status()}, ${req.result()}");
      return false;
    }
    return true;
  }

  static Future<List<Plant>> loadAll() async {
    List<Plant> result = [];
    RequestController req = RequestController(path: "/plant/plant.php");
    await req.get();

    print("raw response: ${req.result()}");

    if (req.status() == 200 && req.result() != null) {
      try {
        dynamic responseData = req.result();
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data') &&
            responseData['data'] is List<dynamic>) {
          List<dynamic> plantsData = responseData['data'];
          for (var item in plantsData) {
            result.add(Plant.fromJson(item));
          }
        } else {
          print("Error loading plants: Data is not in the expected format");
        }
      } catch (e) {
        print("Error loading plants: $e");
      }
    } else {
      print("Error loading plants remotely: ${req.status()}, ${req.result()}");
    }
    return result;
  }
}
