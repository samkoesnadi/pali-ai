import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pali/common_definitions.dart';
import 'package:pali/pages/home.dart';
import 'package:pali/utils/ai_model.dart';
import 'package:typed_isolate/typed_isolate.dart';

class LoadModelPage extends StatefulWidget {
  LoadModelPage({super.key});

  @override
  _LoadModelPageState createState() => _LoadModelPageState();
}

class _LoadModelPageState extends State<LoadModelPage> {
  @override
  void initState() {
    super.initState();

    AI_MODEL_ISOLATE_PARENT.spawn(AIModel(get_llm_model_path(), get_visual_projector_model_path()));
    waitForAIToBeInitiated();
  }

  Future<void> waitForAIToBeInitiated() async {
    Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      if (AI_MODEL_INITIATED) {
        timer.cancel();
        await Get.offAllNamed("/");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Loading AI model")
            ]));
  }
}