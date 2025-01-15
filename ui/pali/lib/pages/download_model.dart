import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/utils/common.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';
import 'package:background_downloader/background_downloader.dart';

import '/common_definitions.dart';

class DownloadModelPage extends StatefulWidget {
  const DownloadModelPage({super.key});

  @override
  _DownloadModelPageState createState() => _DownloadModelPageState();
}

class _DownloadModelPageState extends State<DownloadModelPage> {
  final _progressValue = 0.0.obs;
  final _statusText = "".obs;

  bool downloadWithError = false;
  Rx<TaskStatus> downloadTaskStatus = TaskStatus.notFound.obs;
  Task? backgroundDownloadTask;
  StreamSubscription? fileDownloaderSub;

  void myNotificationTapCallback(Task task, NotificationType notificationType) {
    debugPrint(
        'Tapped notification $notificationType for taskId ${task.taskId}');
  }

  Future<void> downloadModel() async {
    await FileDownloader().configure(globalConfig: [
      (Config.requestTimeout, const Duration(hours: 24)),
    ], androidConfig: [
      (Config.useCacheDir, Config.whenAble),
      (Config.runInForeground, true)
    ], iOSConfig: [
      (Config.localize, {'Cancel': 'StopIt'}),
    ]).then((result) => debugPrint('Configuration result = $result'));

    // Registering a callback and configure notifications
    FileDownloader()
        .registerCallbacks(
            taskNotificationTapCallback: myNotificationTapCallback)
        .configureNotificationForGroup("ModelDownload",
            running: TaskNotification(STATUS_MESSAGES["running"] ?? "",
                '{progress} : {networkSpeed} and {timeRemaining} remaining'),
            complete: TaskNotification(STATUS_MESSAGES["complete"] ?? "", ''),
            error: TaskNotification(STATUS_MESSAGES["error"] ?? "", ''),
            paused: TaskNotification(STATUS_MESSAGES["paused"] ?? "", ''),
            progressBar: true,
            tapOpensFile: false);

    fileDownloaderSub = FileDownloader().updates.listen((update) {
      switch (update) {
        case TaskStatusUpdate():
          if (update.task.group == "ModelDownload") {
            switch(update.status) {
              case TaskStatus.canceled:
                _statusText.value = STATUS_MESSAGES["canceled"] ?? "";

                Get.offAllNamed("/");
              case TaskStatus.failed:
                _statusText.value = "Download failed.\n${update.exception!.description}";
                break;
              case TaskStatus.complete:
              // Run archive extraction
                _statusText.value = 'Installing the AI model on device...';

                String zip_path = join(APP_DOC_DIR.path, LOCAL_MODEL_ZIP_FILENAME);
                final inputStream = InputFileStream(zip_path);
                final archive = ZipDecoder().decodeStream(inputStream);
                extractArchiveToDiskSync(archive, APP_DOC_DIR.path);

                // delete the zip
                File(zip_path).deleteSync();

                Get.offAllNamed("/");
                break;
              default:
            }
          }
        case TaskProgressUpdate():
          if (update.task.group == "ModelDownload") {
            _statusText.value =
              "${STATUS_MESSAGES["running"] ?? ""}\n${(update.progress * 100).toStringAsFixed(1)}% : ${update.networkSpeed.toStringAsFixed(1)}MB/s and ${formatDuration(update.timeRemaining)} remaining";
            _progressValue.value = update.progress;
          }
      }
    });

    await FileDownloader().start(doRescheduleKilledTasks: false);

    for (final task in await FileDownloader().allTasks(
        group: "ModelDownload")) {
      backgroundDownloadTask = task;
    }

    if (backgroundDownloadTask == null) {
      backgroundDownloadTask = DownloadTask(
          url: LLAMA_MODEL_URL,
          filename: LOCAL_MODEL_ZIP_FILENAME,
          updates: Updates.statusAndProgress,
          requiresWiFi: false,
          retries: 3,
          allowPause: true,
          baseDirectory: BaseDirectory.applicationDocuments,
          displayName: "AI Model Download",
          metaData: "ModelDownload",
          group: "ModelDownload");

      await FileDownloader().enqueue(backgroundDownloadTask!);
    }
  }

  @override
  void initState() {
    super.initState();
    downloadModel();
  }

  @override
  void dispose() {
    fileDownloaderSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // TODO
    // final int freeBytes = getFreeBytes();

    return Container(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LinearProgressIndicator(
                  value: _progressValue.value,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                SizedBox(height: 20),
                Text(
                  _statusText.value == "" ? "Loading..." : _statusText.value,
                  textAlign: TextAlign.center,
                )
              ],
            )));
  }
}
