import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:typed_isolate/typed_isolate.dart';

const LLAMA_MODEL_URL =
    "https://paliassets.trobot.us/assets/SmarterQwen040225.zip";
const LOCAL_MODEL_ZIP_FILENAME = "hfjdklsahfjdkahffdsa";

class LLMResponse {
  String token;
  bool end;

  LLMResponse(this.token, this.end);
}

class LLMComand {
  String command;
  String message;

  LLMComand({required this.command, this.message = ""});
}

late Directory APP_DOC_DIR;
final AI_MODEL_ISOLATE_PARENT = IsolateParent<LLMComand, LLMComand>();
bool AI_MODEL_INITIATED = false;
StreamSubscription? EXISTING_ISOLATE_SUB;

var LLM_MODEL_PATH = "Qwen2-VL-2B-Instruct-Q4_K_M.gguf";
var VISUAL_PROJECTOR_MODEL_PATH = "mmproj-Qwen2-VL-2B-Instruct-q4_1.gguf";

var SYSTEM_PROMPT = "You are a helpful assistant.";
var CTX_SIZE = 1024;
var TEMP = 0.1;
var TOP_K = 40;
var TOP_P = 0.9;
var N_PREDICT = 256;
var GPU_LAYERS = 0;
var REPEAT_LAST_N = 64;
var REPEAT_PENALTY = 1.1;
var PRESENCE_PENALTY = 0.0;
var FREQUENCY_PENALTY = 0.0;

const STATUS_MESSAGES = {
  "running": "Downloading the AI model",
  "paused": "Paused the AI model download",
  "error": "AI model download failed",
  "complete": "Successfully downloaded the AI model",
  "canceled": "The AI model download is canceled",
};

String get_llm_model_path() {
  return join(APP_DOC_DIR.path, LLM_MODEL_PATH);
}

String get_visual_projector_model_path() {
  return join(APP_DOC_DIR.path, VISUAL_PROJECTOR_MODEL_PATH);
}
