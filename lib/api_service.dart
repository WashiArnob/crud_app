
import 'dart:convert';
import 'package:crud_app/models/product.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // API Endpoints
  final Uri fetchProductsUrl = Uri.parse('http://164.68.107.70:6060/api/v1/ReadProduct');
  final Uri createProductUrl = Uri.parse('http://164.68.107.70:6060/api/v1/CreateProduct');
  final String baseUrl = 'http://164.68.107.70:6060/api/v1/';

  // Update and Delete URLs
  Uri updateProductUrl(String id) => Uri.parse('$baseUrl/UpdateProduct/$id');
  Uri deleteProductUrl(String id) => Uri.parse('$baseUrl/DeleteProduct/$id');

  // Fetch Products
  Future<List<Product>> getProducts() async {
    final response = await http.get(fetchProductsUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['products'] is List) {
        List<dynamic> productList = body['products'];
        return productList.map((dynamic item) => Product.fromJson(item)).toList();
      } else {
        throw Exception("No products found in the response");
      }
    } else {
      throw Exception("Failed to load products: ${response.statusCode}");
    }
  }

  // Create a Product
  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      createProductUrl,
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
      updateProductUrl(id),
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
    final response = await http.delete(deleteProductUrl(id));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete product");
    }
  }
}
