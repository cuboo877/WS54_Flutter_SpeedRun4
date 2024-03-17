import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun4/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun4/page/home.dart';
import 'package:ws54_flutter_speedrun4/page/register.dart';
import 'package:ws54_flutter_speedrun4/service/auth.dart';
import 'package:ws54_flutter_speedrun4/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun4/service/utilities.dart';
import 'package:ws54_flutter_speedrun4/widget/text_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController account_controlelr;
  late TextEditingController password_controller;
  bool doAuthWarning = false;
  bool isAccountValid = false;
  bool isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    account_controlelr = TextEditingController();
    password_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controlelr.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [
            Image.asset(
              "assets/icon.png",
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text("登入", style: TextStyle(fontSize: 40)),
            const SizedBox(height: 20),
            const Text('帳號', style: TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            accountTextForm(),
            const SizedBox(height: 20),
            const Text('密碼', style: TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            passwordTextForm(),
            const SizedBox(height: 20),
            loginSubmitButton(),
            const SizedBox(height: 20),
            loginToRegitserTextColumn()
          ]),
        ),
      ),
    );
  }

  Widget loginToRegitserTextColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("尚未擁有帳號?", style: TextStyle(fontSize: 20)),
        InkWell(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterPage())),
          child: const Text(
            "註冊",
            style: TextStyle(fontSize: 30, color: AppColor.darkBlue),
          ),
        )
      ],
    );
  }

  Widget loginSubmitButton() {
    return AppTextButton.customTextButton(AppColor.black, "登入", 30, () async {
      if (isAccountValid && isPasswordValid) {
        bool reuslt = await Auth.loginAuth(
            account_controlelr.text, password_controller.text);
        if (reuslt) {
          String userID = await sharedPref.getLoggedUserID();
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(userID: userID)));
          }
        } else {
          setState(() {
            doAuthWarning = true;
            Utilities.showSnackBar(context, "登入失敗!", 2);
          });
        }
      } else {
        Utilities.showSnackBar(context, "請確認輸入資料!", 2);
      }
    });
  }

  Widget accountTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: account_controlelr,
        onChanged: (value) => setState(() {
          doAuthWarning = false;
        }),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (doAuthWarning) {
            isAccountValid = false;
            return "";
          } else if (value == null || value.trim().isEmpty) {
            isAccountValid = false;
            return "請輸入帳號";
          } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
              .hasMatch(value)) {
            isAccountValid = false;
            return "請輸入正確的格式";
          } else {
            isAccountValid = true;
            return null;
          }
        },
        decoration: const InputDecoration(
            hintText: "email",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(45)))),
      ),
    );
  }

  bool obscure = true;
  Widget passwordTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        obscureText: obscure,
        controller: password_controller,
        onChanged: (value) => setState(() {
          doAuthWarning = false;
        }),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (doAuthWarning) {
            isPasswordValid = false;
            return "";
          } else if (value == null || value.trim().isEmpty) {
            isPasswordValid = false;
            return "請輸入密碼";
          } else {
            isPasswordValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "password",
            suffixIcon: IconButton(
                onPressed: () => setState(() {
                      obscure = !obscure;
                    }),
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility)),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(45)))),
      ),
    );
  }
}
