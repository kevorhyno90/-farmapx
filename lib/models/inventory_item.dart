class InventoryItem {
  final String id;
  final String name;
  final String sku;
  final String category;
  final String unit;
  final int quantity;

  InventoryItem({required this.id, required this.name, this.sku = '', this.category = '', this.unit = '', this.quantity = 0});
}
