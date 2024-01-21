//customer.dart
import '../Controller/request_controller.dart';

class Customer {
  int id;
  String customerUsername;
  String customerPassword;
  String customerFullname;
  String phoneNo;

  Customer({
    required this.id,
    required this.customerUsername,
    required this.customerPassword,
    required this.customerFullname,
    required this.phoneNo,
  });

  // For loading data from JSON
  Customer.fromJson(Map<String, dynamic> json)
      : id = json['cust_id'] as int,
        customerUsername = json['customer_username'] as String,
        customerPassword = json['customer_password'] as String,
        customerFullname = json['customer_fullname'] as String,
        phoneNo = json['phone_no'] as String;

  // For converting to JSON
  Map<String, dynamic> toJson() => {
    'cust_id': id,
    'customer_username': customerUsername,
    'customer_password': customerPassword,
    'customer_fullname': customerFullname,
    'phone_no': phoneNo,
  };

  Future<bool> signUp() async {
    RequestController req = RequestController(path: "/plant/customers_signup.php");
    req.setBody(toJson());

    await req.post();

    if (req.status() == 200 && req.result()['success'] == true) {
      return true;
    } else {
      print('Error signing up customer remotely: ${req.status()}, ${req.result()}');
      return false;
    }
  }









  // Add save, update, delete, and loadAll methods here as needed
  Future<bool> save() async {
    // API OPERATION
    RequestController req = RequestController(path: "/plant/customers_signup.php");
    req.setBody(toJson());

    // Use the POST method for authentication
    await req.post();

    if (req.status() == 200) {
      // Check if the credentials are correct by examining the server response
      if (req.result()['authenticated'] == true) {
        return true;
      } else {
        print('Invalid username or password');
        return false;
      }
    } else {
      print('Error authenticating customer remotely: ${req.status()}, ${req.result()}');
      return false;
    }
  }

  Future<bool> update() async {
    RequestController req = RequestController(path: "/plant/customers_signup.php");
    req.setBody(toJson());

    // Update in remote database
    await req.put();
    if (req.status() != 200) {
      // Error handling for remote update
      print("Error updating customer remotely: ${req.status()}, ${req.result()}");
      return false;
    }

    // Handle local update if needed

    return true;
  }

  Future<bool> delete(Map<String, dynamic> requestBody) async {
    RequestController req = RequestController(path: "/plant/customers_signup.php");

    // Include the request body
    req.setBody(toJson());

    // Delete from remote database
    await req.delete(requestBody);
    if (req.status() != 200) {
      print("Error deleting customer remotely: ${req.status()}, ${req.result()}");
      return false;
    }

    return true;
  }

  static Future<List<Customer>> loadAll() async {
    List<Customer> result = [];
    RequestController req = RequestController(path: "/plant/customers_signup.php");
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      // Check if the response has a 'data' key and it is iterable
      if (req.result().containsKey('data') && req.result()['data'] is Iterable) {
        for (var item in req.result()['data']) {
          result.add(Customer.fromJson(item));
        }
      } else {
        print("Invalid response format: ${req.result()}");
      }
    } else {
      print("Error loading customers remotely: ${req.status()}, ${req.result()}");
      // Handle local load if needed
    }

    return result;
  }


}

