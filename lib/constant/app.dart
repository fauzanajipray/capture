import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstant {
  static String get baseUrl =>
      '${dotenv.env['BASE_URL'] ?? "http://192.168.3.216:8100"}/api/';

  static String get baseUrlImage =>
      '${dotenv.env['BASE_URL'] ?? "http://192.168.3.216:8100"}/assets/images/';

  static String get midtransKey => dotenv.env['MIDTRANS_CLIENT_KEY'] ?? '';

  static const int apiReceiveTimeout = 15000;
  static const int apiSendTimeout = 15000;
  static const int apiConnectionTimeout = 30000;

  static const double screenMobile = 480;
  static const double screenTablet = 800;
  static const double screenDesktop = 1024;
}
