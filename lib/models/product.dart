class Product {
  final String id;
  final String name;
  final String code;
  final int quantity;
  final double unitPrice;

  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.quantity,
    required this.unitPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }
}
