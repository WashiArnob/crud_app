import 'package:flutter/material.dart';
import 'package:crud_app/api_service.dart';
import 'package:crud_app/models/product.dart';
import 'package:crud_app/screens/edit_product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const ProductCard({Key? key, required this.product, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Product Name
            Text(
              product.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Product Code
            Text('Code: ${product.code}'),
            SizedBox(height: 8),

            // Product Quantity
            Text('Quantity: ${product.quantity}'),
            SizedBox(height: 8),

            // Product Unit Price
            Text('Unit Price: \$${product.unitPrice.toStringAsFixed(2)}'),
            SizedBox(height: 16),

            // Row for Edit and Delete buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // Edit button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProductScreen(product: product),
                      ),
                    );
                  },
                  child: Text('Edit'),
                ),

                // Delete button
                TextButton(
                  onPressed: () {
                    _confirmDelete(context);
                  },
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to confirm product deletion
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ApiService().deleteProduct(product.id).then((_) {
                  onDelete();  // Notify parent widget of deletion
                  Navigator.of(context).pop();  // Close the dialog
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete product: $error'))
                  );
                });
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
