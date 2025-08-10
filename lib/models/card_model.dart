class CardModel {
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
    required this.firstName,
    required this.lastName,
    required this.cardNumber,
    required this.cvv,
    required this.expiry,
    required this.country,
    required this.city,
    required this.pin,
    this.cardType,
    this.bankName,
  }) : id = id ?? generateId();

  static String generateId() => DateTime.now().microsecondsSinceEpoch.toString();

  // Empty constructor for edge cases
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
  return 'CardModel(id: $id, name: $firstName $lastName, last4: ${cardNumber.length >= 4 ? cardNumber.substring(cardNumber.length - 4) : cardNumber})';
  }
}
