//Shared Pref Dashboard
import 'dart:convert';
import 'package:dha_resident_app/view_model/chart_model/chart_model.dart';
import 'package:dha_resident_app/view_model/fetch_model/fetch_pages_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storePagesApi() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('access_token') ?? '';

  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
  };
  final response = await http.get(Uri.parse('http://110.93.244.74/api/pages'),
      headers: headers);

  //print("Response : " + response.toString());

  if (response.statusCode == 200) {
    // final jsonData = json.decode(response.body);
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> dataArray = data['data_array'] ?? [];

    final List<PagesModel> fetchPageModel =
        dataArray.map((jsonData) => PagesModel.fromJson(jsonData)).toList();

    final List<Map<String, dynamic>> serializedData =
        fetchPageModel.map((pageItem) => pageItem.toJson()).toList();

    //print(serializedData);

    await prefs.setString('fetchPagesModel', jsonEncode(serializedData));
  } else {
    print("API request failed with status: ${response.statusCode}.");
  }
}

//Chart Shred Pref Api Fetch function
Future<void> ChartComplaitApi() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    print("Token Detail : ${token}");

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('http://110.93.244.74/api/dashboard/dashboard_list/general'),
      headers: headers,
    );

    print("Response : ${response.statusCode}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> dataArray = data['data_array'] ?? [];

      final List<ChartDataArray> model = dataArray
          .map((jsonData) => ChartDataArray.fromJson(jsonData))
          .toList();

      final List<Map<String, dynamic>> serializedData =
          model.map((chartItem) => chartItem.toJson()).toList();

      print("Chart Model : ${serializedData}");
      print("Chart Model : ${serializedData.length}");

      await prefs.setString('chartComplaitModel', jsonEncode(serializedData));
    } else {
      print("API request failed with status: ${response.statusCode}.");
      // Handle API error appropriately, you might want to throw an exception
    }
  } catch (e) {
    print("Error: $e");
    // Handle unexpected errors, you might want to throw an exception
  }
}
