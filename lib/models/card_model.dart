import 'package:equatable/equatable.dart';

class CardModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String cardNumber;
  final String cvv;
  final String expiry;
  final String country;
  final String city;
  final String pin;
  final String? cardType;
  final String? bankName;

  CardModel({
    String? id,
    required String firstName,
    required String lastName,
    required String cardNumber,
    required String cvv,
    required String expiry,
    required String country,
    required String city,
    required String pin,
    String? cardType,
    String? bankName,
  }) :
    id = id ?? _generateId(),
    firstName = firstName,
    lastName = lastName,
    cardNumber = cardNumber,
    cvv = cvv,
    expiry = expiry,
    country = country,
    city = city,
    pin = pin,
    cardType = cardType,
    bankName = bankName;

  static String _generateId() => DateTime.now().microsecondsSinceEpoch.toString();

  CardModel.empty()
      : id = '',
        firstName = '',
        lastName = '',
        cardNumber = '',
        cvv = '',
        expiry = '',
        country = '',
        city = '',
        pin = '',
        cardType = null,
        bankName = null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'cardNumber': cardNumber,
    'cvv': cvv,
    'expiry': expiry,
    'country': country,
    'city': city,
    'pin': pin,
    'cardType': cardType,
    'bankName': bankName,
  };

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id']?.toString(),
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      cardNumber: json['cardNumber']?.toString() ?? '',
      cvv: json['cvv']?.toString() ?? '',
      expiry: json['expiry']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      pin: json['pin']?.toString() ?? '',
      cardType: json['cardType']?.toString(),
      bankName: json['bankName']?.toString(),
    );
  }

  @override
  String toString() {
    final last4 = cardNumber.length >= 4 ? cardNumber.substring(cardNumber.length - 4) : cardNumber;
    return 'CardModel(id: $id, name: $firstName $lastName, last4: $last4)';
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    cardNumber,
    cvv,
    expiry,
    country,
    city,
    pin,
    cardType,
    bankName,
  ];

  CardModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? cardNumber,
    String? cvv,
    String? expiry,
    String? country,
    String? city,
    String? pin,
    String? cardType,
    String? bankName,
  }) {
    return CardModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      cardNumber: cardNumber ?? this.cardNumber,
      cvv: cvv ?? this.cvv,
      expiry: expiry ?? this.expiry,
      country: country ?? this.country,
      city: city ?? this.city,
      pin: pin ?? this.pin,
      cardType: cardType ?? this.cardType,
      bankName: bankName ?? this.bankName,
    );
  }
}
