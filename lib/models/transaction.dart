class TransactionModel {
  final String id;
  final String type;
  final double amount;
  final String currency;
  final String category;
  final String date;

  TransactionModel({required this.id, required this.type, required this.amount, this.currency = 'USD', this.category = 'General', this.date = ''});

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'amount': amount,
        'currency': currency,
        'category': category,
        'date': date,
      };

  static TransactionModel fromMap(Map<String, dynamic> m) => TransactionModel(
        id: m['id'] as String,
        type: m['type'] as String,
        amount: (m['amount'] as num).toDouble(),
        currency: (m['currency'] as String?) ?? 'USD',
        category: (m['category'] as String?) ?? 'General',
        date: (m['date'] as String?) ?? '',
      );
}
