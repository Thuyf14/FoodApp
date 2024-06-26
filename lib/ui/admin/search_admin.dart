import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ui/products/products_manager.dart';
import '../../model/product.dart';
import 'edit_product_screen.dart';
//Screen tim kiem
class SearchAdminScreen extends StatefulWidget {
  static const routeName = '/search1';

  const SearchAdminScreen({super.key});
  @override
  State<SearchAdminScreen> createState() => _SearchAdminScreenState();
}

class _SearchAdminScreenState extends State<SearchAdminScreen> {
  List<Product>? display_product = [];
  @override
  void initState() {
    super.initState();
    //Cap nhat trang thai widget. Ds sp hien thi gan bang ds sp hien co tu ProductManager
    setState(() {
      final productsManager = context.read<ProductsManager>();
      late List<Product> product = productsManager.items;
      print("AAAAAAAAAAAAAAAAAAAA");
      print(product.length);
      // lay tu day de hien thi xuong listview
      display_product = product;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsManager = context.read<ProductsManager>();
    final product = context.select<ProductsManager, List<Product>>(
        (productsManager) => productsManager.display_product);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tìm kiếm - Admin'),
        ),
        body: Column(children: [
          //Nhập từ khóa tìm kiếm
          //Khi nd thay đổi, ds sp sẽ được cập nhật tương ứng thông qua hàm updateList trong ProductManager
          TextField(
            onChanged: (value) => setState(() {
              context.read<ProductsManager>().updateList(value);
            }),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Tìm kiếm",
                prefixIcon: Icon(Icons.search)),
          ),
          SizedBox(height: 20),
          Expanded(
              child: product!.length == 0
                  ? const Center(
                      child: Text(
                      '',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ))
                    //Hiển thị ds sp.
                    //Tao 1 listview de chi render cac item can hien thi len man hinh
                    //itemCount: so luong phan tu, lay tu display_pr_co
                  : ListView.builder(
                      itemCount: productsManager.display_product_Count,
                      //ListTile moi sp trong ds đc hien thi dang listtile, gom tieu de, gia, hinh anh, bieu tuong chinh sua, xoa
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          //Chuyển huong den chi tiet sp
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) =>
                          //         ProductDetailScreen(product[index])));
                        },
                        title: Text(
                          product[index].title,
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          '${product[index].price.toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.black),
                        ),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(product[index].imageUrl),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              buildEditButton(context, product[index]),
                              buildDeleteButton(context, product[index]),
                            ],
                          ),
                        ),
                      ),
                    ))
        ]));
  }

  Widget buildEditButton(BuildContext context, product) {
    return IconButton(
      onPressed: () async {
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
          arguments: product.id,
        );
      },
      icon: const Icon(Icons.edit),
      color: Theme.of(context).colorScheme.error,
    );
  }

    Widget buildDeleteButton(BuildContext context, product) {
    return IconButton(
      onPressed: () {
        context.read<ProductsManager>().deleteProduct(product.id!);
        ScaffoldMessenger.of(context)
          ..hideCurrentMaterialBanner()
          ..showSnackBar(const SnackBar(
              content: Text(
            'Sản phẩm đã được xóa!',
            textAlign: TextAlign.center,
          )));
      },
      icon: const Icon(Icons.delete),
      color: Theme.of(context).colorScheme.error,
    );
  }
}
