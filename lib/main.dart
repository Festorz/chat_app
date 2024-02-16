import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

import 'user/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String sendbirdAppId = 'BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF';
  await SendbirdChat.init(appId: sendbirdAppId);

  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Wrapper(),
      },
    );
  }
}
