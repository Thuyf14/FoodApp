import 'package:flutter/material.dart';
import 'package:foodapp/ui/shared/app_drawer.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import '../shared/app_drawer_admin.dart';
import 'edit_product_screen.dart';
import 'search_admin.dart';
import 'user_product_list_title.dart';

import '../products/products_manager.dart';
//Hien thi danh sach sp cua nguoi dung
class UserProductsScreen extends StatelessWidget {
  static const routeName = '/admin-product';
  const UserProductsScreen({super.key});

  Future<void> _refreshProduct(BuildContext context) async {
    await context.read<ProductsManager>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsManager = ProductsManager();
    return Scaffold(
      //tim kiem, them sp moi trong appbar
        appBar: AppBar(
          title: const Text('Admin'),
          actions: [
            searchProduct(context),
            buildAddButton(context),
          ],
        ),
        drawer: const AdminAppDrawer(),
        body: FutureBuilder(
            future: _refreshProduct(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return RefreshIndicator(
                onRefresh: () async =>
                _refreshProduct(context),
                child: Column(
                  children: [
                    // buildTotalProduct(productsManager),
                    SizedBox(height: 650 ,child: buildUserProductListView(productsManager)),
                  ],
                )
              );
            }));
  }
}
//thêm sp, chuyen huong den trang chinh sua
Widget buildAddButton(BuildContext context) {
  return IconButton(
      onPressed: () {
        print("add");
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
        );
      },
      icon: const Icon(Icons.add));
}
  Widget searchProduct(context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(SearchAdminScreen.routeName);
        },
        icon: const Icon(Icons.search));
  }
  //Ds sp hien thi trong 1 listview
  //Sp hien thi bang sd UserProductListTile, hien thi thong tin co ban ve sp va nut sua, xoa
Widget buildUserProductListView(ProductsManager productsManager) {
  return Consumer<ProductsManager>(builder: (context, productsManager, child) {
    return ListView.builder(
      itemCount: productsManager.itemCount,
      itemBuilder: (context, index) => Column(
        children: [
          UserProductListTile(
            productsManager.items[index],
          ),
          const Divider(),
        ],
      ),
    );
  }
  );
}
