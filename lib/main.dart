import 'package:capture/features/auth/presentations/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  // WidgetsBinding widgetsBinding =
  WidgetsFlutterBinding.ensureInitialized();
  // final storage = await HydratedStorage.build(
  //     storageDirectory: kIsWeb
  //         ? HydratedStorage.webStorageDirectory
  //         : await getApplicationDocumentsDirectory());
  // HydratedBloc.storage = storage;
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await initializeDateFormatting('id_ID', null);
  // await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SignInPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF304AAC),
          secondary: const Color.fromARGB(255, 57, 81, 98),
          onSurfaceVariant: Colors.grey,
        ),
      ),
    );
  }
}
