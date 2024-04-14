import 'dart:convert';
import '../services/firebase_services.dart';
import 'package:http/http.dart' as http;
import '../services/auth_services.dart';

//Lay thong tin va cap nhat thog tin nguoi dung
class UserService extends FirebaseService {
  UserService() : super();
  //Lay ttin user tu CSDL
  //Lay uid cua user hien tai tu token xac thuc
  //Tao duong dan url de truy van CSDL frebase, chi lay tt user co cung uid
  //gui yeu cau http get den url tao
  
  Future<Map<String, dynamic>> fetchUserInformation() async {
    late Map<String, dynamic> data = {};
    try {
      final uid = (await AuthService().loadSavedAuthToken())!.userId;
      final userInforUrl = Uri.parse(
          '$databaseUrl/users.json?auth=$token&orderBy="uid"&equalTo="$uid"');
      final response = await http.get(userInforUrl);
      data = json.decode(response.body);
      var key = data.keys.first;
      data = data[key];

      if (response.statusCode != 200) {
        return data;
      }

      return data;
    } catch (error) {
      print(error);
      return data;
    }
  }
  //Cap nhat thong tin
  //Lay uid tu token xac thuc
  //Tao url, lay thong tin user co cung uid
  //Gui htp get lay tt
  //trich xuat key cua user tu du lieu tra ve
  //Tao url cap nhat thong tin dua tren key da lay
  Future<void> updateUserInformation(Map<String, dynamic> updateInfor) async {
    try {
      final uid = (await AuthService().loadSavedAuthToken())!.userId;
      final userInforUrl = Uri.parse(
          '$databaseUrl/users.json?auth=$token&orderBy="uid"&equalTo="$uid"');
      final response = await http.get(userInforUrl);
      var key = json.decode(response.body).keys.first;

      final updateUrl = Uri.parse('$databaseUrl/users/${key}.json?auth=$token');
      final updateResponse =
          await http.patch(updateUrl, body: json.encode(updateInfor));

      if (updateResponse.statusCode != 200) {
        throw Exception(json.decode(updateResponse.body)['error']);
      }
    } catch (error) {
      print(error);
    }
  }
}
