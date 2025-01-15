import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:llm_chat_ui/llm_chat_ui.dart';
import 'message_bubble.dart';

typedef SendMessageCallback = void Function(String message, String? imageBase64);


class ChatScreen extends StatefulWidget {
  final List<ChatMessage> messages;
  final SendMessageCallback onSendMessage;
  final String hintText;
  final bool showSystemMessages;
  final double maximum_width_height;

  const ChatScreen({
    super.key,
    required this.messages,
    required this.onSendMessage,
    this.hintText = 'Type a message...',
    this.showSystemMessages = true,
    this.maximum_width_height = 336
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _imageBase64;
  bool _isProcessing = false;
  var messages = {};

  Future<void> _handleImagePick(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: widget.maximum_width_height,
        maxHeight: widget.maximum_width_height,
      );
      if (pickedFile == null) return;

      setState(() => _isProcessing = true);

      final imageFile = File(pickedFile.path);
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return;

      final resizedImage = _resizeImage(image);
      final resizedBytes = img.encodePng(resizedImage);

      setState(() {
        _imageBase64 = base64Encode(resizedBytes);
        _isProcessing = false;
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      print('Error processing image: $e');
    }
  }

  img.Image _resizeImage(img.Image image) {
    final originalWidth = image.width;
    final originalHeight = image.height;
    final maxDimension = originalWidth > originalHeight
        ? originalWidth
        : originalHeight;
    final scale = widget.maximum_width_height / maxDimension;

    return img.copyResize(
      image,
      width: (originalWidth * scale).round(),
      height: (originalHeight * scale).round(),
    );
  }

  void _showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _handleImagePick(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _handleImagePick(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.length < this.messages.length) {
      this.messages.clear();
    }

    final theme = Theme.of(context);
    final visibleMessages = widget.showSystemMessages
        ? widget.messages
        : widget.messages.where((msg) => msg.messageType != MessageType.system)
        .toList();

    if (visibleMessages.length > 0) { // only for user-assistant communication!
      messages[visibleMessages.length - 1] = MessageBubble(
        key: Key(visibleMessages[visibleMessages.length - 1].id),
        // Unique key for each message
        message: visibleMessages[visibleMessages.length - 1],
      );

      if (!messages.containsKey(visibleMessages.length - 2)) {
        messages[visibleMessages.length - 2] = MessageBubble(
          key: Key(visibleMessages[visibleMessages.length - 2].id),
          // Unique key for each message
          message: visibleMessages[visibleMessages.length - 2],
        );
      }
    }

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: visibleMessages.length,
                itemBuilder: (context, index) =>
                messages[visibleMessages.length - 1 - index],
              ),
            ),
            _buildInputSection(theme),
          ],
        ),
        if (_isProcessing)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildInputSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_imageBase64 != null)
            _buildImagePreview(theme),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _buildAttachmentButton(theme),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildSendButton(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          height: 64,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              base64Decode(_imageBase64!),
              fit: BoxFit.cover,
              width: 64,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => setState(() => _imageBase64 = null),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 16,
                color: theme.colorScheme.onError,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentButton(ThemeData theme) {
    return IconButton(
      icon: Icon(Icons.add_photo_alternate, color: theme.colorScheme.primary),
      onPressed: _showImageSourceSelector,
      tooltip: 'Attach Image',
    );
  }

  Widget _buildSendButton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.send, color: theme.colorScheme.onPrimary),
        onPressed: () {
          final text = _controller.text.trim();
          if (text.isNotEmpty) {
            widget.onSendMessage(text, _imageBase64);
            _controller.clear();
            setState(() => _imageBase64 = null);
          }
        },
      ),
    );
  }
}