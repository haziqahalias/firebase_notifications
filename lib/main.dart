import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_handleMessage);

  runApp(MyApp());
}

Future<void> _handleMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  print(message.notification!.body);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Notifs!',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();

    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) => {print('token is: $value')});

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print('message received! :3');
      print('message is ${event.notification!.body}');

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Notification from Firebase!'),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK!!!!!!'))
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('Notification is clicked!');
    });
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
