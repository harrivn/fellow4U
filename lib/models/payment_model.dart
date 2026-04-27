class PaymentModel {
  final String? id;
  final String userId;
  final String tripId;
  final String cardHolder;
  final String cardLast4;
  final double amount;
  final String status;

  PaymentModel({
    this.id,
    required this.userId,
    required this.tripId,
    required this.cardHolder,
    required this.cardLast4,
    required this.amount,
    this.status = 'pending',
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      userId: json['user_id'] ?? '',
      tripId: json['trip_id'] ?? '',
      cardHolder: json['card_holder'] ?? '',
      cardLast4: json['card_last4'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'trip_id': tripId,
        'card_holder': cardHolder,
        'card_last4': cardLast4,
        'amount': amount,
        'status': status,
      };
}
