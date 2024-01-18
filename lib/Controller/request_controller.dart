//request_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestController {
  String path;
  String server;
  http.Response? _res;
  final Map<dynamic, dynamic> _body = {};
  final Map<String, String> _header = {};
  dynamic _resultData;

  RequestController({required this.path, this.server = "http://172.20.10.4"});

  setBody(Map<String, dynamic> data) {
    _body.clear();
    _body.addAll(data);
    _header["Content-Type"] = "application/json; charset=UTF-8";
  }

  Future<void> post() async {
    try {
      _res = await http.post(
        Uri.parse(server + path),
        headers: _header,
        body: jsonEncode(_body),
      );
      _parseResult();
    } catch (e) {
      print("Exception during POST request: $e");
      _handleError();
    }
  }

  Future<void> get() async {
    try {
      _res = await http.get(
        Uri.parse(server + path),
        headers: _header,
      );
      _parseResult();
    } catch (e) {
      print("Exception during GET request: $e");
      _handleError();
    }
  }

  Future<void> put() async {
    try {
      _res = await http.put(
        Uri.parse(server + path),
        headers: _header,
        body: jsonEncode(_body),
      );
      _parseResult();
    } catch (e) {
      print("Exception during PUT request: $e");
      _handleError();
    }
  }

  Future<void> delete(Map<String, dynamic> requestBody) async {
    try {
      _res = await http.delete(
        Uri.parse(server + path),
        headers: _header,
        body: jsonEncode(requestBody),
      );
      _parseResult();
    } catch (e) {
      print("Exception during DELETE request: $e");
      _handleError();
    }
  }

  Future<void> _parseResult() async {
    //parse result into json structure if possible
    try {
      print("raw response: ${_res?.body}");
      _resultData = jsonDecode(_res?.body ?? "");
    } catch (ex) {
      //otherwise the response body will be stored as is
      _resultData = _res?.body;
      print("exception in http result parsing $ex");
    }
  }


  void _handleError() {
    print("Error occurred during the HTTP request");
  }

  dynamic result() {
    return _resultData;
  }

  int status() {
    return _res?.statusCode ?? 0;
  }
}
