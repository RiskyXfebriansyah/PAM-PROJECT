class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String imageUrl;
  final double rating;
  final int experience;
  final String description;
  final List<String> expertise;
  final bool isAvailable;
  final int consultationPrice;
  final String workingHours;
  final String education;
  final int totalPatients;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.imageUrl,
    required this.rating,
    required this.experience,
    required this.description,
    required this.expertise,
    required this.isAvailable,
    required this.consultationPrice,
    required this.workingHours,
    required this.education,
    required this.totalPatients,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      experience: json['experience'] ?? 0,
      description: json['description'] ?? '',
      expertise: List<String>.from(json['expertise'] ?? []),
      isAvailable: json['isAvailable'] ?? false,
      consultationPrice: json['consultationPrice'] ?? 0,
      workingHours: json['workingHours'] ?? '',
      education: json['education'] ?? '',
      totalPatients: json['totalPatients'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'imageUrl': imageUrl,
      'rating': rating,
      'experience': experience,
      'description': description,
      'expertise': expertise,
      'isAvailable': isAvailable,
      'consultationPrice': consultationPrice,
      'workingHours': workingHours,
      'education': education,
      'totalPatients': totalPatients,
    };
  }
}