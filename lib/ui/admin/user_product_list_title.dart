import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';


import '../../model/product.dart';
import '../products/products_manager.dart';
import 'edit_product_screen.dart';
//Hien thi thong tin ve mot sp trong ds sp nguoi dung
class UserProductListTile extends StatelessWidget {
  static const routeName = '/admin-products';
  final Product product;

  const UserProductListTile(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //Hien thi tieu de, hinh anh sp
    return ListTile(
      title: Text(product.title),
      //subtitle: Text('${product.price.toStringAsFixed(0)} VND'), // Thêm giá vào phần subtitle
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            buildEditButton(context),
            buildDeleteButton(context),
          ],
        ),
      ),
    );
  }
  // IconButton để chỉnh sửa sp
  //Nut dc nhan, dieu huong nguoi dung den man hinh chinh sua sp vs Id sp la doi so
  
  Widget buildEditButton(BuildContext context) {
    return IconButton(
      onPressed: () async {
        print("đến trang edit");
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
          arguments: product.id,
        );
      },
      icon: const Icon(Icons.edit),
      //mau sac dua tren theme
     // color: Colors.blue, // Thay đổi màu 
      color: Theme.of(context).colorScheme.error,
    );
  }
  //nút được nhấn, nó sẽ sử dụng ProductsManager để xóa sản phẩm
  // hiển thị một SnackBar để thông báo sp da dc xoa
  Widget buildDeleteButton(BuildContext context) {
    return IconButton(
      onPressed: () {
         context.read<ProductsManager>().deleteProduct(product.id!);
        ScaffoldMessenger.of(context)
          ..hideCurrentMaterialBanner()
          ..showSnackBar(const SnackBar(
              content: Text(
            'Sản phẩm đã xóa',
            textAlign: TextAlign.center,
          )));
        print("Đã xóa");
      },
      icon: const Icon(Icons.delete),
      color: Theme.of(context).colorScheme.error,
    );
  }
}
