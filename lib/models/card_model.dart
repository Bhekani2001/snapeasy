class CardModel {
  final String id;
  final String firstName;
  final String lastName;
  final String cardNumber;
  final String cvv;
  final String expiry;
  final String country;
  final String city;

  CardModel({
    String? id,
    required this.firstName,
    required this.lastName,
    required this.cardNumber,
    required this.cvv,
    required this.expiry,
    required this.country,
    required this.city,
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
        city = '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'cardNumber': cardNumber,
    'cvv': cvv,
    'expiry': expiry,
    'country': country,
    'city': city,
  };

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
    id: json['id'] ?? generateId(),
    firstName: json['firstName'],
    lastName: json['lastName'],
    cardNumber: json['cardNumber'],
    cvv: json['cvv'],
    expiry: json['expiry'],
    country: json['country'],
    city: json['city'],
  );
}