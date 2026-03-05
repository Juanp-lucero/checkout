class Payment {
  final int? id;
  final int? cardId;
  final double amount;
  final String method; // paypal | credit | wallet
  final String? promoCode;
  final double discount;
  final DateTime createdAt;

  Payment({
    this.id,
    this.cardId,
    required this.amount,
    required this.method,
    this.promoCode,
    this.discount = 0.0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, Object?> toMap() => {
        'id': id,
        'cardId': cardId,
        'amount': amount,
        'method': method,
        'promoCode': promoCode,
        'discount': discount,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Payment.fromMap(Map<String, Object?> m) => Payment(
        id: m['id'] as int?,
        cardId: m['cardId'] as int?,
        amount: (m['amount'] as num).toDouble(),
        method: m['method'] as String,
        promoCode: m['promoCode'] as String?,
        discount: (m['discount'] as num).toDouble(),
        createdAt: DateTime.parse(m['createdAt'] as String),
      );
}
