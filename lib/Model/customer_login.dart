import '../Controller/request_controller.dart';

class CustomerLogin {
  int id;
  String customerUsername;
  String customerPassword;
  String customerFullname;
  String phoneNo;

  CustomerLogin(this.id, this.customerUsername, this.customerPassword, this.customerFullname, this.phoneNo);

  // For loading data from JSON
  CustomerLogin.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        customerUsername = json['customer_username'] as String,
        customerPassword = json['customer_password'] as String,
        customerFullname = json['customer_fullname'] as String,
        phoneNo = json['phone_no'] as String;

  // For converting to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'customer_username': customerUsername,
    'customer_password': customerPassword,
    'customer_fullname': customerFullname,
    'phone_no': phoneNo,
  };

  // Add save, update, delete, and loadAll methods here as needed
  Future<bool> save() async {
    // API OPERATION
    RequestController req = RequestController(path: "/plant/customers.php");
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
    RequestController req = RequestController(path: "/plant/customers.php");
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
    RequestController req = RequestController(path: "/plant/customers.php");

    // Include the request body
    req.setBody(toJson());

    // Delete from remote database
    await req.delete(requestBody);
    if (req.status() != 200) {
      print("Error deleting customer remotely: ${req.status()}, ${req.result()}");
      return false;
    }

    // Handle local delete if needed

    return true;
  }

  static Future<List<CustomerLogin>> loadAll() async {
    List<CustomerLogin> result = [];
    RequestController req = RequestController(path: "/plant/customers.php");
    await req.get();
    if (req.status() == 200 && req.result() != null) {
      for (var item in req.result()) {
        result.add(CustomerLogin.fromJson(item));
      }
    } else {
      print("Error loading customers remotely: ${req.status()}, ${req.result()}");
      // Handle local load if needed
    }
    return result;
  }
}
