import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../model/auth_token.dart';
//Cung cap cac phuong thuc va thuoc tinh chung cho tuong tac Firebase
abstract class FirebaseService {
  String? _token;
  String? _userId;
  late final String? databaseUrl; //URL cua CSDL Firebase
// Nhan 1 doi tuong authtoken và gán token và Uid tương ứng. 
//Khoi tao datBUrl tu bien mtrg fire_url
  FirebaseService([AuthToken? authToken])
      : _token = authToken?.token,
        _userId = authToken?.userId {
    databaseUrl = dotenv.env['FIREBASE_URL'];
  }
//Cap nhat token va userId
  set authToken(AuthToken? authToken) {
    _token = authToken?.token;
    _userId = authToken?.userId;
  }

  @protected
  String? get token => _token;

  @protected
  String? get userId => _userId;
}