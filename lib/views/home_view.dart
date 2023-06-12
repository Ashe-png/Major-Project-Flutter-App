import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final recorder = FlutterSoundRecorder();
  final List<Color> colors = [
    const Color.fromARGB(255, 243, 11, 11),
    const Color.fromARGB(255, 13, 228, 28),
    const Color.fromARGB(255, 8, 98, 233),
    const Color.fromARGB(255, 3, 224, 253),
  ];

  final List<int> durations = [900, 700, 600, 800, 500];

  bool isRecorderReady = false;

  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  Future record() async {
    if (!isRecorderReady) return;

    await recorder.startRecorder(
      toFile: '${DateTime.now().millisecondsSinceEpoch}.m4a',
      numChannels: 2,
      bitRate: 128000,
      sampleRate: 44100,
      codec: Codec.aacMP4,
    );
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();

    if (mounted) {
      Navigator.of(context)
          .pushReplacementNamed(responseRoute, arguments: path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (recorder.isRecording)
              SizedBox(
                height: 100,
                width: 200,
                child: MusicVisualizer(
                  barCount: 10,
                  colors: colors,
                  duration: durations,
                ),
              ),
            const SizedBox(height: 20),
            Text(
              recorder.isRecording
                  ? 'Recording...'
                  : 'Tap the button to start recording',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (recorder.isRecording) {
                  await stop();
                } else {
                  await record();
                }
                setState(() {});
              },
              child: Text(
                  recorder.isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            const SizedBox(height: 20),
            StreamBuilder<RecordingDisposition>(
              stream: recorder.onProgress,
              builder: (context, snapshot) {
                final duration =
                    snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                return Text(
                    duration.inSeconds == 0 ? '' : '${duration.inSeconds} s');
              },
            )
          ],
        ),
      ),
    );
  }
}
