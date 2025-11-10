import 'chat_message_model.dart';
import 'doctor_model.dart';

enum ConsultationType { ai, doctor }

enum ConsultationStatus { active, completed, cancelled }

class Consultation {
  final String id;
  final ConsultationType type;
  final ConsultationStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final List<ChatMessage> messages;
  final Doctor? doctor;
  final String topic;

  Consultation({
    required this.id,
    required this.type,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.messages,
    this.doctor,
    required this.topic,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] ?? '',
      type: ConsultationType.values.firstWhere(
        (e) => e.toString() == 'ConsultationType.${json['type']}',
        orElse: () => ConsultationType.ai,
      ),
      status: ConsultationStatus.values.firstWhere(
        (e) => e.toString() == 'ConsultationStatus.${json['status']}',
        orElse: () => ConsultationStatus.active,
      ),
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      messages: (json['messages'] as List?)
              ?.map((m) => ChatMessage.fromJson(m))
              .toList() ??
          [],
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
      topic: json['topic'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'doctor': doctor?.toJson(),
      'topic': topic,
    };
  }
}