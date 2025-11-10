import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uuid/uuid.dart';
import '../models/doctor_model.dart';
import '../models/chat_message_model.dart';
import '../models/consultation_model.dart';
import '../services/doctor_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/typing_indicator.dart';

class DoctorChatScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorChatScreen({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DoctorService _doctorService = DoctorService();
  final Uuid _uuid = const Uuid();
  
  late Consultation _consultation;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeConsultation();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _saveConsultation();
    super.dispose();
  }

  void _initializeConsultation() {
    _consultation = Consultation(
      id: _uuid.v4(),
      type: ConsultationType.doctor,
      status: ConsultationStatus.active,
      startTime: DateTime.now(),
      messages: [],
      doctor: widget.doctor,
      topic: 'Konsultasi dengan ${widget.doctor.name}',
    );

    // Welcome message from doctor
    final welcomeMessage = ChatMessage(
      id: _uuid.v4(),
      content: 'Halo! Saya ${widget.doctor.name}.\n\n'
          'Senang bisa membantu Anda hari ini. Saya akan mendengarkan dengan seksama apa yang ingin Anda sampaikan.\n\n'
          'Silakan ceritakan apa yang bisa saya bantu. Semua informasi yang Anda bagikan akan dijaga kerahasiaannya.',
      type: MessageType.doctor,
      timestamp: DateTime.now(),
      senderName: widget.doctor.name,
      senderAvatar: widget.doctor.imageUrl,
    );

    setState(() {
      _consultation.messages.add(welcomeMessage);
    });
  }

  Future<void> _saveConsultation() async {
    if (!_isSaving) {
      _isSaving = true;
      await _doctorService.saveConsultation(_consultation);
    }
  }

  void _handleSendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isLoading) return;

    // Add user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: text,
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    setState(() {
      _consultation.messages.add(userMessage);
      _isLoading = true;
    });
    _textController.clear();
    _scrollToBottom();

    // Save after user message
    await _saveConsultation();

    // Simulate doctor typing and response (in real app, this would be real-time)
    await Future.delayed(const Duration(seconds: 2));

    final doctorResponse = _generateDoctorResponse(text);
    final doctorMessage = ChatMessage(
      id: _uuid.v4(),
      content: doctorResponse,
      type: MessageType.doctor,
      timestamp: DateTime.now(),
      senderName: widget.doctor.name,
      senderAvatar: widget.doctor.imageUrl,
    );

    setState(() {
      _consultation.messages.add(doctorMessage);
      _isLoading = false;
    });
    _scrollToBottom();

    // Save after doctor response
    await _saveConsultation();
  }

  String _generateDoctorResponse(String userMessage) {
    // Ini adalah simulasi respons dokter
    // Dalam aplikasi nyata, ini akan menjadi pesan real-time dari dokter
    
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('cemas') || lowerMessage.contains('anxiety')) {
      return '''Saya mendengar Anda sedang mengalami kecemasan. Ini adalah respons alami tubuh terhadap stress, dan Anda tidak sendirian dalam hal ini.

Bisakah Anda ceritakan lebih detail:
- Kapan kecemasan ini biasanya muncul?
- Apakah ada pemicu tertentu yang Anda sadari?
- Bagaimana dampaknya terhadap aktivitas sehari-hari Anda?

Informasi ini akan membantu saya memahami situasi Anda lebih baik dan memberikan bantuan yang tepat.''';
    }
    
    if (lowerMessage.contains('tidur') || lowerMessage.contains('insomnia')) {
      return '''Masalah tidur dapat sangat mempengaruhi kualitas hidup. Terima kasih sudah menceritakan ini.

Beberapa hal yang ingin saya tanyakan:
- Berapa lama Anda mengalami kesulitan tidur?
- Apakah ada rutinitas sebelum tidur yang Anda lakukan?
- Bagaimana pola makan dan aktivitas fisik Anda?

Kita akan cari solusi yang sesuai untuk Anda.''';
    }
    
    if (lowerMessage.contains('depresi') || lowerMessage.contains('sedih')) {
      return '''Terima kasih sudah berani membagikan perasaan Anda. Mengakui perasaan ini adalah langkah penting.

Untuk membantu Anda lebih baik, saya ingin tahu:
- Sudah berapa lama Anda merasakan ini?
- Apakah ada perubahan besar dalam hidup Anda belakangan ini?
- Apakah Anda masih bisa menikmati hal-hal yang biasanya Anda sukai?

Saya di sini untuk mendengarkan dan membantu Anda melewati ini.''';
    }
    
    // Default response
    return '''Terima kasih sudah berbagi dengan saya. Saya memahami situasi yang Anda alami.

Untuk memberikan bantuan yang terbaik, bisakah Anda ceritakan lebih detail tentang:
- Apa yang paling mengganggu Anda saat ini?
- Sudah berapa lama Anda mengalami ini?
- Bagaimana dampaknya terhadap kehidupan sehari-hari Anda?

Informasi ini sangat membantu untuk menentukan pendekatan yang tepat.''';
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _endConsultation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Akhiri Konsultasi?'),
        content: const Text(
          'Apakah Anda yakin ingin mengakhiri sesi konsultasi ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B9080),
            ),
            child: const Text('Ya, Akhiri'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Update consultation status
      _consultation = Consultation(
        id: _consultation.id,
        type: _consultation.type,
        status: ConsultationStatus.completed,
        startTime: _consultation.startTime,
        endTime: DateTime.now(),
        messages: _consultation.messages,
        doctor: _consultation.doctor,
        topic: _consultation.topic,
      );

      await _saveConsultation();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Konsultasi telah berakhir'),
            backgroundColor: Color(0xFF6B9080),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFD0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B9080),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.doctor.imageUrl),
              backgroundColor: Colors.white,
              onBackgroundImageError: (_, __) {},
              child: widget.doctor.imageUrl.isEmpty
                  ? const Icon(Icons.person, size: 20)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doctor.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.doctor.specialization,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'end') {
                _endConsultation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'end',
                child: Row(
                  children: [
                    Icon(Icons.stop_circle_outlined, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Akhiri Konsultasi'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Info Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFE8F5E9),
            child: Row(
              children: [
                const Icon(Icons.lock, size: 16, color: Color(0xFF2E7D32)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sesi ini terenkripsi end-to-end',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _consultation.messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _consultation.messages.length && _isLoading) {
                  return const TypingIndicator(isDoctor: true);
                }
                
                return ChatBubble(
                  message: _consultation.messages[index],
                  showAvatar: true,
                  showTimestamp: true,
                );
              },
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: _isLoading 
                            ? 'Dokter sedang mengetik...' 
                            : 'Ketik pesan Anda...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          hintStyle: const TextStyle(color: Colors.black45),
                        ),
                        onSubmitted: _isLoading ? null : (_) => _handleSendMessage(),
                        enabled: !_isLoading,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: _isLoading ? Colors.grey : const Color(0xFF6B9080),
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      onTap: _isLoading ? null : _handleSendMessage,
                      borderRadius: BorderRadius.circular(24),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}