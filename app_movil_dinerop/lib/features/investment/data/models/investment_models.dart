class InvestmentAvailability {
  const InvestmentAvailability({
    required this.termMonths,
    required this.interestPaymentOptions,
  });

  final List<int> termMonths;
  final List<String> interestPaymentOptions;

  factory InvestmentAvailability.fromJson(Map<String, dynamic> json) =>
      InvestmentAvailability(
        termMonths: List<num>.from(
          json['termMonths'] as List? ?? const [],
        ).map((month) => month.toInt()).toList(),
        interestPaymentOptions: List<String>.from(
          json['interestPaymentOptions'] as List? ?? const [],
        ),
      );
}

class InvestmentOffer {
  const InvestmentOffer({
    required this.cooperativeId,
    required this.cooperativeName,
    required this.cooperativeLogoUrl,
    required this.productId,
    required this.conditionId,
    required this.productName,
    required this.description,
    required this.productMinimumAmount,
    required this.productMaximumAmount,
    required this.conditionMinimumAmount,
    required this.conditionMaximumAmount,
    required this.minimumTermMonths,
    required this.maximumTermMonths,
    required this.annualRate,
    required this.validFrom,
    required this.validUntil,
    required this.interestPaymentOptions,
    required this.calculationMethod,
    required this.renewalConditions,
    required this.earlyCancellationConditions,
    required this.targetAudience,
    required this.estimatedInterest,
    required this.estimatedTotal,
  });

  final int cooperativeId;
  final String cooperativeName;
  final String? cooperativeLogoUrl;
  final int productId;
  final int conditionId;
  final String productName;
  final String? description;
  final double productMinimumAmount;
  final double productMaximumAmount;
  final double conditionMinimumAmount;
  final double conditionMaximumAmount;
  final int minimumTermMonths;
  final int maximumTermMonths;
  final double annualRate;
  final DateTime validFrom;
  final DateTime? validUntil;
  final List<String> interestPaymentOptions;
  final String calculationMethod;
  final String? renewalConditions;
  final String? earlyCancellationConditions;
  final String? targetAudience;
  final double? estimatedInterest;
  final double? estimatedTotal;

  factory InvestmentOffer.fromJson(
    Map<String, dynamic> json,
  ) => InvestmentOffer(
    cooperativeId: (json['cooperativeId'] as num).toInt(),
    cooperativeName: (json['cooperativeName'] ?? 'Cooperativa').toString(),
    cooperativeLogoUrl: json['cooperativeLogoUrl']?.toString(),
    productId: (json['productId'] as num).toInt(),
    conditionId: (json['conditionId'] as num).toInt(),
    productName: (json['productName'] ?? '').toString(),
    description: json['description']?.toString(),
    productMinimumAmount: (json['productMinimumAmount'] as num).toDouble(),
    productMaximumAmount: (json['productMaximumAmount'] as num).toDouble(),
    conditionMinimumAmount: (json['conditionMinimumAmount'] as num).toDouble(),
    conditionMaximumAmount: (json['conditionMaximumAmount'] as num).toDouble(),
    minimumTermMonths: (json['minimumTermMonths'] as num).toInt(),
    maximumTermMonths: (json['maximumTermMonths'] as num).toInt(),
    annualRate: (json['annualRate'] as num).toDouble(),
    validFrom: DateTime.parse(json['validFrom'].toString()),
    validUntil: json['validUntil'] == null
        ? null
        : DateTime.parse(json['validUntil'].toString()),
    interestPaymentOptions: List<String>.from(
      json['interestPaymentOptions'] as List? ?? const [],
    ),
    calculationMethod: (json['calculationMethod'] ?? 'UNSPECIFIED').toString(),
    renewalConditions: json['renewalConditions']?.toString(),
    earlyCancellationConditions: json['earlyCancellationConditions']
        ?.toString(),
    targetAudience: json['targetAudience']?.toString(),
    estimatedInterest: (json['estimatedInterest'] as num?)?.toDouble(),
    estimatedTotal: (json['estimatedTotal'] as num?)?.toDouble(),
  );
}

class InvestmentRequest {
  const InvestmentRequest({
    required this.id,
    required this.cooperativeId,
    required this.cooperativeName,
    required this.cooperativeLogoUrl,
    required this.productName,
    required this.productDescription,
    required this.amount,
    required this.termMonths,
    required this.interestPaymentOption,
    required this.annualRate,
    required this.rateValidUntil,
    required this.calculationMethod,
    required this.estimatedInterest,
    required this.estimatedTotal,
    required this.renewalConditions,
    required this.earlyCancellationConditions,
    required this.status,
    required this.statusNote,
    required this.events,
    required this.acceptance,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int cooperativeId;
  final String cooperativeName;
  final String? cooperativeLogoUrl;
  final String productName;
  final String? productDescription;
  final double amount;
  final int termMonths;
  final String? interestPaymentOption;
  final double annualRate;
  final DateTime? rateValidUntil;
  final String calculationMethod;
  final double? estimatedInterest;
  final double? estimatedTotal;
  final String? renewalConditions;
  final String? earlyCancellationConditions;
  final String status;
  final String? statusNote;
  final List<InvestmentStatusEvent> events;
  final InvestmentAcceptance? acceptance;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory InvestmentRequest.fromJson(Map<String, dynamic> json) =>
      InvestmentRequest(
        id: (json['id'] as num).toInt(),
        cooperativeId: (json['cooperativeId'] as num).toInt(),
        cooperativeName: (json['cooperativeName'] ?? 'Cooperativa').toString(),
        cooperativeLogoUrl: json['cooperativeLogoUrl']?.toString(),
        productName: (json['productName'] ?? '').toString(),
        productDescription: json['productDescription']?.toString(),
        amount: (json['amount'] as num).toDouble(),
        termMonths: (json['termMonths'] as num).toInt(),
        interestPaymentOption: json['interestPaymentOption']?.toString(),
        annualRate: (json['annualRate'] as num).toDouble(),
        rateValidUntil: json['rateValidUntil'] == null
            ? null
            : DateTime.parse(json['rateValidUntil'].toString()),
        calculationMethod: (json['calculationMethod'] ?? 'UNSPECIFIED')
            .toString(),
        estimatedInterest: (json['estimatedInterest'] as num?)?.toDouble(),
        estimatedTotal: (json['estimatedTotal'] as num?)?.toDouble(),
        renewalConditions: json['renewalConditions']?.toString(),
        earlyCancellationConditions: json['earlyCancellationConditions']
            ?.toString(),
        status: (json['status'] ?? 'UNKNOWN').toString(),
        statusNote: json['statusNote']?.toString(),
        events: (json['events'] as List? ?? const [])
            .map(
              (item) => InvestmentStatusEvent.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(),
        acceptance: json['acceptance'] == null
            ? null
            : InvestmentAcceptance.fromJson(
                Map<String, dynamic>.from(json['acceptance'] as Map),
              ),
        createdAt: DateTime.parse(json['createdAt'].toString()),
        updatedAt: DateTime.parse(json['updatedAt'].toString()),
      );
}

class InvestmentStatusEvent {
  const InvestmentStatusEvent({
    required this.status,
    required this.note,
    required this.createdAt,
  });
  final String status;
  final String? note;
  final DateTime createdAt;
  factory InvestmentStatusEvent.fromJson(Map<String, dynamic> json) =>
      InvestmentStatusEvent(
        status: (json['status'] ?? 'UNKNOWN').toString(),
        note: json['note']?.toString(),
        createdAt: DateTime.parse(json['createdAt'].toString()),
      );
}

class InvestmentAcceptance {
  const InvestmentAcceptance({
    required this.acceptanceMessage,
    required this.confirmedAnnualRate,
    required this.agencyName,
    required this.agencyAddress,
    required this.agencyCity,
    required this.mapsUrl,
    required this.contactPhone,
    required this.openingHours,
    required this.contactDepartment,
    required this.responseDeadline,
    required this.instructions,
    required this.respondedAt,
    required this.requirements,
  });
  final String acceptanceMessage;
  final double? confirmedAnnualRate;
  final String agencyName;
  final String agencyAddress;
  final String agencyCity;
  final String? mapsUrl;
  final String? contactPhone;
  final String? openingHours;
  final String? contactDepartment;
  final DateTime? responseDeadline;
  final String? instructions;
  final DateTime respondedAt;
  final List<InvestmentRequirement> requirements;
  factory InvestmentAcceptance.fromJson(Map<String, dynamic> json) =>
      InvestmentAcceptance(
        acceptanceMessage: (json['acceptanceMessage'] ?? '').toString(),
        confirmedAnnualRate: (json['confirmedAnnualRate'] as num?)?.toDouble(),
        agencyName: (json['agencyName'] ?? '').toString(),
        agencyAddress: (json['agencyAddress'] ?? '').toString(),
        agencyCity: (json['agencyCity'] ?? '').toString(),
        mapsUrl: json['mapsUrl']?.toString(),
        contactPhone: json['contactPhone']?.toString(),
        openingHours: json['openingHours']?.toString(),
        contactDepartment: json['contactDepartment']?.toString(),
        responseDeadline: json['responseDeadline'] == null
            ? null
            : DateTime.tryParse(json['responseDeadline'].toString()),
        instructions: json['instructions']?.toString(),
        respondedAt: DateTime.parse(json['respondedAt'].toString()),
        requirements: (json['requirements'] as List? ?? const [])
            .map(
              (item) => InvestmentRequirement.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(),
      );
}

class InvestmentRequirement {
  const InvestmentRequirement({
    required this.description,
    required this.mandatory,
  });
  final String description;
  final bool mandatory;
  factory InvestmentRequirement.fromJson(Map<String, dynamic> json) =>
      InvestmentRequirement(
        description: (json['description'] ?? '').toString(),
        mandatory: json['mandatory'] == true,
      );
}
