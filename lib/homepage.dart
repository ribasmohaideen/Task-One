import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'notification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool stop = true;
  String fileUrl =
      "https://file-examples.com/storage/fee868065066261f19c04c3/2017/04/file_example_MP4_1920_18MG.mp4";
  bool downloading = false;
  double progress = 0;
  bool showMessage = false;
  final ValueNotifier<String> downloadMessage = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    downloadMessage.addListener(() {
      LocalNotificationService.displayNormalMessage(
          "Sample Mp4 Download", downloadMessage.value);
    });
  }

  Future<void> startDownload() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    setState(() {
      downloading = true;
      progress = 0;
      stop = false;
      downloadMessage.value = 'Downloading file...'.toString();
      showMessage = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showMessage = false;
      });
    });
    try {
      Dio dio = Dio();
      await dio.download(
        fileUrl,
        "${directory!.path}/sample.mp4",
        onReceiveProgress: (received, total) {
          setState(() {
            progress = received / total;
          });
        },
      );

      setState(() {
        downloadMessage.value = 'File downloaded successfully!';
        stop = true;
        progress = 0;
        showMessage = true;
      });
      Future.delayed(const Duration(seconds: 10), () {
        setState(() {
          showMessage = false;
          downloadMessage.value = '';
        });
      });
    } catch (e) {
      setState(() {
        downloadMessage.value = 'Error: $e';
      });
    } finally {
      setState(() {
        downloading = false;
        stop = true;
        progress = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: stop
                    ? () {
                        startDownload();
                      }
                    : () {},
                child: Text(stop ? "Start" : "Cancel")),
            const SizedBox(height: 20),
            Text('Download: ${(progress * 100).toStringAsFixed(2)}%'),
            Text(showMessage ? downloadMessage.value : ''),
          ],
        ),
      ),
    );
  }
}
