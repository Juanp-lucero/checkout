class BankCard {
  final int? id;
  final String holder;
  final String number;
  final int expMonth;
  final int expYear;
  final String brand;

  BankCard({
    this.id,
    required this.holder,
    required this.number,
    required this.expMonth,
    required this.expYear,
    required this.brand,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'holder': holder,
        'number': number,
        'expMonth': expMonth,
        'expYear': expYear,
        'brand': brand,
      };

  factory BankCard.fromMap(Map<String, Object?> map) => BankCard(
        id: map['id'] as int?,
        holder: map['holder'] as String,
        number: map['number'] as String,
        expMonth: map['expMonth'] as int,
        expYear: map['expYear'] as int,
        brand: map['brand'] as String,
      );

  String get maskedNumber {
    if (number.length < 4) return number;
    final last = number.substring(number.length - 2);
    return '•••• •••• •••• **$last';
  }
}
