import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../chatPage.dart';
import '../widgets/boldtext.dart';
import '../widgets/snackbar.dart';
import 'userLogin.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool? loggedIn;
  String? userId = '';

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => processUser());
  }

  Future processUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // const String sendbirdAppId = 'BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF';

    loggedIn = (preferences.getBool('loggedIn') ?? false);
    userId = (preferences.getString('userID') ?? '');

    if (loggedIn! && userId!.isNotEmpty) {
      try {
        // SendbirdChat.init(appId: sendbirdAppId);
        await SendbirdChat.connect(userId!).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        });
      } catch (e) {
        Appsnackbar.snackbar(
            context, "error occured, restart app again!", Colors.pink, null);
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: BoldText(
          text: "Chat App",
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}
