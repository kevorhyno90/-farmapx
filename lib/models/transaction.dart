enum TransactionType { income, expense, transfer }
enum TransactionStatus { pending, completed, cancelled, refunded }
enum PaymentMethod { cash, check, bank_transfer, credit_card, mobile_payment }

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final String currency;
  final String category;
  final String subcategory;
  final DateTime date;
  final TransactionStatus status;
  final PaymentMethod paymentMethod;
  final String description;
  final String? reference; // invoice number, receipt number
  final String? supplierId;
  final String? customerId;
  final String? animalId; // Related animal for animal-specific expenses
  final String? cropId; // Related crop for crop-specific expenses
  final String? employeeId; // Related employee for payroll
  final List<String> attachments; // Receipt/invoice images
  final String? notes;
  final double? taxAmount;
  final String? taxCategory;
  final String? location; // Field, barn, etc.
  final bool isRecurring;
  final String? recurringPeriod; // monthly, yearly, etc.
  final DateTime? recurringEndDate;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    this.currency = 'USD',
    required this.category,
    this.subcategory = '',
    DateTime? date,
    this.status = TransactionStatus.completed,
    this.paymentMethod = PaymentMethod.cash,
    this.description = '',
    this.reference,
    this.supplierId,
    this.customerId,
    this.animalId,
    this.cropId,
    this.employeeId,
    List<String>? attachments,
    this.notes,
    this.taxAmount,
    this.taxCategory,
    this.location,
    this.isRecurring = false,
    this.recurringPeriod,
    this.recurringEndDate,
  }) : 
    date = date ?? DateTime.now(),
    attachments = attachments ?? [];

  // Convenience getters
  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
  bool get isTransfer => type == TransactionType.transfer;
  bool get isPending => status == TransactionStatus.pending;
  bool get isCompleted => status == TransactionStatus.completed;
  double get netAmount => isIncome ? amount : -amount;

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type.name,
        'amount': amount,
        'currency': currency,
        'category': category,
        'subcategory': subcategory,
        'date': date.toIso8601String(),
        'status': status.name,
        'paymentMethod': paymentMethod.name,
        'description': description,
        'reference': reference,
        'supplierId': supplierId,
        'customerId': customerId,
        'animalId': animalId,
        'cropId': cropId,
        'employeeId': employeeId,
        'attachments': attachments,
        'notes': notes,
        'taxAmount': taxAmount,
        'taxCategory': taxCategory,
        'location': location,
        'isRecurring': isRecurring,
        'recurringPeriod': recurringPeriod,
        'recurringEndDate': recurringEndDate?.toIso8601String(),
      };

  static TransactionModel fromMap(Map<String, dynamic> m) => TransactionModel(
        id: m['id'],
        type: TransactionType.values.firstWhere((e) => e.name == m['type']),
        amount: m['amount'].toDouble(),
        currency: m['currency'] ?? 'USD',
        category: m['category'],
        subcategory: m['subcategory'] ?? '',
        date: DateTime.parse(m['date']),
        status: TransactionStatus.values.firstWhere((e) => e.name == m['status']),
        paymentMethod: PaymentMethod.values.firstWhere((e) => e.name == m['paymentMethod']),
        description: m['description'] ?? '',
        reference: m['reference'],
        supplierId: m['supplierId'],
        customerId: m['customerId'],
        animalId: m['animalId'],
        cropId: m['cropId'],
        employeeId: m['employeeId'],
        attachments: List<String>.from(m['attachments'] ?? []),
        notes: m['notes'],
        taxAmount: m['taxAmount']?.toDouble(),
        taxCategory: m['taxCategory'],
        location: m['location'],
        isRecurring: m['isRecurring'] ?? false,
        recurringPeriod: m['recurringPeriod'],
        recurringEndDate: m['recurringEndDate'] != null ? DateTime.parse(m['recurringEndDate']) : null,
      );

  TransactionModel copyWith({
    TransactionType? type,
    double? amount,
    String? currency,
    String? category,
    String? subcategory,
    DateTime? date,
    TransactionStatus? status,
    PaymentMethod? paymentMethod,
    String? description,
    String? reference,
    String? supplierId,
    String? customerId,
    String? animalId,
    String? cropId,
    String? employeeId,
    List<String>? attachments,
    String? notes,
    double? taxAmount,
    String? taxCategory,
    String? location,
    bool? isRecurring,
    String? recurringPeriod,
    DateTime? recurringEndDate,
  }) {
    return TransactionModel(
      id: id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      date: date ?? this.date,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      description: description ?? this.description,
      reference: reference ?? this.reference,
      supplierId: supplierId ?? this.supplierId,
      customerId: customerId ?? this.customerId,
      animalId: animalId ?? this.animalId,
      cropId: cropId ?? this.cropId,
      employeeId: employeeId ?? this.employeeId,
      attachments: attachments ?? this.attachments,
      notes: notes ?? this.notes,
      taxAmount: taxAmount ?? this.taxAmount,
      taxCategory: taxCategory ?? this.taxCategory,
      location: location ?? this.location,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPeriod: recurringPeriod ?? this.recurringPeriod,
      recurringEndDate: recurringEndDate ?? this.recurringEndDate,
    );
  }
}
