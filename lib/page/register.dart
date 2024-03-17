import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun4/page/login.dart';
import 'package:ws54_flutter_speedrun4/service/sharedPref.dart';

import '../constant/style_guide.dart';
import '../service/auth.dart';
import '../service/utilities.dart';
import '../widget/text_button.dart';
import 'details.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController account_controlelr;
  late TextEditingController password_controller;
  late TextEditingController confirm_controller;
  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool isConfirmValid = false;
  @override
  void initState() {
    super.initState();
    account_controlelr = TextEditingController();
    password_controller = TextEditingController();
    confirm_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controlelr.dispose();
    password_controller.dispose();
    confirm_controller.dispose();
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
            confirmTextForm(),
            const SizedBox(height: 20),
            registerSubmitButton(),
            const SizedBox(height: 20),
            registerToLoginTextColumn()
          ]),
        ),
      ),
    );
  }

  Widget registerToLoginTextColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("尚未擁有帳號?", style: TextStyle(fontSize: 20)),
        InkWell(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LoginPage())),
          child: const Text(
            "登入",
            style: TextStyle(fontSize: 30, color: AppColor.darkBlue),
          ),
        )
      ],
    );
  }

  Widget registerSubmitButton() {
    return AppTextButton.customTextButton(AppColor.black, "註冊", 30, () async {
      if (isAccountValid && isPasswordValid) {
        if (isAccountValid && isConfirmValid && isPasswordValid) {
          bool hasRegistered = await Auth.hasAccountBeenRegistered(
              account_controlelr.text.trim());
          if (hasRegistered) {
            if (mounted) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()));
              Utilities.showSnackBar(context, "此帳號已註冊", 2);
            }
          } else {
            if (mounted) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailsPage(
                      account: account_controlelr.text,
                      password: password_controller.text)));
              print(
                  "${account_controlelr.text}, ${password_controller.text} : register");
            }
          }
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
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

  bool obscure2 = true;
  Widget confirmTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        obscureText: obscure2,
        controller: confirm_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value != password_controller.text.trim()) {
            isConfirmValid = false;
            return "請確認密碼";
          } else if (value == null || value.trim().isEmpty) {
            isConfirmValid = false;
            return "請輸入密碼";
          } else {
            isConfirmValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "confirm password",
            suffixIcon: IconButton(
                onPressed: () => setState(() {
                      obscure2 = !obscure2;
                    }),
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility)),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(45)))),
      ),
    );
  }
}
