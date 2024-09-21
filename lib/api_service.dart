import 'dart:convert';
import 'package:crud_app/models/product.dart';
import 'package:http/http.dart' as http;


class ApiService {
  final String baseUrl = '';

  // API Endpoints
  final String fetchProductsUrl = '${'http://164.68.107.70:6060/api/v1/ReadProduct'}ReadProduct';
  final String createProductUrl = '${'http://164.68.107.70:6060/api/v1/CreateProduct'}CreateProduct';

  // Update and Delete URLs are constructed with methods
  String updateProductUrl(String id) => '${'http://164.68.107.70:6060/api/v1/UpdateProduct/6395ce12187245c05d68da82'}UpdateProduct/$id';
  String deleteProductUrl(String id) => '${'http://164.68.107.70:6060/api/v1/DeleteProduct/639da5960817590a4e4fd53c'}DeleteProduct/$id';

  // Fetch Products
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(fetchProductsUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  // Create a Product
  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(createProductUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create product");
    }
  }

  // Update a Product
  Future<Product> updateProduct(String id, Product product) async {
    final response = await http.put(
      Uri.parse(updateProductUrl(id)),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update product");
    }
  }

  // Delete a Product
  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse(deleteProductUrl(id)));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete product");
    }
  }
}
