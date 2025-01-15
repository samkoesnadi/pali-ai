import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:pali/common_definitions.dart';
import 'package:pali/llama_cpp.dart';
import 'package:pali/utils/common.dart';
import 'package:typed_isolate/typed_isolate.dart';

class AIModel extends IsolateChild<LLMComand, LLMComand> {
  llama_cpp? llava;
  String visual_projector_model_path;
  String llm_model_path;

  AIModel(this.llm_model_path, this.visual_projector_model_path)
      : super(id: "qwen2vl");

  @override
  Future<void> onSpawn() async {
    llava = llama_cpp(DynamicLibrary.open("libllava_shared.so"));

    llava?.Qwen2VL_init(
        stringToPointerChar(llm_model_path),
        stringToPointerChar(visual_projector_model_path),
        stringToPointerChar(SYSTEM_PROMPT),
        CTX_SIZE,
        TEMP,
        TOP_K,
        TOP_P,
        N_PREDICT,
        REPEAT_LAST_N,
        REPEAT_PENALTY,
        PRESENCE_PENALTY,
        FREQUENCY_PENALTY,
        -100);
    sendToParent(LLMComand(command: "finished_spawning_AI"));
  }

  @override
  void onData(LLMComand data) {
    switch (data.command) {
      case "chat_reset":
        llava?.Qwen2VL_chat_reset();
        sendToParent(LLMComand(command: "chat_reset"));
        break;
      case "chat_init":
        llava?.Qwen2VL_chat_init(stringToPointerChar(data.message));
        sendToParent(LLMComand(command: "chat_init"));
        break;
      case "get_response":
        final response = get_response();
        sendToParent(LLMComand(
            command: response.end ? "token_end" : "token",
            message: response.token));
        break;
      case "chat_final":
        llava?.Qwen2VL_chat_final();
        sendToParent(LLMComand(command: "chat_final"));
        break;
    }
  }

  LLMResponse get_response() {
    Pointer<Char> response = calloc(N_PREDICT * sizeOf<Char>());
    bool end = llava?.Qwen2VL_predict_next_token(response) == 1;
    String response_str = pointerCharToString(response);
    malloc.free(response);

    return LLMResponse(response_str, end);
  }
}
