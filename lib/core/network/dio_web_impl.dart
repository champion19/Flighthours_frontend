/// Web-specific implementation that configures Dio for HttpOnly cookie support.
///
/// This file is used via conditional import — on web, it sets
/// `BrowserHttpClientAdapter(withCredentials: true)` so the browser
/// includes HttpOnly cookies in every request automatically.
library;
import 'package:dio/dio.dart';
import 'package:dio_web_adapter/dio_web_adapter.dart';

void configureWebCredentials(Dio dio) {
  dio.httpClientAdapter = BrowserHttpClientAdapter(withCredentials: true);
}
