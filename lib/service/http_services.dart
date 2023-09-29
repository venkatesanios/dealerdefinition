import 'package:http/http.dart' as http;

class HttpService {
  final String baseURL = "http://192.168.1.141:3000/api/v1/"; //development

  Future<String> postRequest(String action, Map<String, Object> body) async {
    var response = await http.post(Uri.parse(baseURL),
        headers: {"action": action}, body: body);
    return response.body;
  }

  Future<String> putRequest(String action, Map<String, Object> body) async {
    var response = await http.put(
      Uri.parse(baseURL),
      headers: {
        "action": action,
      },
      body: body,
    );
    return response.body;
  }
}
