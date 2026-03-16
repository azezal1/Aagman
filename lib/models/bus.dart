class Bus {
  final String id;
  final String name;
  final String type;
  final String departureTime;
  final String arrivalTime;
  final int fare;

  Bus({
    required this.id,
    required this.name,
    required this.type,
    required this.departureTime,
    required this.arrivalTime,
    required this.fare,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      departureTime: json['departure_time'],
      arrivalTime: json['arrival_time'],
      fare: json['fare'],
    );
  }
}
