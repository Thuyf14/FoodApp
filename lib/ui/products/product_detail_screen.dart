import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../payment_cart/payment_cart_screen.dart';
import '../../model/product.dart';
import '../cart/cart_manager.dart';

//hien thi thong tin chi tiet va 1 sp, them sp vao gio hang de dat hang
class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  const ProductDetailScreen(
    this.product, {
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết món ăn"),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        width: 200,
                        // width: double.infinity,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tên món ăn',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Text(
                                        '${product.title}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.red,
                                         // fontStyle: FontStyle.italic,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Người làm món',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Text(
                                        '${product.author}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Quốc gia',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Text(
                                        '${product.coutry}',
                                        style: const TextStyle(
                                          color:Colors.red,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Thể loại món',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Text(
                                        '${product.category}',
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Giá bán',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Text(
                                        '${product.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  buildShoppingCartIcon(),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ]),
              ),
              // buildShoppingCartIcon(),
              Container(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final cart = context.read<CartManager>();
                    // cart.addCart(product.id, product.title, product.price, product.imageUrl, 1);
                    cart.addItem(product);
                    Navigator.of(context)
                        .pushNamed(PaymentCartScreen1.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Đặt hàng',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      )),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      'Mô tả',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                    Text(
                      product.description,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }

  Widget buildShoppingCartIcon() {
    return Consumer<CartManager>(
      builder: (context, cartManager, child) {
        return Container(
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Thêm:',
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                      onPressed: () {
                        //them vao cart
                        final cart = context.read<CartManager>();
                        cart.addItem(product);
                        // cart.addCart(product.id, product.title, product.price, product.imageUrl, 1);
                        //thong bao

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: const Text('Đã thêm vào giỏ hàng!'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Xóa',
                              onPressed: () {
                                cart.removeSingleItem(product.id!);
                              },
                            ),
                          ));
                      },
                      icon: const Icon(Icons.shopping_cart)),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
