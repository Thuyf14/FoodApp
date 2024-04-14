import 'package:flutter/material.dart';
import '../../model/cart_item.dart';
import '../../model/product.dart';
import 'package:flutter/foundation.dart';

//thong bao cho cac thah phan khac ve thay doi trong du lieu gio hang
class CartManager with ChangeNotifier {
  Map<String, CartItem> _items = {};
  //so luong cac sp trong gio hang
  int get productCount {
    return _items.length;
  }
  //ds cac sp trong gio hang
  List<CartItem> get products {
    return _items.values.toList();
  }
  //tra ve 1 iterable chua cac cap khoa-gtr ca cac sp trong gio hang
  Iterable<MapEntry<String, CartItem>> get productEntries {
    return {..._items}.entries;
  }
  //tong gtr tat ca cac sp trong gio hang tu gia goc va slg
  double get totalAmount0 {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price0 * cartItem.quantity;
    });
    return total;
  }
  //tong gtr dua tren gia ban va slg
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }
  //tong slg tat ca cac sp trong gio hang
  int get totalQuantity {
    var totalQuantity = 0;
    _items.forEach((key, cartItem) {
      totalQuantity += cartItem.quantity;
    });
    return totalQuantity;
  }

  void addItem(Product product) {
    //Xac dinh xem sp da ton tai o gio hang chua
    if (_items.containsKey(product.id)) {
      //change quantity...
      //Roi, tang so luong
      _items.update(
        product.id!,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      //Chua, them moi sp vao gio hang
      _items.putIfAbsent(
        product.id!,
        () => CartItem(
          //Tao moi dtg vs thong tin sp
            id: 'c${DateTime.now().toIso8601String()}',
            productId: product.id,
            title: product.title,
            price: product.price,
            price0: product.price0,
            imageUrl: product.imageUrl,
            quantity: 1,
            category: product.category,
            author: product.author,
            coutry: product.coutry,
            ),
      );
    }
    notifyListeners();
  }
  //Xoa 1 sp khoi gio hang dua vao Id sp
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
  //Xoa 1 sp or giam slg sp -1.
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]?.quantity as num > 1) {
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
