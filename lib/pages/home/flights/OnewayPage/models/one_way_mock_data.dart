import 'dart:math';
import 'one_way_models.dart';

// ─── Airlines ───
const _airlines = [
  _Airline('Ethiopian Airlines', 'ET'),
  _Airline('Emirates', 'EK'),
  _Airline('Qatar Airways', 'QR'),
  _Airline('Turkish Airlines', 'TK'),
  _Airline('Lufthansa', 'LH'),
  _Airline('British Airways', 'BA'),
  _Airline('American Airlines', 'AA'),
  _Airline('United Airlines', 'UA'),
  _Airline('Delta', 'DL'),
  _Airline('Air France', 'AF'),
  _Airline('EGYPTAIR', 'MS'),
  _Airline('KLM', 'KL'),
  _Airline('Singapore Airlines', 'SQ'),
  _Airline('JetBlue', 'B6'),
  _Airline('Virgin Atlantic', 'VS'),
];

const _layoverHubs = [
  'FRA',
  'IST',
  'DOH',
  'DXB',
  'CAI',
  'CDG',
  'AMS',
  'ATL',
  'DFW',
  'EWR',
  'JFK',
  'ORD',
  'NBO',
  'BOM',
  'SIN',
  'HND',
];

const _departureTimes = [
  '12:20am',
  '1:45am',
  '4:05am',
  '6:30am',
  '8:10am',
  '9:20am',
  '9:35am',
  '10:10am',
  '12:10pm',
  '12:30pm',
  '12:35pm',
  '1:40pm',
  '3:15pm',
  '6:15pm',
  '6:30pm',
  '8:45pm',
  '10:10pm',
];

/// Generate deterministic one-way flights for a route and date.
List<OneWayFlight> generateOneWayFlights(
  String fromCity,
  String toCity,
  DateTime date, {
  String cabin = 'Economy',
}) {
  final seed = 'OW-$fromCity→$toCity→${date.toIso8601String()}'.hashCode;
  final rng = Random(seed);

  final fromCode = _extractCode(fromCity);
  final toCode = _extractCode(toCity);

  final count = 4 + rng.nextInt(5); // 4-8 flights

  final shuffled = List<_Airline>.from(_airlines)..shuffle(rng);
  final chosenAirlines = shuffled.take(count).toList();
  final shuffledHubs = List<String>.from(_layoverHubs)..shuffle(rng);

  final flights = <OneWayFlight>[];

  for (var i = 0; i < count; i++) {
    final airline = chosenAirlines[i];
    final flightNum = '${airline.code}-${100 + rng.nextInt(900)}';

    final totalMinutes = 120 + rng.nextInt(16 * 60);
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    final duration = '${hours}h ${mins.toString().padLeft(2, '0')}m';

    final departTime = _departureTimes[rng.nextInt(_departureTimes.length)];
    final arriveTime = _offsetTime(departTime, totalMinutes);

    final isNonstop = rng.nextDouble() < 0.30;
    final stops = isNonstop ? 'Nonstop' : '1 stop';

    String? layoverInfo;
    if (!isNonstop) {
      var hub = shuffledHubs[i % shuffledHubs.length];
      if (hub == fromCode || hub == toCode) {
        hub = shuffledHubs[(i + 3) % shuffledHubs.length];
      }
      final layH = 1 + rng.nextInt(4);
      final layM = rng.nextInt(60);
      layoverInfo = '${layH}h ${layM.toString().padLeft(2, '0')}m in $hub';
    }

    // Base price adjusted by cabin
    double basePrice = (250 + rng.nextInt(4000)).toDouble();
    if (cabin == 'Business') basePrice *= 2.5;
    if (cabin == 'First') basePrice *= 4.0;
    if (cabin == 'Premium Economy') basePrice *= 1.6;

    final showSeats = rng.nextDouble() < 0.35;
    final seatsLeft = showSeats ? 2 + rng.nextInt(7) : null;

    final showOpBy = !isNonstop && rng.nextDouble() < 0.3;
    final operatedBy = showOpBy
        ? '${airline.name} and ${shuffled[(i + 1) % shuffled.length].name}'
        : null;

    flights.add(
      OneWayFlight(
        id: 'OW-$fromCode-$toCode-${i + 1}',
        airline: airline.name,
        flightNumber: flightNum,
        fromCity: fromCity,
        toCity: toCity,
        date: date,
        departTime: departTime,
        arriveTime: arriveTime,
        duration: duration,
        stops: stops,
        price: basePrice,
        cabin: cabin,
        layoverInfo: layoverInfo,
        seatsLeft: seatsLeft,
        operatedBy: operatedBy,
      ),
    );
  }

  flights.sort((a, b) => a.price.compareTo(b.price));
  return flights;
}

/// Generate price hints for surrounding dates.
Map<DateTime, double> generateDatePrices(
  String fromCity,
  String toCity,
  DateTime centerDate, {
  String cabin = 'Economy',
}) {
  final prices = <DateTime, double>{};
  for (int offset = -3; offset <= 4; offset++) {
    final d = centerDate.add(Duration(days: offset));
    final flights = generateOneWayFlights(fromCity, toCity, d, cabin: cabin);
    if (flights.isNotEmpty) {
      prices[d] = flights.map((f) => f.price).reduce((a, b) => a < b ? a : b);
    }
  }
  return prices;
}

/// Predefined fare options.
List<FareOption> getFareOptions() => const [
  FareOption(
    name: 'Basic Economy',
    description: 'No changes or cancellations',
    priceMultiplier: 1.0,
    features: [
      FareFeature(
        text: 'Personal item included',
        type: FareFeatureType.included,
      ),
      FareFeature(
        text: 'Carry-on bag not included',
        type: FareFeatureType.notIncluded,
      ),
      FareFeature(
        text: 'Seat assigned at check-in',
        type: FareFeatureType.notIncluded,
      ),
      FareFeature(text: 'Non-refundable', type: FareFeatureType.notIncluded),
      FareFeature(
        text: 'No changes allowed',
        type: FareFeatureType.notIncluded,
      ),
    ],
  ),
  FareOption(
    name: 'Economy',
    description: 'Changes for a fee',
    priceMultiplier: 1.15,
    features: [
      FareFeature(
        text: 'Personal item included',
        type: FareFeatureType.included,
      ),
      FareFeature(
        text: 'Carry-on bag included',
        type: FareFeatureType.included,
      ),
      FareFeature(text: 'Seat choice for a fee', type: FareFeatureType.paid),
      FareFeature(text: 'Non-refundable', type: FareFeatureType.notIncluded),
      FareFeature(text: 'Change fee: \$100', type: FareFeatureType.paid),
    ],
  ),
  FareOption(
    name: 'Economy Flex',
    description: 'Free changes & cancellation',
    priceMultiplier: 1.40,
    features: [
      FareFeature(
        text: 'Personal item included',
        type: FareFeatureType.included,
      ),
      FareFeature(
        text: 'Carry-on bag included',
        type: FareFeatureType.included,
      ),
      FareFeature(
        text: '1 checked bag included',
        type: FareFeatureType.included,
      ),
      FareFeature(text: 'Seat choice included', type: FareFeatureType.included),
      FareFeature(text: 'Free cancellation', type: FareFeatureType.included),
      FareFeature(text: 'Free changes', type: FareFeatureType.included),
    ],
  ),
];

/// Seat map generator for seat selection page.
List<List<SeatInfo>> generateSeatMap() {
  final rng = Random(42);
  final rows = <List<SeatInfo>>[];
  final cols = ['A', 'B', 'C', '', 'D', 'E', 'F'];

  for (int row = 1; row <= 25; row++) {
    final seats = <SeatInfo>[];
    for (final col in cols) {
      if (col.isEmpty) {
        seats.add(const SeatInfo(label: '', type: SeatType.available));
        continue;
      }
      final label = '$row$col';
      final isExit = row == 12 || row == 13;
      if (rng.nextDouble() < 0.35) {
        seats.add(SeatInfo(label: label, type: SeatType.occupied));
      } else if (isExit) {
        seats.add(SeatInfo(label: label, type: SeatType.exit, extraPrice: 35));
      } else if (row <= 4) {
        seats.add(
          SeatInfo(label: label, type: SeatType.premium, extraPrice: 55),
        );
      } else {
        seats.add(SeatInfo(label: label, type: SeatType.available));
      }
    }
    rows.add(seats);
  }
  return rows;
}

/// Baggage options.
List<BaggageOption> getBaggageOptions() => const [
  BaggageOption(
    label: 'No checked bags',
    description: 'Carry-on only',
    price: 0,
    bags: 0,
  ),
  BaggageOption(
    label: '1 checked bag',
    description: 'Up to 50 lbs (23 kg)',
    price: 35,
    bags: 1,
  ),
  BaggageOption(
    label: '2 checked bags',
    description: 'Up to 50 lbs (23 kg) each',
    price: 60,
    bags: 2,
  ),
];

// ─── Private helpers ───

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

class _Airline {
  final String name;
  final String code;
  const _Airline(this.name, this.code);
}
