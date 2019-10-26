import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceController {
  static Future<String> updateAttendance(Map data) async {
    String email = data["email"];
    String track = data["track"];
    String week = data["week"];

    var url = "google-sheet-url";
    
    final response = await http.get(Uri.parse(url),
        headers: {"Content-Type": "application/json"});

    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      // showSuccessToast(jsonResponse["description"]);
      return jsonResponse["description"];
    }
    
    print("Something went wrong => " + response.statusCode.toString());
    // showFailureToast("Oops! something went wrong. Try later.");
    return null;
  
  }
}