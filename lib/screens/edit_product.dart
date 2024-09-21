import 'package:crud_app/api_service.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';


class EditProductScreen extends StatefulWidget {
  final Product product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final productCodeController = TextEditingController();
  final qtyController = TextEditingController();
  final unitPriceController = TextEditingController();
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    productNameController.text = widget.product.name;
    productCodeController.text = widget.product.code;
    qtyController.text = widget.product.quantity.toString();
    unitPriceController.text = widget.product.unitPrice.toString();
  }

  @override
  void dispose() {
    productNameController.dispose();
    productCodeController.dispose();
    qtyController.dispose();
    unitPriceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = Product(
        id: widget.product.id,
        name: productNameController.text,
        code: productCodeController.text,
        quantity: int.parse(qtyController.text),
        unitPrice: double.parse(unitPriceController.text),
      );

      apiService.updateProduct(widget.product.id, updatedProduct).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: productCodeController,
                decoration: InputDecoration(labelText: 'Product Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: qtyController,
                decoration: InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: unitPriceController,
                decoration: InputDecoration(labelText: 'Unit Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter unit price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
