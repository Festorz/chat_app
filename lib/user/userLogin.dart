import 'package:chat_app/chatPage.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/size_util.dart';
import '../widgets/appbutton.dart';
import '../widgets/apptext.dart';
import '../widgets/boldtext.dart';
import '../widgets/snackbar.dart';
import '../widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final String sendbirdAppId = 'BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF';

  bool loading = false;

// controllers
  final TextEditingController _userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = mediaQueryData.size.width;
    double h = mediaQueryData.size.height;

    Color black = Colors.black;
    Color bblack = Colors.black38;
    Color white = Colors.white;
    Color maincolor = Colors.white;
    Color pink = Colors.pink[600]!;

    return Scaffold(
      backgroundColor: black,
      body: Container(
        color: black,
        width: w,
        height: h,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoldText(text: 'CHAT APP', size: getFontSize(40), color: pink),
              SizedBox(height: getVerticalSize(50)),
              BoldText(
                  text: 'Sign in', size: getFontSize(25), color: maincolor),
              SizedBox(height: h * 0.03),
              Container(
                width: w,
                padding: getPadding(left: 20, right: 20, bottom: 20),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(40)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(text: "USER ID", size: 14, color: white),
                      SizedBox(height: getVerticalSize(3)),
                      AppTextFormfield(
                        controller: _userIdController,
                        hint: "User ID",
                        icon: null,
                        type: TextInputType.emailAddress,
                        color: white,
                        fillColor: white,
                        hintColor: bblack,
                        iconColor: black,
                        inputColor: black,
                        padding: 10,
                        width: 1.0,
                        radius: 10,
                      ),
                      SizedBox(height: getVerticalSize(50)),
                      Center(
                        child: Center(
                            child: GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              connect(sendbirdAppId, _userIdController.text)
                                  .then((user) async {
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                preferences.setBool('loggedIn', true);
                                preferences.setString(
                                    'userID', _userIdController.text);

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ChatPage()));
                              });
                            }
                          },
                          child: AppButton(
                              color: white,
                              backgroundColor: pink,
                              text: "Sign in",
                              bold: false,
                              size: w * 0.9,
                              borderColor: maincolor),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: getVerticalSize(20)),
              loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white60,
                        strokeWidth: 2,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Future<User> connect(String appId, String userId) async {
    // Init Sendbird SDK and connect with current user id
    try {
      // SendbirdChat.init(appId: appId);
      final user = await SendbirdChat.connect(userId);
      setState(() {
        loading = false;
      });
      return user;
    } catch (e) {
      setState(() {
        loading = false;
      });

      Appsnackbar.snackbar(
          context, 'Error occured, please try again!', Colors.pink, null);
      rethrow;
    }
  }
}
