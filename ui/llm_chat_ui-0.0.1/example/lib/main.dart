import 'package:flutter/material.dart';
import 'package:llm_chat_ui/llm_chat_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LLM Chat UI',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const ChatExampleScreen(),
    );
  }
}

class ChatExampleScreen extends StatefulWidget {
  const ChatExampleScreen({super.key});

  @override
  State<ChatExampleScreen> createState() => _ChatExampleScreenState();
}

class _ChatExampleScreenState extends State<ChatExampleScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Welcome to the chat!',
      messageType: MessageType.system,
    ),
    ChatMessage(
      text: 'Hello! How can I help you today?',
      messageType: MessageType.assistant,
    ),
  ];

  bool _showSystemMessages = true;

  void _handleSendMessage(String text) {
    setState(() {
      _messages.insert(
          0, ChatMessage(text: text, messageType: MessageType.user));
      _messages.insert(
          0,
          ChatMessage(
              text: 'Let me check that for you.',
              messageType: MessageType.assistant));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LLM Chat UI'),
        actions: [
          IconButton(
            icon: Icon(
              _showSystemMessages ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _showSystemMessages = !_showSystemMessages;
              });
            },
          ),
        ],
      ),
      body: ChatScreen(
        messages: _messages,
        onSendMessage: _handleSendMessage,
        showSystemMessages: _showSystemMessages,
      ),
    );
  }
}
