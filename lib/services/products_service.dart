import 'dart:convert';

import 'package:http/http.dart' as http;
import 'auth_services.dart';

import '../model/product.dart';

import '../model/auth_token.dart';

import '../services/firebase_services.dart';

class ProductsService extends FirebaseService {
  // ProductsService() : super();
  //nhan  authtoken hoac null, truyen authtoken vao constructor lop cha
  ProductsService([AuthToken? authToken]) : super(authToken);
  //lay ds sp tu CSDL
  //gui get den url csdl kem token xac thuc
  //loi tra ds sp trong
  //k, chuyen doi phan tu o productsMap thanh dtuong product va them vao ds products
  Future<List<Product>> fetchProducts() async {
    final List<Product> products = [];
    try {
      final authToken = (await AuthService().loadSavedAuthToken())!.token;
      // print("authToken:");
      // print(authToken);
      final productUrl =
          Uri.parse('$databaseUrl/products.json?auth=$authToken');
      // print("productUrl");
      // print(productUrl);
      final response = await http.get(productUrl);
      // print("response");
      // print(response);
      final productsMap = json.decode(response.body) as Map<String, dynamic>;
      // print("response body");
      // print(productsMap);
      if (response.statusCode != 200) {
        return products;
      }
      print(productsMap);
      productsMap.forEach((id, product) {
        products.add(Product.fromJson({
          'id': id,
          ...product,
        }));
      });
      print("products");
      print(products.length);
      print("AAAAAAAAAAAAAAa");
      return products;
    } catch (error) {
      print(error);
      return products;
    }
  }
  //Them sp moi
  //thanh cong, tra ve dtuong product moi voi ID duoc cung cap boi csdl
  Future<Product?> addProduct(Product product) async {
    try {
      final url = Uri.parse('$databaseUrl/products.json?auth=$token');
      final response =
          await http.post(url, body: json.encode(product.toJson()));
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return product.copyWith(
        id: json.decode(response.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }
  //Cap nhat thong tin sp da co
  // gui yeu cau patch vs thong tin cap nhat cua sp toi url cua sp kem theo token xac thuc
// products.forEach((id, element) => print(element));
  Future<bool> updateProduct(Product product) async {
    try {
      final url =
          Uri.parse('$databaseUrl/products/${product.id}.json?auth=$token');
      final response =
          await http.patch(url, body: json.encode(product.toJson()));

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
//Xoa 1 sp, gui yeu cau delete toi url cua sp can xoa kem token xac thuc
  Future<bool> deleteProduct(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/products/$id.json?auth=$token');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
