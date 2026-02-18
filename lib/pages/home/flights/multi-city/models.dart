import 'package:intl/intl.dart';

class MultiCityFlight {
  final String id;
  final String airline;
  final String flightNumber;
  final String fromCity;
  final String toCity;
  final DateTime date;
  final String departTime;
  final String arriveTime;
  final String duration;
  final String stops;
  final double price;
  final String cabin;
  final String? layoverInfo;
  final int? seatsLeft;
  final String? operatedBy;

  const MultiCityFlight({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.departTime,
    required this.arriveTime,
    required this.duration,
    required this.stops,
    required this.price,
    required this.cabin,
    this.layoverInfo,
    this.seatsLeft,
    this.operatedBy,
  });

  String get dateLabel => DateFormat('EEE, MMM d').format(date);
}

class MultiCitySearchCriteria {
  final String from1;
  final String to1;
  final DateTime depart1;
  final String from2;
  final String to2;
  final DateTime depart2;
  final String? from3;
  final String? to3;
  final DateTime? depart3;
  final int travelers;
  final String cabinClass;

  const MultiCitySearchCriteria({
    required this.from1,
    required this.to1,
    required this.depart1,
    required this.from2,
    required this.to2,
    required this.depart2,
    this.from3,
    this.to3,
    this.depart3,
    required this.travelers,
    required this.cabinClass,
  });

  bool get hasThirdLeg => from3 != null && to3 != null && depart3 != null;
}

class MultiCitySelection {
  final MultiCitySearchCriteria criteria;
  final MultiCityFlight? flight1;
  final MultiCityFlight? flight2;
  final MultiCityFlight? flight3;

  const MultiCitySelection({
    required this.criteria,
    this.flight1,
    this.flight2,
    this.flight3,
  });

  MultiCitySelection copyWith({
    MultiCityFlight? flight1,
    MultiCityFlight? flight2,
    MultiCityFlight? flight3,
  }) {
    return MultiCitySelection(
      criteria: criteria,
      flight1: flight1 ?? this.flight1,
      flight2: flight2 ?? this.flight2,
      flight3: flight3 ?? this.flight3,
    );
  }
}
