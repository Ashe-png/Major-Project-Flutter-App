import 'dart:async';

import 'package:flutter/material.dart';
import 'package:major/constants/routes.dart';
import 'package:major/services/upload_audio.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'dart:developer' as devtools show log;

class ResponseView extends StatefulWidget {
  const ResponseView({super.key});

  @override
  State<ResponseView> createState() => _ResponseViewState();
}

class _ResponseViewState extends State<ResponseView> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
        initialVideoId: '',
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          isLive: false,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recordingPath = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder<Map<String, dynamic>>(
        future: UploadAudio.uploadAudio(recordingPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Searching();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final responseData = snapshot.data!;
            String artists =
                responseData['artists'].whereType<String>().join(', ');
            String genres;
            if (responseData['genres'] is List<dynamic>) {
              genres = responseData['genres'].whereType<String>().join(', ');
            } else {
              genres = responseData['genres'];
            }
            final Map<String, dynamic> trackInfo = {
              'Track': responseData['name'],
              'Artists': artists,
              'Album': responseData['album_name'],
              'Genres': genres,
            };
            // devtools.log(artists);
            // devtools.log(genres);
            // devtools.log(trackInfo['Artists']);
            // _controller
            //     .load(YoutubePlayer.convertUrlToId(responseData['url'])!);
            // _controller.pause();
            return Scaffold(
              appBar: AppBar(
                title: const Text('Search Result'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(homeRoute);
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 360,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 58, 79, 80),
                          borderRadius: BorderRadius.circular(
                              12), // Make the corners rounded
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  responseData['image_url'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    responseData['name'].toString(),
                                    style: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    trackInfo['Artists'],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 360,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 58, 79, 80),
                          borderRadius: BorderRadius.circular(
                              12), // Make the corners rounded
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Center(
                                  child: Text(
                                'Youtube Player',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                              const SizedBox(
                                height: 10,
                              ),
                              YoutubePlayer(
                                controller: _controller,
                                onReady: () {
                                  _controller.load(YoutubePlayer.convertUrlToId(
                                      responseData['url'])!);
                                  _controller.pause();
                                },
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: Colors.red,
                                progressColors: const ProgressBarColors(
                                  playedColor: Colors.red,
                                  handleColor: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                          width: 360,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 58, 79, 80),
                            borderRadius: BorderRadius.circular(
                                12), // Make the corners rounded
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Track  Information',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: trackInfo.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final entry =
                                        trackInfo.entries.elementAt(index);
                                    final key = entry.key;
                                    final value = entry.value;
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15.0, right: 8, left: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween, // Aligns the contents of each row to the right and left
                                            children: [
                                              Text(key),
                                              Text(value),
                                              // Other widgets specific to each item
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1.0,
                                        ),
                                      ],
                                    );
                                  },
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('No data'),
            );
          }
        });
  }
}

class Searching extends StatefulWidget {
  const Searching({
    super.key,
  });

  @override
  State<Searching> createState() => _SearchingState();
}

class _SearchingState extends State<Searching> {
  List<String> texts = [
    'Analysing Audio..',
    'Generating Audio Fingerprint...',
    'Searching Database...',
  ];

  int currentIndex = 0;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    Timer(const Duration(seconds: 10), () {
      setState(() {
        currentIndex++;
        if (currentIndex < texts.length) {
          startTimer();
        } else {
          currentIndex = 2;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Searching...'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(homeRoute);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 10,
              ),
              Text(
                texts[currentIndex],
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ));
  }
}
