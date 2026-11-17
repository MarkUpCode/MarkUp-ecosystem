class PublicCreditOffer {
  const PublicCreditOffer({
    required this.cooperativeId,
    required this.cooperativeName,
    required this.productId,
    required this.productName,
    required this.creditCategory,
    required this.amount,
    required this.termMonths,
    required this.annualRate,
    required this.conditions,
    this.description,
  });

  final int cooperativeId;
  final String cooperativeName;
  final int productId;
  final String productName;
  final String creditCategory;
  final double amount;
  final int termMonths;
  final double annualRate;
  final String conditions;
  final String? description;

  factory PublicCreditOffer.fromJson(Map<String, dynamic> json) =>
      PublicCreditOffer(
        cooperativeId: (json['cooperativeId'] as num).toInt(),
        cooperativeName: (json['cooperativeName'] ?? 'Cooperativa').toString(),
        productId: (json['productId'] as num).toInt(),
        productName: (json['productName'] ?? '').toString(),
        creditCategory: (json['creditCategory'] ?? '').toString(),
        amount: (json['amount'] as num).toDouble(),
        termMonths: (json['termMonths'] as num).toInt(),
        annualRate: (json['annualRate'] as num).toDouble(),
        conditions: (json['conditions'] ?? '').toString(),
        description: json['description']?.toString(),
      );
}
