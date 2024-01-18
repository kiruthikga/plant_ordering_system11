//model/admin_login.dart
import '../Controller/request_controller.dart';

class AdminLogin {
  String adminUsername;
  String adminPassword;
  String adminFullname;

  AdminLogin(this.adminUsername, this.adminPassword, this.adminFullname);

  // For loading data from JSON
  AdminLogin.fromJson(Map<String, dynamic> json)
      : adminUsername = json['admin_username'] as String,
        adminPassword = json['admin_password'] as String,
        adminFullname = json['admin_fullname'] as String;

  // For converting to JSON
  Map<String, dynamic> toJson() => {
    'admin_username': adminUsername,
    'admin_password': adminPassword,
    'admin_fullname': adminFullname,
  };

  // Add save, update, delete, and loadAll methods here as needed
  Future<bool> save() async {
    // API OPERATION
    RequestController req = RequestController(path: "/plant/admins.php");
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
      print('Error authenticating admin remotely: ${req.status()}, ${req.result()}');
      return false;
    }
  }



  Future<bool> update() async {
    RequestController req = RequestController(path: "/plant/admins.php");
    req.setBody(toJson());

    // Update in remote database
    await req.put();
    if (req.status() != 200) {
      // Error handling for remote update
      print("Error updating admin remotely: ${req.status()}, ${req.result()}");
      return false;
    }

    // Handle local update if needed

    return true;
  }

  Future<bool> delete(Map<String, dynamic> requestBody) async {
    RequestController req = RequestController(path: "/plant/admins.php");

    // Include the request body
    req.setBody(toJson());

    // Delete from remote database
    await req.delete(requestBody);
    if (req.status() != 200) {
      print("Error deleting admin remotely: ${req.status()}, ${req.result()}");
      return false;
    }

    // Handle local delete if needed

    return true;
  }

  static Future<List<AdminLogin>> loadAll() async {
    List<AdminLogin> result = [];
    RequestController req = RequestController(path: "/plant/admins.php");
    await req.get();
    if (req.status() == 200 && req.result() != null) {
      for (var item in req.result()) {
        result.add(AdminLogin.fromJson(item));
      }
    } else {
      print("Error loading admins remotely: ${req.status()}, ${req.result()}");
      // Handle local load if needed
    }
    return result;
  }
}
