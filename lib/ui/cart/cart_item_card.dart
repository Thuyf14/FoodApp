import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import '../../model/cart_item.dart';
import '../../model/product.dart';
import '../shared/dialog_utils.dart';
import 'cart_manager.dart';
class CartItemCard extends StatelessWidget {
  final String productId;
  final CartItem cardItem;
// sd de tao 1 the trong muc gio hang
  const CartItemCard({
    required this.productId,
    required this.cardItem,
    Key? key,
  }) : super(key: key);

  //Vuot de xoa 1 muc khoi danh sach gio hang
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cardItem.id),
      background: Container(
        //widget chua h/a delete o phia phai
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        //Hien thi hop thoai xac nhan muon xoa
        return showConfirmDialog(
          context,
          'Bạn có chắc muốn xoá sản phẩm này không?',
        );
      },
      onDismissed: (direction) {
        //Xu ly khi vuot va xoa khoi gio hang
        context.read<CartManager>().removeItem(productId);
      },
      child: buildItemCard(context),
    );
  }
  //Card chua thong tin cua muc gio hang
  Widget buildItemCard(BuildContext context) {
    return Card(
      //hien thi thong tin moi muc trong gio hang
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          //Hien thi h/a, tieu de va gia sp
          leading: CircleAvatar(
            backgroundImage: NetworkImage(cardItem.imageUrl),
          ),
          title: Text(cardItem.title),
          subtitle: Text('Tổng: ${(cardItem.price * cardItem.quantity).toStringAsFixed(0)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Nut tru de giam so luong sp
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  //tuong tac vs provider
                  context.read<CartManager>().removeSingleItem(productId);
                },
              ),
              Text('${cardItem.quantity.toStringAsFixed(0)}'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  //sd provider de truy cap vao cartmnager va them 1 muc khoi gio hang
                  context.read<CartManager>().addItem(Product(
                    id: cardItem.productId,
                    title: cardItem.title,
                    price: cardItem.price,
                    price0: cardItem.price0,
                    imageUrl: cardItem.imageUrl,
                    category: cardItem.category,
                    author: cardItem.author,
                    coutry: cardItem.coutry,
                    description: '',
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}