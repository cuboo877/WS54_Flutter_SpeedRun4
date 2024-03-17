import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun4/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun4/page/home.dart';
import 'package:ws54_flutter_speedrun4/page/login.dart';
import 'package:ws54_flutter_speedrun4/service/auth.dart';
import 'package:ws54_flutter_speedrun4/service/sql_service.dart';
import 'package:ws54_flutter_speedrun4/service/utilities.dart';
import 'package:ws54_flutter_speedrun4/widget/text_button.dart';

import '../service/data_model.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late TextEditingController username_controller;
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  late TextEditingController birthday_controller;
  UserData userData = UserData("", "", "", "", "");

  bool isEdited = false;

  bool isAccountValid = true;
  bool isPasswordValid = true;
  bool isUserNameValid = true;
  bool isBirthdayValid = true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setCurrentUserDataControllerText();
    });
    super.initState();
    username_controller = TextEditingController(text: userData.username);
    account_controller = TextEditingController(text: userData.account);
    password_controller = TextEditingController(text: userData.password);
    birthday_controller = TextEditingController(text: userData.birthday);
  }

  @override
  void dispose() {
    username_controller.dispose();
    account_controller.dispose();
    password_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  void setCurrentUserDataControllerText() async {
    UserData _userData = await UserDB.getUserDataByUserID(widget.userID);
    setState(() {
      username_controller.text = _userData.username;
      account_controller.text = _userData.account;
      password_controller.text = _userData.password;
      birthday_controller.text = _userData.birthday;
    });
  }

  UserData packUserData() {
    return UserData(
        widget.userID,
        username_controller.text,
        account_controller.text,
        password_controller.text,
        birthday_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(children: [
          const Text('使用者名稱', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          usernameTextForm(),
          const Text('帳號', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          accountTextForm(),
          const Text('密碼', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          passwordTextForm(),
          const Text('生日', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          birthdayTextForm(),
          const SizedBox(height: 20),
          submitEditButton(),
          const SizedBox(height: 20),
          logOutButton()
        ]),
      ),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: topBar()),
    );
  }

  Widget submitEditButton() {
    return AppTextButton.customTextButton(AppColor.black, "編輯完成", 30, () async {
      if (isEdited) {
        if (isAccountValid &&
            isBirthdayValid &&
            isPasswordValid &&
            isUserNameValid) {
          await UserDB.updateUserData(packUserData());
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(userID: widget.userID)));
            Utilities.showSnackBar(context, "已變更使用者資料!", 2);
          }
          print("updated userData!");
        } else {
          Utilities.showSnackBar(context, "請確認輸入資料", 2);
        }
      } else {
        Utilities.showSnackBar(context, "尚未變更任何資料", 2);
      }
    });
  }

  Widget accountTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: account_controller,
        onChanged: (value) => setState(() {
          isEdited = true;
        }),
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
        onChanged: (value) => setState(() {
          isEdited = true;
        }),
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

  Widget usernameTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: username_controller,
        onChanged: (value) => setState(() {
          isEdited = true;
        }),
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
        onChanged: (value) => setState(() {
          isEdited = true;
        }),
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
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColor.white,
      leading: IconButton(
          onPressed: () {
            if (isEdited) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        title: const Text("確定要離開嗎"),
                        actions: [
                          AppTextButton.customTextButton(
                              AppColor.green, "儲存並離開", 20, () async {
                            await UserDB.updateUserData(packUserData());
                            if (mounted) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(userID: widget.userID)));
                            }
                          }),
                          AppTextButton.customTextButton(
                              AppColor.darkBlue, "繼續編輯", 20, () async {
                            Navigator.of(context).pop();
                          }),
                          AppTextButton.customTextButton(AppColor.red, "離開", 20,
                              () async {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(userID: widget.userID)));
                          })
                        ],
                        actionsAlignment: MainAxisAlignment.center,
                      );
                    });
                  });
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(Icons.arrow_back, color: AppColor.black)),
      title: const Text(
        "帳戶設置",
        style: TextStyle(color: AppColor.black),
      ),
    );
  }

  Widget logOutButton() {
    return AppTextButton.outlineButton(AppColor.white, AppColor.red, "登出", 30,
        () async {
      await Auth.logOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }
}
