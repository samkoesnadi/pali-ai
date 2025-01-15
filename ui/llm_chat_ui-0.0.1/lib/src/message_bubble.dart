import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:llm_chat_ui/llm_chat_ui.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = widget.message.messageType == MessageType.user;
    final isSystem = widget.message.messageType == MessageType.system;

    final colors = _getBubbleColors(theme, isUser, isSystem);
    final alignment = _getAlignment(isUser);
    final hasImage = widget.message.image?.isNotEmpty == true;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Material(
          borderRadius: _getBorderRadius(isUser),
          elevation: 1,
          color: colors.backgroundColor,
          child: InkWell(
            borderRadius: _getBorderRadius(isUser),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasImage) _buildImagePreview(theme),
                  if (hasImage) const SizedBox(height: 8),
                  SelectableText.rich(
                    TextSpan(
                      text: widget.message.text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textColor,
                        height: 1.4,
                      ),
                    ),
                    toolbarOptions: const ToolbarOptions(
                      copy: false,
                      cut: false,
                      paste: false,
                      selectAll: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    return GestureDetector(
      onTap: () => _showImagePreview(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.memory(
            base64Decode(widget.message.image!),
            fit: BoxFit.cover,
            width: 200,
            height: 200,
            errorBuilder: (context, error, stackTrace) => Container(
              color: theme.colorScheme.errorContainer,
              padding: const EdgeInsets.all(8),
              child: Text(
                'Failed to load image',
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.1,
          maxScale: 4.0,
          child: Image.memory(
            base64Decode(widget.message.image!),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Theme.of(context).colorScheme.errorContainer,
              padding: const EdgeInsets.all(8),
              child: Text(
                'Failed to load image',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BubbleColors _getBubbleColors(ThemeData theme, bool isUser, bool isSystem) {
    return BubbleColors(
      backgroundColor: isSystem
          ? theme.colorScheme.surfaceContainerHighest
          : isUser
          ? theme.colorScheme.primary
          : theme.colorScheme.surfaceDim,
      textColor: isSystem
          ? theme.colorScheme.onSurfaceVariant
          : isUser
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.onSurface,
    );
  }

  Alignment _getAlignment(bool isUser) {
    return isUser ? Alignment.centerRight : Alignment.centerLeft;
  }

  BorderRadius _getBorderRadius(bool isUser) {
    return BorderRadius.only(
      topLeft: Radius.circular(isUser ? 12 : 4),
      topRight: Radius.circular(isUser ? 4 : 12),
      bottomLeft: const Radius.circular(12),
      bottomRight: const Radius.circular(12),
    );
  }
}

class BubbleColors {
  final Color backgroundColor;
  final Color textColor;

  BubbleColors({
    required this.backgroundColor,
    required this.textColor,
  });
}