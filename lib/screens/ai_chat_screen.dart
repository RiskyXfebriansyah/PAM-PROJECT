import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message_model.dart';
import '../services/ai_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/typing_indicator.dart';
import 'doctor_list_screen.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({Key? key}) : super(key: key);

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIService _aiService = AIService();
  final List<ChatMessage> _messages = [];
  final Uuid _uuid = const Uuid();
  
  bool _isLoading = false;
  bool _showEmergencyBanner = false;

  @override
  void initState() {
    super.initState();
    _addInitialMessage();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addInitialMessage() {
    final initialMessage = ChatMessage(
      id: _uuid.v4(),
      content: 'Halo! Saya Serene AI Assistant.\n\n'
          'Saya di sini untuk mendengarkan dan membantu Anda. '
          'Ceritakan apa yang sedang Anda rasakan atau alami saat ini.\n\n'
          'Semua yang Anda ceritakan akan dijaga kerahasiaannya.',
      type: MessageType.ai,
      timestamp: DateTime.now(),
      senderName: 'AI Assistant',
    );
    
    setState(() {
      _messages.add(initialMessage);
    });
  }

  void _handleSendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isLoading) return;

    // Check for emergency keywords
    if (_aiService.isEmergency(text)) {
      setState(() {
        _showEmergencyBanner = true;
      });
      _scrollToBottom();
    }

    // Add user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: text,
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    _textController.clear();
    _scrollToBottom();

    // Get AI response
    try {
      String response;
      
      if (_aiService.isEmergency(text)) {
        response = _aiService.getEmergencyResponse();
      } else {
        response = await _aiService.sendMessage(text);
      }

      final aiMessage = ChatMessage(
        id: _uuid.v4(),
        content: response,
        type: MessageType.ai,
        timestamp: DateTime.now(),
        senderName: 'AI Assistant',
      );

      setState(() {
        _messages.add(aiMessage);
        _isLoading = false;
      });
      _scrollToBottom();

    } catch (e) {
      final errorMessage = ChatMessage(
        id: _uuid.v4(),
        content: 'Maaf, terjadi kesalahan. Silakan coba lagi atau hubungi dokter kami.',
        type: MessageType.ai,
        timestamp: DateTime.now(),
        senderName: 'AI Assistant',
      );

      setState(() {
        _messages.add(errorMessage);
        _isLoading = false;
      });
      _scrollToBottom();
    }
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

  void _startNewChat() {
    setState(() {
      _messages.clear();
      _isLoading = false;
      _showEmergencyBanner = false;
    });
    _aiService.resetChat();
    _addInitialMessage();
  }

  void _goToDoctorList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DoctorListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFD0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EFD0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFF6B9080),
              radius: 18,
              child: Icon(Icons.psychology, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Online 24/7',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: _startNewChat,
            tooltip: 'Chat Baru',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black54),
            onSelected: (value) {
              if (value == 'doctor') {
                _goToDoctorList();
              } else if (value == 'new') {
                _startNewChat();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'doctor',
                child: Row(
                  children: [
                    Icon(Icons.local_hospital, size: 20),
                    SizedBox(width: 12),
                    Text('Konsultasi Dokter'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'new',
                child: Row(
                  children: [
                    Icon(Icons.add_comment, size: 20),
                    SizedBox(width: 12),
                    Text('Chat Baru'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Emergency Banner
          if (_showEmergencyBanner)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFFFEBEE),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Color(0xFFC62828)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Situasi Darurat Terdeteksi',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC62828),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Segera hubungi hotline: 119 ext 8',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _goToDoctorList,
                    child: const Text(
                      'Dokter',
                      style: TextStyle(
                        color: Color(0xFFC62828),
                        fontWeight: FontWeight.bold,
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
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return const TypingIndicator();
                }
                
                return ChatBubble(
                  message: _messages[index],
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
                            ? 'AI sedang mengetik...' 
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