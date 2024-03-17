import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:ws54_flutter_speedrun4/page/home.dart';
import 'package:ws54_flutter_speedrun4/service/data_model.dart';
import 'package:ws54_flutter_speedrun4/service/sql_service.dart';
import 'package:ws54_flutter_speedrun4/service/utilities.dart';
import 'package:ws54_flutter_speedrun4/widget/text_button.dart';

import '../constant/style_guide.dart';

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  int isFav = 0;

  bool isTagValid = false;
  bool isUrlValid = false;
  bool isLoginValid = false;
  bool isPasswordValid = false;

  bool hasLowerCase = true;
  bool hasUpperCase = true;
  bool hasSymbol = true;
  bool hasNumber = true;
  String customChars = "";
  int length = 16;

  late TextEditingController customChars_controller;

  @override
  void initState() {
    super.initState();
    tag_controller = TextEditingController();
    url_controller = TextEditingController();
    login_controller = TextEditingController();
    password_controller = TextEditingController();
    customChars_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    customChars_controller.dispose();
    super.dispose();
  }

  PasswordData packPasswordData() {
    return PasswordData(
        Utilities.randomID(),
        widget.userID,
        tag_controller.text,
        url_controller.text,
        login_controller.text,
        password_controller.text,
        isFav);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topBar(context),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text("標籤"),
              const SizedBox(height: 20),
              tagTextForm(),
              const SizedBox(height: 20),
              const Text("網址"),
              const SizedBox(height: 20),
              urlTextForm(),
              const SizedBox(height: 20),
              const Text("登入帳號"),
              const SizedBox(height: 20),
              loginTextForm(),
              const SizedBox(height: 20),
              const Text("密碼"),
              const SizedBox(height: 20),
              passwordTextForm(),
              const SizedBox(height: 20),
              favButton(),
              const SizedBox(height: 20),
              randomSettingButton(context),
              const SizedBox(height: 20),
              submitCreateButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget submitCreateButton(BuildContext context) {
    return AppTextButton.customTextButton(AppColor.black, "創建", 35, () async {
      if (isLoginValid && isPasswordValid && isTagValid && isUrlValid) {
        await PasswordDB.addPasswordData(packPasswordData());
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.userID)));
          Utilities.showSnackBar(context, "已新增密碼!!!", 2);
        }
        print("add passwordData!");
      } else {
        Utilities.showSnackBar(context, "請確認輸入", 2);
      }
    });
  }

  Widget tagTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: tag_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isTagValid = false;
            return "請輸入";
          } else {
            isTagValid = true;
            return null;
          }
        },
        decoration: const InputDecoration(
            hintText: "tag",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(45)))),
      ),
    );
  }

  Widget urlTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: url_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isUrlValid = false;
            return "請輸入";
          } else {
            isUrlValid = true;
            return null;
          }
        },
        decoration: const InputDecoration(
            hintText: "url",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(45)))),
      ),
    );
  }

  Widget loginTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: login_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isLoginValid = false;
            return "請輸入";
          } else {
            isLoginValid = true;
            return null;
          }
        },
        decoration: const InputDecoration(
            hintText: "login account",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(45)))),
      ),
    );
  }

  Widget passwordTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: password_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isPasswordValid = false;
            return "請輸入";
          } else {
            isPasswordValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    password_controller.text = Utilities.randomPassword(
                        hasLowerCase,
                        hasUpperCase,
                        hasSymbol,
                        hasNumber,
                        customChars_controller.text,
                        length);
                  });
                },
                icon: const Icon(Icons.casino)),
            hintText: "password",
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(45)))),
      ),
    );
  }

  Widget favButton() {
    return TextButton(
        style: TextButton.styleFrom(
            side: const BorderSide(color: AppColor.red, width: 2.0),
            shape: const CircleBorder(),
            backgroundColor: isFav == 0 ? AppColor.white : AppColor.red,
            iconColor: isFav == 1 ? AppColor.white : AppColor.red),
        onPressed: () {
          setState(() {
            isFav = isFav == 1 ? 0 : 1;
          });
        },
        child: Icon(isFav == 1 ? Icons.favorite : Icons.favorite_border));
  }

  Widget randomSettingButton(BuildContext context) {
    return AppTextButton.customTextButton(AppColor.black, "隨機設定", 30, () async {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("隨機設定"),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text("指定字"),
                  TextFormField(controller: customChars_controller),
                  CheckboxListTile(
                      title: const Text("包含小寫字母"),
                      value: (hasLowerCase),
                      onChanged: (value) =>
                          setState(() => hasLowerCase = !hasLowerCase)),
                  CheckboxListTile(
                      title: const Text("包含大寫字母"),
                      value: (hasUpperCase),
                      onChanged: (value) =>
                          setState(() => hasUpperCase = !hasUpperCase)),
                  CheckboxListTile(
                      title: const Text("包含符號"),
                      value: (hasSymbol),
                      onChanged: (value) =>
                          setState(() => hasSymbol = !hasSymbol)),
                  CheckboxListTile(
                      title: const Text("包含數字"),
                      value: (hasNumber),
                      onChanged: (value) =>
                          setState(() => hasNumber = !hasNumber)),
                  Row(
                    children: [
                      Slider(
                          min: 1,
                          max: 20,
                          divisions: 19,
                          value: (length.toDouble()),
                          onChanged: (value) =>
                              setState(() => length = value.toInt())),
                      Text(length.toString())
                    ],
                  )
                ]),
              );
            });
          });
    });
  }

  Widget topBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColor.white,
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: AppColor.black)),
      title: const Text(
        "創建您的密碼",
        style: TextStyle(color: AppColor.black),
      ),
    );
  }
}
