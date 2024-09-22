import 'package:flutter/material.dart';
import 'package:crud_app/api_service.dart';
import 'package:crud_app/models/product.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Form key to validate the form
  final _formKey = GlobalKey<FormState>();

  // Text controllers for the input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();

  // Instance of ApiService to handle API calls
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  // Method to submit the form and add a product
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create a new product instance
      final Product product = Product(
        id: '',  // ID will be assigned by the API
        name: _nameController.text,
        code: _codeController.text,
        quantity: int.parse(_quantityController.text),
        unitPrice: double.parse(_unitPriceController.text),
      );

      // Call the API to create the product
      apiService.createProduct(product).then((value) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product added successfully!'))
        );
        Navigator.pop(context); // Go back to the product list screen
      }).catchError((error) {
        // Handle any errors by showing a message
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add product: $error'))
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,  // Attach the form key
          child: ListView(
            children: <Widget>[
              // Product Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
              ),

              // Product Code field
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Product Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product code';
                  }
                  return null;
                },
              ),

              // Quantity field
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),

              // Unit Price field
              TextFormField(
                controller: _unitPriceController,
                decoration: InputDecoration(labelText: 'Unit Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the unit price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),

              // Submit button to add the product
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

