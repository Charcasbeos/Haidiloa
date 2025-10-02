class DishModel {
  final int? id;
  final String name;
  final String imageURL;
  final String description;
  final String note;
  final int quantity;
  final double price;
  DishModel({
    required this.id,
    required this.name,
    required this.imageURL,
    required this.description,
    required this.note,
    required this.quantity,
    required this.price,
  });
  factory DishModel.fromJson(Map<String, dynamic> json) {
    return DishModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      imageURL: json['image'] ?? '',
      description: json['description'] ?? '',
      note: json['note'] ?? '',
      quantity: json['quantity'] ?? -1,
      price: json['price'] * 1.0 ?? -1.0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageURL': imageURL,
      'description': description,
      'note': note,
      'quantity': quantity,
      'price': price,
    };
  }

  @override
  String toString() {
    return 'DishModel('
        'id: $id, '
        'name: $name, '
        'imageURL: $imageURL, '
        'description: $description, '
        'note: $note, '
        'quantity: $quantity, '
        'price: $price, '
        ')';
  }
}
