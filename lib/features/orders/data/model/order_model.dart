class OrderModel {
  final int billId;
  final int dishId;
  final String name;
  final String imageURL;
  final double price;
  final int quantity;
  final bool served;
  final DateTime? createdAt;
  OrderModel({
    required this.billId,
    required this.dishId,
    required this.name,
    required this.imageURL,
    required this.price,
    required this.quantity,
    required this.served,
    this.createdAt,
  });
  @override
  String toString() {
    return 'OrderModel('
        'billId: $billId, '
        'dishId: $dishId, '
        'name: $name, '
        'imageURL: $imageURL, '
        'price: $price, '
        'quantity: $quantity, '
        'served: $served, '
        ')';
  }
}
