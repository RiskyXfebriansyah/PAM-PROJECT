import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/doctor_model.dart';
import '../models/consultation_model.dart';

class DoctorService {
  static const String _consultationsKey = 'consultations';
  
  // Load daftar dokter dari JSON atau dummy data
  Future<List<Doctor>> loadDoctors() async {
    try {
      final String response = await rootBundle.loadString('assets/data/doctors.json');
      final data = json.decode(response);
      final List<dynamic> doctorsJson = data['doctors'];
      
      return doctorsJson.map((json) => Doctor.fromJson(json)).toList();
    } catch (e) {
      print('Error loading doctors from JSON: $e');
      print('Using dummy data instead...');
      return _getDummyDoctors();
    }
  }

  Future<List<Doctor>> getDoctorsBySpecialization(String specialization) async {
    final doctors = await loadDoctors();
    if (specialization.isEmpty || specialization == 'Semua') {
      return doctors;
    }
    return doctors.where((d) => d.specialization == specialization).toList();
  }

  Future<List<Doctor>> getAvailableDoctors() async {
    final doctors = await loadDoctors();
    return doctors.where((d) => d.isAvailable).toList();
  }

  Future<List<Doctor>> searchDoctors(String query) async {
    final doctors = await loadDoctors();
    final lowercaseQuery = query.toLowerCase();
    
    return doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(lowercaseQuery) ||
             doctor.specialization.toLowerCase().contains(lowercaseQuery) ||
             doctor.expertise.any((e) => e.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Future<Doctor?> getDoctorById(String id) async {
    final doctors = await loadDoctors();
    try {
      return doctors.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> saveConsultation(Consultation consultation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final consultations = await getConsultations();
      
      final index = consultations.indexWhere((c) => c.id == consultation.id);
      if (index != -1) {
        consultations[index] = consultation;
      } else {
        consultations.add(consultation);
      }
      
      final jsonList = consultations.map((c) => c.toJson()).toList();
      await prefs.setString(_consultationsKey, jsonEncode(jsonList));
      
      return true;
    } catch (e) {
      print('Error saving consultation: $e');
      return false;
    }
  }

  Future<List<Consultation>> getConsultations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_consultationsKey);
      
      if (jsonString == null) return [];
      
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Consultation.fromJson(json)).toList();
    } catch (e) {
      print('Error loading consultations: $e');
      return [];
    }
  }

  Future<List<Consultation>> getConsultationsWithDoctor(String doctorId) async {
    final consultations = await getConsultations();
    return consultations.where((c) => c.doctor?.id == doctorId).toList();
  }

  Future<List<Consultation>> getActiveConsultations() async {
    final consultations = await getConsultations();
    return consultations.where((c) => c.status == ConsultationStatus.active).toList();
  }

  List<Doctor> _getDummyDoctors() {
    return [
      Doctor(
        id: 'doc001',
        name: 'Dr. Sarah Wijaya, Sp.KJ',
        specialization: 'Psikiater',
        imageUrl: 'https://ui-avatars.com/api/?name=Sarah+Wijaya&background=6B9080&color=fff&size=200',
        rating: 4.9,
        experience: 12,
        description: 'Spesialis kesehatan mental dengan fokus pada penanganan anxiety, depression, dan stress management. Berpengalaman menangani pasien dengan berbagai latar belakang.',
        expertise: ['Gangguan Kecemasan', 'Depresi', 'Manajemen Stress', 'Konseling Keluarga'],
        isAvailable: true,
        consultationPrice: 250000,
        workingHours: 'Senin-Jumat: 09:00-17:00, Sabtu: 09:00-13:00',
        education: 'Sp.KJ - Universitas Indonesia',
        totalPatients: 1250,
      ),
      Doctor(
        id: 'doc002',
        name: 'Dr. Ahmad Hidayat, M.Psi',
        specialization: 'Psikolog Klinis',
        imageUrl: 'https://ui-avatars.com/api/?name=Ahmad+Hidayat&background=4A6FA5&color=fff&size=200',
        rating: 4.8,
        experience: 8,
        description: 'Psikolog klinis yang berfokus pada terapi kognitif perilaku (CBT) dan mindfulness. Ahli dalam menangani masalah hubungan dan self-esteem.',
        expertise: ['Cognitive Behavioral Therapy', 'Mindfulness', 'Relationship Counseling', 'Self-Esteem Issues'],
        isAvailable: true,
        consultationPrice: 200000,
        workingHours: 'Senin-Kamis: 10:00-18:00, Jumat: 13:00-20:00',
        education: 'M.Psi - Universitas Gadjah Mada',
        totalPatients: 890,
      ),
      Doctor(
        id: 'doc003',
        name: 'Dr. Rina Kusuma, Sp.KJ',
        specialization: 'Psikiater',
        imageUrl: 'https://ui-avatars.com/api/?name=Rina+Kusuma&background=E07A5F&color=fff&size=200',
        rating: 4.7,
        experience: 15,
        description: 'Berpengalaman dalam penanganan gangguan mood, trauma, dan PTSD. Menggunakan pendekatan holistik dalam perawatan pasien.',
        expertise: ['Gangguan Mood', 'PTSD', 'Trauma Therapy', 'Bipolar Disorder'],
        isAvailable: false,
        consultationPrice: 300000,
        workingHours: 'Selasa-Sabtu: 08:00-16:00',
        education: 'Sp.KJ - Universitas Airlangga',
        totalPatients: 1580,
      ),
      Doctor(
        id: 'doc004',
        name: 'Dr. Budi Santoso, M.Psi',
        specialization: 'Psikolog Klinis',
        imageUrl: 'https://ui-avatars.com/api/?name=Budi+Santoso&background=3D5A80&color=fff&size=200',
        rating: 4.9,
        experience: 10,
        description: 'Spesialis dalam konseling remaja dan dewasa muda. Fokus pada pengembangan diri, karir, dan adaptasi sosial.',
        expertise: ['Konseling Remaja', 'Career Counseling', 'Social Adaptation', 'Personal Development'],
        isAvailable: true,
        consultationPrice: 180000,
        workingHours: 'Senin-Jumat: 13:00-21:00',
        education: 'M.Psi - Universitas Padjadjaran',
        totalPatients: 720,
      ),
      Doctor(
        id: 'doc005',
        name: 'Dr. Maya Putri, Sp.KJ',
        specialization: 'Psikiater',
        imageUrl: 'https://ui-avatars.com/api/?name=Maya+Putri&background=81B29A&color=fff&size=200',
        rating: 4.8,
        experience: 9,
        description: 'Ahli dalam penanganan gangguan kecemasan dan panic disorder. Menggunakan kombinasi terapi medis dan psikoterapi.',
        expertise: ['Panic Disorder', 'Generalized Anxiety', 'OCD', 'Phobia'],
        isAvailable: true,
        consultationPrice: 275000,
        workingHours: 'Senin-Rabu: 09:00-17:00, Kamis-Jumat: 13:00-20:00',
        education: 'Sp.KJ - Universitas Indonesia',
        totalPatients: 950,
      ),
    ];
  }
}