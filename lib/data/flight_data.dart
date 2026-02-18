class CityModel {
  final String name;
  final String code;
  final String country;

  CityModel({required this.name, required this.code, required this.country});

  String get fullName => "$name ($code)";
}

final List<CityModel> allCities = [
  CityModel(name: 'New York', code: 'JFK', country: 'United States'),
  CityModel(name: 'London', code: 'LHR', country: 'United Kingdom'),
  CityModel(name: 'Addis Ababa', code: 'ADD', country: 'Ethiopia'),
  CityModel(name: 'Dubai', code: 'DXB', country: 'United Arab Emirates'),
  CityModel(name: 'Paris', code: 'CDG', country: 'France'),
  CityModel(name: 'Tokyo', code: 'HND', country: 'Japan'),
  CityModel(name: 'Nairobi', code: 'NBO', country: 'Kenya'),
  CityModel(name: 'Istanbul', code: 'IST', country: 'Turkey'),
  CityModel(name: 'Mumbai', code: 'BOM', country: 'India'),
  CityModel(name: 'Cairo', code: 'CAI', country: 'Egypt'),
  CityModel(name: 'Houston', code: 'IAH', country: 'United States'),
];
