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

  const CartItemCard({
    required this.productId,
    required this.cardItem,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cardItem.id),
      background: Container(
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
        return showConfirmDialog(
          context,
          'Bạn có chắc muốn xoá sản phẩm này không?',
        );
      },
      onDismissed: (direction) {
        context.read<CartManager>().removeItem(productId);
      },
      child: buildItemCard(context),
    );
  }

  Widget buildItemCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(cardItem.imageUrl),
          ),
          title: Text(cardItem.title),
          subtitle: Text('Tổng: ${(cardItem.price * cardItem.quantity)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  context.read<CartManager>().removeSingleItem(productId);
                },
              ),
              Text('${cardItem.quantity}'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
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

