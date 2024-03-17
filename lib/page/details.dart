import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun4/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun4/page/home.dart';
import 'package:ws54_flutter_speedrun4/service/auth.dart';
import 'package:ws54_flutter_speedrun4/service/data_model.dart';
import 'package:ws54_flutter_speedrun4/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun4/service/utilities.dart';
import 'package:ws54_flutter_speedrun4/widget/text_button.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.account, required this.password});
  final String account;
  final String password;
  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late TextEditingController username_controller;
  late TextEditingController birthday_controller;

  bool isUserNameValid = false;
  bool isBirthdayValid = false;

  @override
  void initState() {
    super.initState();
    username_controller = TextEditingController();
    birthday_controller = TextEditingController();
  }

  @override
  void dispose() {
    username_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  UserData packUserData() {
    return UserData(Utilities.randomID(), username_controller.text,
        widget.account, widget.password, birthday_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topBar(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [
            const SizedBox(height: 20),
            const Text("使用者基本資料", style: TextStyle(fontSize: 40)),
            const SizedBox(height: 20),
            const Text('名稱', style: TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            usernameTextForm(),
            const Text('生日', style: TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            birthdayTextForm(),
            const SizedBox(height: 20),
            startToUseButton(),
          ]),
        ),
      ),
    );
  }

  Widget startToUseButton() {
    return AppTextButton.customTextButton(AppColor.black, "開始使用", 30, () async {
      if (isBirthdayValid && isUserNameValid) {
        await Auth.registerAuth(packUserData());
        String userID = await sharedPref.getLoggedUserID();
        if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomePage(userID: userID)));
          Utilities.showSnackBar(context, "您好! 歡迎使用!", 2);
        }
      } else {
        Utilities.showSnackBar(context, "請確認輸入資料", 2);
      }
    });
  }

  Widget usernameTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: username_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isUserNameValid = false;
            return "請輸入稱呼您的名稱";
          } else {
            isUserNameValid = true;
            return null;
          }
        },
        decoration: const InputDecoration(
            hintText: "username",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(45)))),
      ),
    );
  }

  Widget birthdayTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: birthday_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        readOnly: true,
        onTap: () async {
          DateTime? _picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2026));
          if (_picked != null) {
            isBirthdayValid = true;
            setState(() {
              birthday_controller.text = _picked.toString().split(" ")[0];
            });
          } else {
            isBirthdayValid = false;
          }
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isUserNameValid = false;
            return "請輸入生日";
          } else {
            isUserNameValid = true;
            return null;
          }
        },
        decoration: const InputDecoration(
            hintText: "YYYY-MM-DD",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(45)))),
      ),
    );
  }

  Widget topBar() {
    return AppBar(title: const Text('即將完成註冊'), backgroundColor: AppColor.black);
  }
}
