// lib/models/trip_model.dart

class TripModel {
  final String? id;
  final String userId;
  final String location;
  final String? date;
  final String? fromTime;
  final String? toTime;
  final int numberOfTravelers;
  final double fee;
  final String? guideLanguage;
  final String? guideName;
  final List<String> attractions;
  final String status;

  TripModel({
    this.id,
    required this.userId,
    required this.location,
    this.date,
    this.fromTime,
    this.toTime,
    this.numberOfTravelers = 1,
    this.fee = 0,
    this.guideLanguage,
    this.guideName,
    this.attractions = const [],
    this.status = 'pending',
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      userId: json['user_id'] ?? '',
      location: json['location'] ?? '',
      date: json['date'],
      fromTime: json['from_time'],
      toTime: json['to_time'],
      numberOfTravelers: json['number_of_travelers'] ?? 1,
      fee: (json['fee'] ?? 0).toDouble(),
      guideLanguage: json['guide_language'],
      guideName: json['guide_name'],
      attractions: json['attractions'] != null
          ? List<String>.from(json['attractions'])
          : [],
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'location': location,
        'date': date,
        'from_time': fromTime,
        'to_time': toTime,
        'number_of_travelers': numberOfTravelers,
        'fee': fee,
        'guide_language': guideLanguage,
        'guide_name': guideName,
        'attractions': attractions,
        'status': status,
      };
}
