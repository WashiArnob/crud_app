import 'package:flutter/material.dart';
import 'package:crud_app/api_service.dart';
import 'package:crud_app/models/product.dart';
import 'add_product.dart';
import 'edit_product.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ApiService apiService;
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    products = apiService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductScreen())).then((_) {
                setState(() {
                  products = apiService.getProducts();
                });
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final productsList = snapshot.data!;
          return ListView.builder(
            itemCount: productsList.length,
            itemBuilder: (context, index) {
              final product = productsList[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Code: ${product.code}, Qty: ${product.quantity}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(product: product),
                          ),
                        ).then((_) {
                          setState(() {
                            products = apiService.getProducts();
                          });
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        apiService.deleteProduct(product.id).then((_) {
                          setState(() {
                            products = apiService.getProducts();
                          });
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
