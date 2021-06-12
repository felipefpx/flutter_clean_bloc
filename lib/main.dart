import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'app.dart';

void main() {
  runApp(
    App(httpClient: http.Client()),
  );
}
