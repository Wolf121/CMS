import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ApiServiceProvider {
  static final String BASE_URL =
      "https://www.dhai-r.com.pk/storage/app/media/bills/aug_2023/32420100710101.pdf";

  static Future<String> loadPDF() async {
    var response = await http.get(
      Uri.parse(BASE_URL),
    );

    var dir = await getApplicationDocumentsDirectory();
    File file = new File("${dir.path}.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }
}
