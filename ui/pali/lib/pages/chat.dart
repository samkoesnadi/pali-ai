import 'dart:async';
import 'package:flutter/material.dart';
import 'package:llm_chat_ui/llm_chat_ui.dart';
import 'package:mutex/mutex.dart';
import 'package:pali/common_definitions.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  StreamSubscription? streamSubscription;
  String full_response = "";
  bool processing = false;
  final List<ChatMessage> _messages = [];

  final m = Mutex();

  @override
  void initState() {
    super.initState();
  }

  void _handleSendMessage(String text, String? imageBase64) async {
    processing = false;
    await m.acquire();
    processing = true;
    streamSubscription?.cancel();
    full_response = "";

    var text_to_ai = text;
    if (imageBase64 != null) {
      text_to_ai = ("<img src=\"data:image/jpeg;base64," +
          imageBase64! +
          "\">" +
          text_to_ai);
    }

    setState(() {
      _messages.add(ChatMessage(
          id: uuid.v4(),
          text: text,
          image: imageBase64,
          messageType: MessageType.user));
      _messages.add(ChatMessage(
          id: uuid.v4(),
          text: '*Thinking*',
          messageType: MessageType.assistant));
    });

    EXISTING_ISOLATE_SUB?.cancel();
    // streamSubscription = AI_MODEL_ISOLATE_PARENT.stream.listen((data) {
    //   switch (data.command) {
    //     case "token_end":
    //       print("hooray");
    //       processing = false;
    //       break;
    //     case "token":
    //       full_response += data.message;
    //       setState(() {
    //         _messages[_messages.length - 1] = ChatMessage(
    //             id: uuid.v4(),
    //             text: full_response,
    //             messageType: MessageType.assistant);
    //       });
    //       break;
    //   }
    // });
    // EXISTING_ISOLATE_SUB = streamSubscription;

    AI_MODEL_ISOLATE_PARENT.sendToChild(
        data: LLMComand(command: "chat_init", message: text_to_ai), id: "qwen2vl");
    (await AI_MODEL_ISOLATE_PARENT.stream.first).command;
    for (var i = 0; i < N_PREDICT; i++) {
      if (!processing) break;
      AI_MODEL_ISOLATE_PARENT.sendToChild(
          data: LLMComand(command: "get_response", message: ""), id: "qwen2vl");
      final data = await AI_MODEL_ISOLATE_PARENT.stream.first;

      switch (data.command) {
        case "token_end":
          processing = false;
          break;
        case "token":
          full_response += data.message;
          setState(() {
            _messages[_messages.length - 1] = ChatMessage(
                id: uuid.v4(),
                text: full_response,
                messageType: MessageType.assistant);
          });
          break;
      }
    }

    AI_MODEL_ISOLATE_PARENT.sendToChild(
        data: LLMComand(command: "chat_final", message: ""), id: "qwen2vl");
    (await AI_MODEL_ISOLATE_PARENT.stream.first).command;
    processing = false;
    m.release();
  }

  @override
  void dispose() {
    // TODO!!!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('PALI'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
            ),
            onPressed: () async {
              processing = false;
              await m.acquire();
              _messages.clear();
              full_response = "";
              AI_MODEL_ISOLATE_PARENT.sendToChild(
                  data: LLMComand(command: "chat_reset", message: ""), id: "qwen2vl");
              (await AI_MODEL_ISOLATE_PARENT.stream.first).command;
              m.release();
              setState(() {

              });
            },
          ),
        ],
      ),
      body: ChatScreen(
        messages: _messages,
        onSendMessage: _handleSendMessage,
        showSystemMessages: false,
      ),
    );
  }
}
