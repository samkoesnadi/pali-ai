import 'dart:async';
import 'dart:isolate';

import 'package:background_downloader/background_downloader.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pali/common_definitions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import '/pages/home.dart';

import 'package:path_provider/path_provider.dart';

/// Attempt to get permissions if not already granted
Future<void> getPermission(PermissionType permissionType) async {
  var status = await FileDownloader().permissions.status(permissionType);
  if (status != PermissionStatus.granted) {
    if (await FileDownloader()
        .permissions
        .shouldShowRationale(permissionType)) {
      debugPrint('Showing some rationale');
    }
    status = await FileDownloader().permissions.request(permissionType);
    debugPrint('Permission for $permissionType was $status');
  }
}

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);

    await getPermission(PermissionType.notifications);

    APP_DOC_DIR = await getApplicationDocumentsDirectory();

    AI_MODEL_ISOLATE_PARENT.init();
    EXISTING_ISOLATE_SUB = AI_MODEL_ISOLATE_PARENT.stream.listen((data) {
      if (!AI_MODEL_INITIATED) {
        if (data.command == "finished_spawning_AI") {
          AI_MODEL_INITIATED = true;
        }
      } else {
        debugPrint(data.message);
      }
    });

    runApp(const MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PALI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xffEE5366),
        colorScheme:
            ColorScheme.fromSwatch(accentColor: const Color(0xffEE5366)),
      ),
      // home: const MyHomePage(),
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => MyHomePage()),
      ],
    );
  }
}
