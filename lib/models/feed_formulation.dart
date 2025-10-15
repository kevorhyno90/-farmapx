class FeedIngredient {
  final String name;
  final double amount;

  FeedIngredient({required this.name, this.amount = 0.0});
  Map<String, dynamic> toJson() => {'name': name, 'percent': amount};
  static FeedIngredient fromJson(Map<String, dynamic> m) => FeedIngredient(name: (m['name'] as String?) ?? '', amount: (m['percent'] as num?)?.toDouble() ?? (m['amount'] as num?)?.toDouble() ?? 0.0);
}

class FeedFormulation {
  final String id;
  final String name;
  final double crudeProteinTarget;
  final double metabolisableEnergyTarget;
  final List<FeedIngredient> ingredients;

  FeedFormulation({required this.id, required this.name, this.crudeProteinTarget = 0.0, this.metabolisableEnergyTarget = 0.0, this.ingredients = const []});
}
