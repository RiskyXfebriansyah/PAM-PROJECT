import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/chat_message_model.dart';

class AIService {
  static const String apiKey = "AIzaSyCIiAvK3UvvISsSUw2LC3_qi3bRRvayyaE";
  
  late final GenerativeModel _model;
  late ChatSession _chat;
  
  AIService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
      systemInstruction: Content.system(_systemPrompt),
    );
    _chat = _model.startChat();
  }

  static const String _systemPrompt = '''
Anda adalah asisten AI konselor kesehatan mental profesional bernama "Serene AI Assistant".

PERAN ANDA:
- Memberikan dukungan emosional yang hangat dan empati
- Mendengarkan keluhan dengan penuh perhatian
- Memberikan saran awal yang membantu
- Mengarahkan ke dokter profesional jika diperlukan

CARA BERKOMUNIKASI:
- Gunakan bahasa Indonesia yang santun dan mudah dipahami
- Bersikap empati dan tidak menghakimi
- Tanyakan lebih detail untuk memahami situasi pengguna
- Berikan respons yang personal dan relevan

PENTING:
- JANGAN memberikan diagnosis medis
- Jika ada tanda masalah serius (bunuh diri, kekerasan, psikosis), SEGERA sarankan untuk konsultasi dengan dokter profesional
- Jaga privasi dan kerahasiaan pengguna
- Fokus pada dukungan emosional dan coping strategies

CONTOH RESPONS BAIK:
"Saya mendengar Anda sedang merasa cemas. Bisa ceritakan lebih detail apa yang membuat Anda cemas? Saya di sini untuk mendengarkan."

CONTOH RESPONS BURUK:
"Anda mengalami Generalized Anxiety Disorder. Minum obat X."
''';

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      
      if (response.text == null) {
        throw Exception('Tidak ada respons dari AI');
      }
      
      return response.text!;
    } catch (e) {
      print('Error in AIService.sendMessage: $e');
      return _getFallbackResponse();
    }
  }

  Future<String> sendMessageWithHistory(List<ChatMessage> history, String newMessage) async {
    try {
      // Restart chat dengan history
      _chat = _model.startChat(history: _convertHistoryToContent(history));
      
      final response = await _chat.sendMessage(Content.text(newMessage));
      
      if (response.text == null) {
        throw Exception('Tidak ada respons dari AI');
      }
      
      return response.text!;
    } catch (e) {
      print('Error in AIService.sendMessageWithHistory: $e');
      return _getFallbackResponse();
    }
  }

  List<Content> _convertHistoryToContent(List<ChatMessage> history) {
    return history.map((msg) {
      return Content(
        msg.type == MessageType.user ? 'user' : 'model',
        [TextPart(msg.content)],
      );
    }).toList();
  }

  String _getFallbackResponse() {
    return '''
Maaf, saat ini saya mengalami kendala teknis. 😔

Untuk mendapatkan bantuan segera, Anda bisa:
1. 💬 Konsultasi langsung dengan dokter profesional kami
2. 📞 Hubungi hotline kesehatan mental: 119 ext 8
3. 🔄 Atau coba lagi dalam beberapa saat

Jika ini situasi darurat, segera hubungi:
- 🚑 119 (Ambulans)
- 📞 021-500-454 (Yayasan Pulih)
- 📞 021-7256526 (Into The Light Indonesia)
''';
  }

  bool isEmergency(String message) {
    final emergencyKeywords = [
      'bunuh diri',
      'ingin mati',
      'mengakhiri hidup',
      'suicide',
      'menyakiti diri',
      'melukai diri',
      'tidak ingin hidup',
      'ingin bunuh diri',
      'mau mati',
      'pengen mati',
    ];

    final lowerMessage = message.toLowerCase();
    return emergencyKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  String getEmergencyResponse() {
    return '''
⚠️ **PENTING - BANTUAN DARURAT** ⚠️

Saya sangat khawatir dengan keadaan Anda saat ini. Keselamatan Anda adalah prioritas utama. 💙

**HUBUNGI SEGERA:**
📞 **119 ext 8** - Hotline Kesehatan Mental 24/7
📞 **021-500-454** - Yayasan Pulih
📞 **021-7256526** - Into The Light Indonesia
📞 **119** - Ambulans (Darurat)

**Atau klik tombol "Konsultasi Dokter" untuk berbicara dengan profesional kami sekarang.**

Ingat: Anda tidak sendirian. Ada banyak orang yang peduli dan ingin membantu Anda. Hidup Anda berharga. 💙✨

Jika perlu teman bicara segera, saya di sini mendengarkan Anda. Ceritakan apa yang Anda rasakan.
''';
  }

  void resetChat() {
    _chat = _model.startChat();
  }
}