import 'package:bingo_bongo/api/rest.dart';
import 'package:flutter/material.dart';

final api = RestApi();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bingo Bongo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Bingo Bongo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isChecked = false;

  void _checkBox(BuildContext context, int index) {
    setState(() {
      _isChecked = !_isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: 100,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text('Game code : ####'),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Icon(size: 35, Icons.leaderboard),
          Icon(size: 35, Icons.settings),
        ],
      ),
      backgroundColor: const Color.fromARGB(221, 36, 32, 32),
      body: Center(
        child: GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.all(4),
          childAspectRatio: .5,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          crossAxisCount: 5,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(25, (index) {
            return ElevatedButton(
              key: ValueKey("bingo-button-$index"),
              onLongPress: () => {_checkBox(context, index)},
              onPressed: () => {print('$index')}, // TODO
              style: ElevatedButton.styleFrom(
                backgroundColor: _isChecked
                    ? const Color.fromARGB(255, 94, 201, 96)
                    : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child: Text(
                '$index',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }),
        ),
      ),
    );
  }
}
