import 'package:flutter/material.dart';
import 'package:foodapp/model/product.dart';

import 'package:provider/provider.dart';

import '../../model/product.dart';

import '../shared/dialog_utils.dart';

import '../products/products_manager.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  //Nhan doi tuong product va khoi tao no
  // product null, 1 product moi se dc tao vs cac truong rong
  EditProductScreen(
    Product? product, {
    super.key,
  }) {
    if (product == null) {
      this.product = Product(
        id: null,
        title: '',
        category: '',
        author: '',
        coutry: '',
        description: '',
        price: 0.0 ,
        price0: 0.0 ,
        imageUrl: '',
      );
    } else {
      this.product = product;
    }
  }

  late final Product product;
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Product _editedProduct;
  //ktr Url image co hop le
  //true vs bat dau http, https, end vs png, jpg,jpeg.
  var _isLoading = false;
  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') ||
        value.startsWith('https') && (value.endsWith('.png')) ||
        value.endsWith('.jpg') ||
        value.endsWith('.jpeg'));
  }
// goi khi widget dc thiet lap
//1 listener dc them de ktr, neu url khong hop le, k cap nhat
  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) {
        if (!_isValidImageUrl(_imageUrlController.text)) {
          return;
        }
        setState(() {});
      }
    });
    _editedProduct = widget.product;
    _imageUrlController.text = _editedProduct.imageUrl;
    super.initState();
  }
  //goi khi widget bi huy
  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
  //goi khi nhan save, ktr du lieu co hop le
  //neu co thi cap nhat, them sp moi qua productsManager
  //k, bao loi
  @override
  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final productsManager = context.read<ProductsManager>();
      if (_editedProduct.id != null) {
        productsManager.updateProduct(_editedProduct);
      } else {
        productsManager.addProduct(_editedProduct);
      }
    } catch (error) {
      await showErrorDialog(context, 'Something went wrong.');
    }
    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  //Giao dien chinh sua
  //appbar tieu de va nut luu
  //form de chinh sua...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa món'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _editForm,
                child: ListView(
                  children: <Widget>[
                    buildTitleField(),
                    buildCategoryField(),
                    buildAuthorField(),
                    buildPriceField(),
                    buildDescriptionField(),
                    buildCoutryField(),
                    buildPrice0Field(),
                    buildProductPreview(),
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField buildTitleField() {
    return TextFormField(
      initialValue: _editedProduct.title,
      decoration: const InputDecoration(labelText: 'Tên món'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(title: value);
      },
    );
  }

  TextFormField buildCategoryField() {
    return TextFormField(
      initialValue: _editedProduct.category,
      decoration: const InputDecoration(labelText: 'Thể loại món'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(category: value);
      },
    );
  }

  TextFormField buildAuthorField() {
    return TextFormField(
      initialValue: _editedProduct.author,
      decoration: const InputDecoration(labelText: 'Người làm'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(author: value);
      },
    );
  }

  TextFormField buildCoutryField() {
    return TextFormField(
      initialValue: _editedProduct.coutry,
      decoration: const InputDecoration(labelText: 'Quốc gia món'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(coutry: value);
      },
    );
  }

  TextFormField buildPrice0Field() {
    return TextFormField(
      // Chuyển đổi giá trị double thành int và sau đó thành chuỗi
      initialValue: _editedProduct.price0.toStringAsFixed(0),
      decoration: const InputDecoration(labelText: 'Giá gốc'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a price';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        if (double.parse(value) <= 0) {
          return 'Please enter a number greater than zero';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(price0: double.parse(value!));
      },
    );
  }

  TextFormField buildPriceField() {
    return TextFormField(
      initialValue: _editedProduct.price.toStringAsFixed(0),
      decoration: const InputDecoration(labelText: 'Giá bán'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a price';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        if (double.parse(value) <= 0) {
          return 'Please enter a number greater than zero';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(price: double.parse(value!));
      },
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      initialValue: _editedProduct.description,
      decoration: const InputDecoration(labelText: 'Mô tả món ăn'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description';
        }
        if (value.length < 10) {
          return 'Should be at least 10 character long.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(description: value);
      },
    );
  }
  // widget hien thi truoc cua sp, gom hinh anh dc tai tu url va 1 truong van ban url cho hinh anh
  Widget buildProductPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(
            top: 8,
            right: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _imageUrlController.text.isEmpty
              ? const Text('Hình ảnh')
              : FittedBox(
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Expanded(
          child: buildImageURLField(),
        ),
      ],
    );
  }

  TextFormField buildImageURLField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Nhập URL món'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (value) => _saveForm(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an image URL';
        }
        if (!_isValidImageUrl(value)) {
          return 'Please enter a valid image URL';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(imageUrl: value);
      },
    );
  }
}
