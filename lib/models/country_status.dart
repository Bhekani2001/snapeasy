class CountryStatus {
  final String name;
  final bool bannedMastercard;
  final bool bannedVisa;
  // Add more card types as needed

  CountryStatus({
    required this.name,
    this.bannedMastercard = false,
    this.bannedVisa = false,
  });
}

final List<CountryStatus> worldCountries = [
  CountryStatus(name: 'Russia', bannedMastercard: true),
  CountryStatus(name: 'United States'),
  CountryStatus(name: 'United Kingdom'),
  CountryStatus(name: 'Germany'),
  CountryStatus(name: 'France'),
  CountryStatus(name: 'China'),
  CountryStatus(name: 'India'),
  CountryStatus(name: 'South Africa'),
  CountryStatus(name: 'Brazil'),
  // Add more countries and banned statuses as needed
];
