import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text('Code: ${product.code}'),
                  Text('Qty: ${product.quantity}'),
                  Text('Unit Price: \$${product.unitPrice.toStringAsFixed(2)}'),
                  Text('Total Price: \$${(product.unitPrice * product.quantity).toStringAsFixed(2)}'),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                  tooltip: 'Edit Product',
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                  tooltip: 'Delete Product',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
