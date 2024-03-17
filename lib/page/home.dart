import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:ws54_flutter_speedrun4/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun4/page/user.dart';
import 'package:ws54_flutter_speedrun4/service/sql_service.dart';
import 'package:ws54_flutter_speedrun4/service/utilities.dart';

import '../service/auth.dart';
import '../service/data_model.dart';
import '../widget/text_button.dart';
import 'add_password.dart';
import 'edit.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PasswordData> passwordList = [];
  bool isSearching = false;

  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  late TextEditingController id_controller;

  bool hasFav = false;
  int isFav = 1;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isSearching
          ? setSearchingPasswordList()
          : setCurrentUserAllPasswordList();
    });
    super.initState();
    tag_controller = TextEditingController();
    url_controller = TextEditingController();
    login_controller = TextEditingController();
    password_controller = TextEditingController();
    id_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    id_controller.dispose();
    super.dispose();
  }

  void setCurrentUserAllPasswordList() async {
    List<PasswordData> result =
        await PasswordDB.getAllPasswordListDataByUserID(widget.userID);
    if (result.isNotEmpty) {
      setState(() {
        isSearching = false;
        passwordList = result;
      });
      print("got password list! :${passwordList.length}");
    } else {
      setState(() {
        isSearching = false;
        passwordList = [];
      });
      print("didnt get any password list");
    }
  }

  void setSearchingPasswordList() async {
    List<PasswordData> result = await PasswordDB.getPasswordDataListByCondition(
        widget.userID,
        tag_controller.text,
        url_controller.text,
        login_controller.text,
        password_controller.text,
        id_controller.text,
        hasFav,
        isFav);
    if (result.isNotEmpty) {
      setState(() {
        isSearching = true;
        passwordList = result;
      });
      print("got password list! :${passwordList.length}");
    } else {
      setState(() {
        isSearching = true;
        passwordList = [];
      });
      print("didnt get any password list");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.black,
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPasswordPage(userID: widget.userID)))),
      drawer: navDrawer(context),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topBar(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child:
              Column(children: [searchArea(context), passwordListViewBuider()]),
        ),
      ),
    );
  }

  Widget searchArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            border: Border.all(width: 2.0)),
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const Text("標籤"),
          TextFormField(controller: tag_controller),
          const Text("網址"),
          TextFormField(controller: url_controller),
          const Text("登入帳號"),
          TextFormField(controller: login_controller),
          const Text("密碼"),
          TextFormField(controller: password_controller),
          const Text("ID"),
          TextFormField(controller: id_controller),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: CheckboxListTile(
                      title: const Text("包含我的最愛"),
                      value: hasFav,
                      onChanged: (value) => setState(() {
                            hasFav = !hasFav;
                          }))),
              Expanded(
                  child: CheckboxListTile(
                      enabled: hasFav,
                      title: const Text("我的最愛"),
                      value: isFav == 0 ? false : true,
                      onChanged: (value) => setState(() {
                            isFav = isFav == 0 ? 1 : 0;
                          }))),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextButton.customTextButton(AppColor.black, "搜尋", 20,
                  () async {
                setSearchingPasswordList();
                if (mounted) {
                  Utilities.showSnackBar(context, "已搜尋", 1);
                }
              }),
              AppTextButton.customTextButton(AppColor.black, "清除設定", 20, () {
                setState(() {
                  tag_controller.text = "";
                  url_controller.text = "";
                  login_controller.text = "";
                  password_controller.text = "";
                  id_controller.text = "";
                  hasFav = false;
                  isFav = 1;
                });
                Utilities.showSnackBar(context, "已清除設定", 1);
              }),
              AppTextButton.customTextButton(AppColor.black, "取消搜尋", 20, () {
                setCurrentUserAllPasswordList();
                Utilities.showSnackBar(context, "已取消搜尋", 1);
              })
            ],
          )
        ]),
      ),
    );
  }

  Widget passwordListViewBuider() {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: passwordList.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: passwordDataColumn(context, passwordList[index]),
          );
        }));
  }

  Widget passwordDataColumn(BuildContext context, PasswordData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          border: Border.all(width: 2.0)),
      child: Column(children: [
        Text("標籤 ${data.tag}"),
        Text("網址 ${data.url}"),
        Text("登入帳號 ${data.login}"),
        Text("密碼 ${data.password}"),
        Text("ID ${data.id}"),
        Row(
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    side: const BorderSide(color: AppColor.red, width: 2.0),
                    shape: const CircleBorder(),
                    backgroundColor:
                        data.isFav == 0 ? AppColor.white : AppColor.red,
                    iconColor: data.isFav == 1 ? AppColor.white : AppColor.red),
                onPressed: () async {
                  setState(() {
                    data.isFav = data.isFav == 1 ? 0 : 1;
                  });
                  await PasswordDB.updatePasswordData(data);
                  print("update password data isFav :${data.isFav}");
                },
                child: Icon(
                    data.isFav == 1 ? Icons.favorite : Icons.favorite_border)),
            TextButton(
                style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: AppColor.green),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditPage(
                          data: data,
                        ))),
                child: const Icon(
                  Icons.edit,
                  color: AppColor.white,
                )),
            TextButton(
                style: TextButton.styleFrom(
                    shape: const CircleBorder(), backgroundColor: AppColor.red),
                onPressed: () async {
                  await PasswordDB.remvoePasswordDataByPasswordID(data.id);
                  if (mounted) {
                    isSearching
                        ? setSearchingPasswordList()
                        : setCurrentUserAllPasswordList();
                    Utilities.showSnackBar(context, "已刪除", 1);
                  }
                  print("delete password");
                },
                child: const Icon(
                  Icons.delete,
                  color: AppColor.white,
                ))
          ],
        )
      ]),
    );
  }

  Widget navDrawer(BuildContext context) {
    return Drawer(
      width: 320,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close)),
              Image.asset(
                "assets/icon.png",
                width: 23,
                height: 23,
              )
            ],
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("主畫面"),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("帳號設置"),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserPage(userID: widget.userID)))),
          logOutButton(context)
        ]),
      ),
    );
  }

  Widget topBar() {
    return AppBar(
        title: const Text("主畫面"),
        backgroundColor: AppColor.black,
        centerTitle: true);
  }

  Widget logOutButton(BuildContext context) {
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
