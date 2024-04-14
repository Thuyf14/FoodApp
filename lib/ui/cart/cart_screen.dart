import 'package:flutter/material.dart';
import 'package:foodapp/ui/payment_cart/payment_cart_screen.dart';
import 'package:foodapp/ui/shared/app_drawer.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shopbansach/ui/payment_cart/payment_cart_screen.dart';
// import 'package:shopbansach/ui/order/orders_screen.dart';

// import '../order/order_manager.dart';
import 'cart_manager.dart';
import 'cart_item_card.dart';

//Gio hang, phan tong tien va nut dat hang
class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    // final cart = CartManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: <Widget>[
          buildCartSummary(cart, context),
          const SizedBox(height: 10),

          Expanded(
            child: cart.productCount == 0 ? Center(child: Text("Giỏ hàng trống!"),): buildCartDetails(cart),
          )
        ],
      ),
    );
  }
  //Dsach cac sp trong gio hang
  Widget buildCartDetails(CartManager cart) {
    return ListView(
      children: cart.productEntries
          .map(
            (entry) => CartItemCard(
              productId: entry.key,
              cardItem: entry.value,
            ),
          )
          .toList(),
    );
  }
  //Xay dung thanh tren gio hang: tong tien va nut dat hang
  Widget buildCartSummary(CartManager cart, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'TỔNG',
              style: TextStyle(fontSize: 20),
            ),
            const Spacer(),
            Chip(
              label: Text(
                '${cart.totalAmount.toStringAsFixed(0)}', // Định dạng số thành số nguyên
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            TextButton(
              //Neu tong tien lon hon 0, nhan dat hang thi chuyen den PaymentCartScreen
              onPressed: 
              // (){
              //   print("di den trang dat hang");
              // },
              cart.totalAmount <= 0
                  ? null
                  : () {
                      Navigator.of(context)
                          .pushNamed(PaymentCartScreen1.routeName);
                    },
              style: TextButton.styleFrom(
                textStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
              child: const Text('ĐẶT HÀNG'),
            ),
          ],
        ),
      ),
    );
  }
}
