import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplysync/providers/private_key_provider.dart';
import 'package:supplysync/screens/lock_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PrivateKeyProvider(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Supply Sync',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1a1a2e),
          primaryColor: const Color(0xFF16213e),
        ),
        home: const LockScreen(),
      ),
    );
  }
}
