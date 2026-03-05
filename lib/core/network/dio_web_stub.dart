/// Stub implementation for non-web platforms.
///
/// This file is used via conditional import — on mobile/desktop,
/// `configureWebCredentials` is a no-op because `BrowserHttpClientAdapter`
/// doesn't exist outside of web.
library;
// ignore_for_file: avoid_unused_constructor_parameters
import 'package:dio/dio.dart';

void configureWebCredentials(Dio dio) {
  // No-op on mobile/desktop — cookies are not used, tokens go via Authorization header.
}
