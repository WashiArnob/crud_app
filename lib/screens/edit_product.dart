import 'package:flutter/material.dart';
import 'package:crud_app/api_service.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();

    // Initialize the text controllers with the current product details
    _nameController.text = widget.product.name;
    _codeController.text = widget.product.code;
    _quantityController.text = widget.product.quantity.toString();
    _unitPriceController.text = widget.product.unitPrice.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create an updated product instance
      final Product updatedProduct = Product(
        id: widget.product.id, // Retain the product ID
        name: _nameController.text,
        code: _codeController.text,
        quantity: int.parse(_quantityController.text),
        unitPrice: double.parse(_unitPriceController.text),
      );

      // Call the API to update the product, passing both the id and updated product
      apiService.updateProduct(widget.product.id, updatedProduct).then((value) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product updated successfully!'))
        );
        Navigator.pop(context); // Go back to the product list screen
      }).catchError((error) {
        // Handle any errors by showing a message
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update product: $error'))
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Product Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitPriceController,
                decoration: InputDecoration(labelText: 'Unit Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter unit price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
