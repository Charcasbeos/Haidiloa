class DishEntity {
  final int? id;
  final String name;
  final String imageURL;
  final String description;
  final String note;
  final int quantity;
  final double price;
  DishEntity({
    required this.id,
    required this.name,
    required this.imageURL,
    required this.description,
    required this.note,
    required this.quantity,
    required this.price,
  });
  @override
  String toString() {
    return 'DishEntity('
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
