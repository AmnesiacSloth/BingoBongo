import 'package:flutter/material.dart';
import 'package:bingo_bongo/api/rest.dart';
import 'package:shared_preferences/shared_preferences.dart';

// -- pages -- //
import 'package:bingo_bongo/pages/startup_page.dart';
import 'package:bingo_bongo/pages/base_page.dart';

final api = RestApi();
late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  prefs.clear(); // uncomment to preserve shared prefs
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bingo Bongo",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      // shared preferences is available globally so it can be used to dynamically route
      initialRoute:
          (prefs.getString("_username") != null) ? '/basepage' : '/startuppage',
      routes: {
        '/startuppage': (context) => StartupPage(
              prefs: prefs,
            ),
        '/basepage': (context) => BasePage(
              title: prefs.getString("_username")!,
              gamecode: prefs.getInt("_userid")!,
            ),
      },
    );
  }
}
