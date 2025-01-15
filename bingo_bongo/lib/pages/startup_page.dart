import 'package:flutter/material.dart';
import 'package:bingo_bongo/api/rest.dart';
import 'package:shared_preferences/shared_preferences.dart';

final api = RestApi();

class StartupPage extends StatefulWidget {
  final SharedPreferences prefs;
  const StartupPage({super.key, required this.prefs});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  // Function to save value to SharedPreferences
  void _saveUsernameUID(String username, int uid) async {
    await widget.prefs.setString("_username", username);
    await widget.prefs.setInt("_userid", uid);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _createUserInfo(String userName) async {
      try {
        // create user in database and save credentials to shareds prefs
        final currentUser = await api.createUser(displayName: userName);
        _saveUsernameUID(currentUser.displayName, currentUser.id);
        Navigator.pushNamed(context, '/basepage');
      } on Exception catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating user: $error'),
          ),
        );
      }
    }

    // text editing controller to access user input
    TextEditingController usernameController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Welcome to Bingo Bongo!",
          ),
          centerTitle: true,
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.card_membership,
                  size: 100), // TODO: LOGO & adjust spacing within column
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Enter your username here",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () => _createUserInfo(usernameController.text),
                child: Text("waddup slime"),
              ),
            ],
          ),
        )));
  }
}
