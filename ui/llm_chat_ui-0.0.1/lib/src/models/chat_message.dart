import 'message_type.dart';

class ChatMessage {
  final String id; // Unique identifier for the message
  final String text;
  final String? image; // base64 string
  final MessageType messageType;

  ChatMessage({
    required this.id, // Add id as a required field
    required this.text,
    required this.messageType,
    this.image,
  });
}