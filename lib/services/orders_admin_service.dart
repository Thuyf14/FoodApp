import 'dart:convert';
import '../model/order_item.dart';
import './firebase_services.dart';
import 'package:http/http.dart' as http;
import 'auth_services.dart';

class OrderServiceAdmin extends FirebaseService {
  OrderServiceAdmin() : super();
//Lay dsach don hang dua vao trang thai don hang
  Future<List<OrderItem>> fetchOrders(value) async {
    late List<OrderItem> orders = [];
    try {
      final authToken = (await AuthService().loadSavedAuthToken())!.token;
      // final uid = (await AuthService().loadSavedAuthToken())!.userId;
      final ordersUrl = Uri.parse(
          '$databaseUrl/orders.json?orderBy="orderStatus"&equalTo=$value&auth=$authToken');
      final response = await http.get(ordersUrl);
      final ordersMap = json.decode(response.body) as Map<dynamic, dynamic>;
      if (response.statusCode != 200) {
        print(ordersMap['error']);
        return orders;
      }
      ordersMap.forEach((keys, value) {
        orders.insert(0, OrderItem.fromJson({'id': keys, ...value}));
      });
      print(ordersMap);
      return orders;
    } catch (error) {
      print(error);
      return orders;
    }
  }
    Future<List<OrderItem>> fetchOrdersAll() async {
    late List<OrderItem> orders = [];
    try {
      final authToken = (await AuthService().loadSavedAuthToken())!.token;
      // final uid = (await AuthService().loadSavedAuthToken())!.userId;
      final ordersUrl = Uri.parse(
          '$databaseUrl/orders.json?orderBy="orderStatus"&auth=$authToken');
      final response = await http.get(ordersUrl);
      final ordersMap = json.decode(response.body) as Map<dynamic, dynamic>;
      if (response.statusCode != 200) {
        print(ordersMap['error']);
        return orders;
      }
      ordersMap.forEach((keys, value) {
        orders.insert(0, OrderItem.fromJson({'id': keys, ...value}));
      });
      return orders;
    } catch (error) {
      print(error);
      return orders;
    }
  }

 
}
