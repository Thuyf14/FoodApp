import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import '../../model/order_item.dart';
import '../../services/orders_admin_service.dart';
//Quan ly don hang
class FilterOrderAdminManager with ChangeNotifier {
  final OrderServiceAdmin _orderService = OrderServiceAdmin();
  //ds toan bo don hang
  late List<OrderItem> _orders = [];
  //ds don hang da dc loc
  late List<OrderItem> data = [];
  //ds don hang chua dc loc
  late List<OrderItem> _orders1 = [];
  //slg don hang trong ds dc loc
  int get orders1Count {
    return _orders1.length;
  }

  List<OrderItem> get orders1 {
    return [..._orders1];
  }
  //Lay ds don hang tu service va loc 
  Future<List<OrderItem>> fetchOrders() async {
    _orders1 = await _orderService.fetchOrders(3);
    print(_orders1);
    var quater = 1;
    var year = 2024;
      final startMonth = (quater - 1) * 3 + 1;
      final endMonth = startMonth + 11;
      return data=_orders1
          .where((e) =>
              e.dateTime.year == year &&
              e.dateTime.month >= startMonth &&
              e.dateTime.month <= endMonth)
          .toList();
  }
}
