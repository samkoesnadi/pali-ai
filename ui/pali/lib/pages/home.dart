import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pali/common_definitions.dart';
import 'package:pali/utils/common.dart';
import 'package:path/path.dart';
import 'package:storage_utility/storage_utility.dart';
import '/pages/download_model.dart';
import 'chat.dart';
import 'load_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Widget body;

    if (checkSufficientMemory()) {
      if (File(get_visual_projector_model_path()).existsSync() && File(get_llm_model_path()).existsSync()) {
        if (!AI_MODEL_INITIATED) {
          body = LoadModelPage();
        } else {
          body = ChatPage();
        }
      } else {
        body = DownloadModelPage();
      }
    } else {
      body = Center(
        child: Text("You need minimum 2GB of free RAM"),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Blurry Wallpaper Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/wallpaper.jpg'),
                // Replace with your asset image path
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              // Adjust blur intensity
              child: Container(
                color: Colors.white.withValues(
                    alpha: 0.1), // Optional: Add a semi-transparent overlay
              ),
            ),
          ),
          // Main Content
          Center(
            child: body,
          ),
        ],
      ),
    );
  }
}
