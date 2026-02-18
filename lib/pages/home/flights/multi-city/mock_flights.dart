import 'dart:math';
import 'models.dart';

/// A pool of airlines with realistic data used to generate mock flights.
const _airlines = [
  _AirlineTemplate('Ethiopian Airlines', 'ET'),
  _AirlineTemplate('Emirates', 'EK'),
  _AirlineTemplate('Qatar Airways', 'QR'),
  _AirlineTemplate('Turkish Airlines', 'TK'),
  _AirlineTemplate('Lufthansa', 'LH'),
  _AirlineTemplate('British Airways', 'BA'),
  _AirlineTemplate('American Airlines', 'AA'),
  _AirlineTemplate('United Airlines', 'UA'),
  _AirlineTemplate('Delta', 'DL'),
  _AirlineTemplate('Air France', 'AF'),
  _AirlineTemplate('EGYPTAIR', 'MS'),
  _AirlineTemplate('KLM', 'KL'),
  _AirlineTemplate('Singapore Airlines', 'SQ'),
  _AirlineTemplate('JetBlue', 'B6'),
  _AirlineTemplate('Virgin Atlantic', 'VS'),
];

const _layoverHubs = [
  'FRA', 'IST', 'DOH', 'DXB', 'CAI', 'CDG', 'AMS', 'ATL',
  'DFW', 'EWR', 'JFK', 'ORD', 'NBO', 'BOM', 'SIN', 'HND',
];

const _departureTimes = [
  '12:20am', '1:45am', '4:05am', '6:30am', '8:10am', '9:20am',
  '9:35am', '10:10am', '12:10pm', '12:30pm', '12:35pm', '1:40pm',
  '3:15pm', '6:15pm', '6:30pm', '8:45pm', '10:10pm',
];

/// Generate a deterministic list of mock flights for a given route & date.
///
/// Uses a seeded random so the same from/to/date always returns the same
/// flights, making the UI feel consistent across rebuilds.
List<MultiCityFlight> generateFlightsForRoute(
  String fromCity,
  String toCity,
  DateTime date,
) {
  // Seed based on route + date so results are stable for the same inputs.
  final seed = '$fromCity→$toCity→${date.toIso8601String()}'.hashCode;
  final rng = Random(seed);

  final fromCode = _extractCode(fromCity);
  final toCode = _extractCode(toCity);

  // Generate between 3 and 6 flights per route.
  final count = 3 + rng.nextInt(4);

  // Shuffle airlines deterministically and pick `count`.
  final shuffled = List<_AirlineTemplate>.from(_airlines)..shuffle(rng);
  final chosenAirlines = shuffled.take(count).toList();

  // Shuffled layover hubs.
  final shuffledHubs = List<String>.from(_layoverHubs)..shuffle(rng);

  final flights = <MultiCityFlight>[];

  for (var i = 0; i < count; i++) {
    final airline = chosenAirlines[i];
    final flightNum = '${airline.code}-${100 + rng.nextInt(900)}';

    // Duration between 2h and 18h.
    final totalMinutes = 120 + rng.nextInt(16 * 60);
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    final duration = '${hours}h ${mins.toString().padLeft(2, '0')}m';

    // Pick depart time.
    final departTime = _departureTimes[rng.nextInt(_departureTimes.length)];

    // Arrival time — offset from depart.
    final arriveTime = _offsetTime(departTime, totalMinutes);

    // Stops.
    final isNonstop = rng.nextDouble() < 0.35;
    final stops = isNonstop ? 'Nonstop' : '1 stop';

    // Layover info for non-nonstop.
    String? layoverInfo;
    if (!isNonstop) {
      // Pick a hub that isn't the from/to city.
      var hub = shuffledHubs[i % shuffledHubs.length];
      if (hub == fromCode || hub == toCode) {
        hub = shuffledHubs[(i + 3) % shuffledHubs.length];
      }
      final layH = 1 + rng.nextInt(4);
      final layM = rng.nextInt(60);
      layoverInfo =
          '${layH}h ${layM.toString().padLeft(2, '0')}m in $hub';
    }

    // Price between $250 and $7,000.
    final price = (250 + rng.nextInt(6750)).toDouble();

    // Seats left — occasionally show urgency.
    final showSeats = rng.nextDouble() < 0.35;
    final seatsLeft = showSeats ? 2 + rng.nextInt(7) : null;

    // Operated by — occasionally.
    final showOpBy = !isNonstop && rng.nextDouble() < 0.3;
    final operatedBy = showOpBy
        ? '${airline.name} and ${shuffled[(i + 1) % shuffled.length].name}'
        : null;

    flights.add(MultiCityFlight(
      id: 'MC-$fromCode-$toCode-${i + 1}',
      airline: airline.name,
      flightNumber: flightNum,
      fromCity: fromCity,
      toCity: toCity,
      date: date,
      departTime: departTime,
      arriveTime: arriveTime,
      duration: duration,
      stops: stops,
      price: price,
      cabin: 'Economy',
      layoverInfo: layoverInfo,
      seatsLeft: seatsLeft,
      operatedBy: operatedBy,
    ));
  }

  // Sort by price ascending.
  flights.sort((a, b) => a.price.compareTo(b.price));
  return flights;
}

// ──────────── Private helpers ────────────

String _extractCode(String cityString) {
  final match = RegExp(r'\((\w+)\)').firstMatch(cityString);
  return match != null ? match.group(1)! : cityString.split(' ').first;
}

String _offsetTime(String depart, int addMinutes) {
  final match = RegExp(r'(\d+):(\d+)(am|pm)').firstMatch(depart);
  if (match == null) return '11:59pm';

  var h = int.parse(match.group(1)!);
  final m = int.parse(match.group(2)!);
  final ampm = match.group(3)!;

  if (ampm == 'pm' && h != 12) h += 12;
  if (ampm == 'am' && h == 12) h = 0;

  final total = h * 60 + m + addMinutes;
  var newH = (total ~/ 60) % 24;
  final newM = total % 60;

  final newAmPm = newH >= 12 ? 'pm' : 'am';
  if (newH == 0) newH = 12;
  if (newH > 12) newH -= 12;

  return '$newH:${newM.toString().padLeft(2, '0')}$newAmPm';
}

class _AirlineTemplate {
  final String name;
  final String code;
  const _AirlineTemplate(this.name, this.code);
}
