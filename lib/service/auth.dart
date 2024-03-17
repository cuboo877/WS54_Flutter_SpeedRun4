import 'package:ws54_flutter_speedrun4/service/data_model.dart';
import 'package:ws54_flutter_speedrun4/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun4/service/sql_service.dart';

class Auth {
  static Future<bool> loginAuth(String account, String password) async {
    try {
      UserData userData =
          await UserDB.getUserDataByAccountAndPassword(account, password);
      await sharedPref.setLoggedUserID(userData.id);
      print("get registerd userData. set logged user");
      return true;
    } catch (e) {
      print("didnt get any userData");
      return false;
    }
  }

  static Future<bool> hasAccountBeenRegistered(String account) async {
    try {
      UserData userData = await UserDB.getUserDataByAccount(account);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> registerAuth(UserData userData) async {
    await UserDB.addUserData(userData);
    await sharedPref.setLoggedUserID(userData.id);
    print("add userdata ! ${userData.id}");
  }

  static Future<void> logOut() async {
    await sharedPref.removeLoggedUserID();
    print("loggout");
  }
}
