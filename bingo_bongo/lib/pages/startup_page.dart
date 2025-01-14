import 'package:flutter/material.dart';
import 'package:bingo_bongo/api/rest.dart';
import 'package:bingo_bongo/api/api.dart';
// -- Pages for Navigation -- //
import 'package:bingo_bongo/pages/base_page.dart';
// -- Widgets -- //

// TODO: May need to pass this in from main.dart instead of creating many
// instances of this class
final api = RestApi();

// TODO: FIND WAY TO PARSE LOCAL STORAGE FOR USER ID ASSOCIATED WITH THIS DEVICE
class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  Widget build(BuildContext context) {
    // text editing controller to access user input
    TextEditingController usernameController = TextEditingController();

    // TODO: check for locally stored user id / username first
    Future<void> _getOrCreateUserInfo(String userName) async {
      try {
        print(usernameController.text);
        final currentUser = await api.createUser(displayName: userName);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyHomePage(title: currentUser.displayName)));
      } on Exception catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating user: $error')));
      }
    }

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
                    border: OutlineInputBorder()),
              ),
              ElevatedButton(
                onPressed: () => _getOrCreateUserInfo(usernameController.text),
                child: Text("Waddup slime"),
              ),
            ],
          ),
        )));
  }
}
