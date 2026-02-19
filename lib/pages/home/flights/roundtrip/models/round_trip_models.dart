import 'package:intl/intl.dart';

/// Represents a single flight option (used for both departure and return).
class RoundTripFlight {
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

  const RoundTripFlight({
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

  String get fromCode {
    final match = RegExp(r'\((\w+)').firstMatch(fromCity);
    return match?.group(1) ?? fromCity.split(' ').first;
  }

  String get toCode {
    final match = RegExp(r'\((\w+)').firstMatch(toCity);
    return match?.group(1) ?? toCity.split(' ').first;
  }
}

/// Search criteria for round-trip flights.
class RoundTripSearchCriteria {
  final String from;
  final String to;
  final DateTime departDate;
  final DateTime returnDate;
  final int travelers;
  final String cabinClass;

  const RoundTripSearchCriteria({
    required this.from,
    required this.to,
    required this.departDate,
    required this.returnDate,
    required this.travelers,
    required this.cabinClass,
  });
}

/// Fare option for a flight.
class RtFareOption {
  final String name;
  final String description;
  final double priceMultiplier;
  final List<RtFareFeature> features;

  const RtFareOption({
    required this.name,
    required this.description,
    required this.priceMultiplier,
    required this.features,
  });
}

class RtFareFeature {
  final String text;
  final RtFareFeatureType type;

  const RtFareFeature({required this.text, required this.type});
}

enum RtFareFeatureType { included, paid, notIncluded }

/// Seat on the plane.
class RtSeatInfo {
  final String label;
  final RtSeatType type;
  final double extraPrice;

  const RtSeatInfo({
    required this.label,
    required this.type,
    this.extraPrice = 0,
  });
}

enum RtSeatType { available, occupied, premium, exit }

/// Baggage option.
class RtBaggageOption {
  final String label;
  final String description;
  final double price;
  final int bags;

  const RtBaggageOption({
    required this.label,
    required this.description,
    required this.price,
    required this.bags,
  });
}

/// Booking state that accumulates through the round-trip flow.
class RoundTripBooking {
  final RoundTripSearchCriteria criteria;
  final RoundTripFlight departureFlight;
  final RoundTripFlight returnFlight;
  final RtFareOption fare;
  final String? departureSeat;
  final double departureSeatPrice;
  final String? returnSeat;
  final double returnSeatPrice;
  final RtBaggageOption? baggage;

  const RoundTripBooking({
    required this.criteria,
    required this.departureFlight,
    required this.returnFlight,
    required this.fare,
    this.departureSeat,
    this.departureSeatPrice = 0,
    this.returnSeat,
    this.returnSeatPrice = 0,
    this.baggage,
  });

  RoundTripBooking copyWith({
    String? departureSeat,
    double? departureSeatPrice,
    String? returnSeat,
    double? returnSeatPrice,
    RtBaggageOption? baggage,
  }) {
    return RoundTripBooking(
      criteria: criteria,
      departureFlight: departureFlight,
      returnFlight: returnFlight,
      fare: fare,
      departureSeat: departureSeat ?? this.departureSeat,
      departureSeatPrice: departureSeatPrice ?? this.departureSeatPrice,
      returnSeat: returnSeat ?? this.returnSeat,
      returnSeatPrice: returnSeatPrice ?? this.returnSeatPrice,
      baggage: baggage ?? this.baggage,
    );
  }

  double get totalSeatPrice => departureSeatPrice + returnSeatPrice;

  double get totalPrice {
    final departFare = departureFlight.price * fare.priceMultiplier;
    final returnFare = returnFlight.price * fare.priceMultiplier;
    final bagPrice = baggage?.price ?? 0;
    return departFare + returnFare + totalSeatPrice + bagPrice;
  }
}
