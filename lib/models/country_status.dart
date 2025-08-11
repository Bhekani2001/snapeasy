import 'package:equatable/equatable.dart';

class CountryStatus extends Equatable {
  final String name;
  final bool bannedMastercard;
  final bool bannedVisa;
  final bool bannedAmex;
  final bool bannedDiscover;

  const CountryStatus({
    required this.name,
    this.bannedMastercard = false,
    this.bannedVisa = false,
    this.bannedAmex = false,
    this.bannedDiscover = false,
  });

  CountryStatus copyWith({
    String? name,
    bool? bannedMastercard,
    bool? bannedVisa,
    bool? bannedAmex,
    bool? bannedDiscover,
  }) {
    return CountryStatus(
      name: name ?? this.name,
      bannedMastercard: bannedMastercard ?? this.bannedMastercard,
      bannedVisa: bannedVisa ?? this.bannedVisa,
      bannedAmex: bannedAmex ?? this.bannedAmex,
      bannedDiscover: bannedDiscover ?? this.bannedDiscover,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'bannedMastercard': bannedMastercard,
    'bannedVisa': bannedVisa,
    'bannedAmex': bannedAmex,
    'bannedDiscover': bannedDiscover,
  };

  factory CountryStatus.fromJson(Map<String, dynamic> json) {
    return CountryStatus(
      name: json['name'] as String,
      bannedMastercard: json['bannedMastercard'] as bool? ?? false,
      bannedVisa: json['bannedVisa'] as bool? ?? false,
      bannedAmex: json['bannedAmex'] as bool? ?? false,
      bannedDiscover: json['bannedDiscover'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [name, bannedMastercard, bannedVisa, bannedAmex, bannedDiscover];
}

final List<CountryStatus> worldCountries = [
  const CountryStatus(name: 'Brazil'),
  const CountryStatus(name: 'Russia', bannedMastercard: true, bannedVisa: true),
  const CountryStatus(name: 'India'),
  const CountryStatus(name: 'China'),
  const CountryStatus(name: 'South Africa'),
];
