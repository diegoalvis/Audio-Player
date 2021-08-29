import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playground/ImageAnimatedContainer.dart';

const String waves1 = "assets/waves_sound.png";
const String waves2 = "assets/waves_sound_front.png";

class Player extends StatefulWidget {
  double sizeContainer = 0;

  Player({Key? key}) : super(key: key);


  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool firstValidate = false;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    _audioPlayer = AudioPlayer();

    try {
      await _audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse("https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: _buildPlayAudio()),
      ),
    );
  }

  Widget _buildPlayAudio() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(icon: Icon(Icons.play_arrow), onPressed: () => _audioPlayer.play()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(icon: Icon(Icons.pause), onPressed: () => _audioPlayer.pause()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(icon: Icon(Icons.stop_rounded),
                      onPressed: () {
                        _audioPlayer
                          ..stop()
                          ..seek(Duration.zero);
                      }),
                ),
              ],
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: new LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                            if (MediaQuery.of(context).size.width < 390) {
                              widget.sizeContainer = MediaQuery.of(context).size.width / 2;
                            } else {
                              widget.sizeContainer = MediaQuery.of(context).size.width / 1.65;
                            }

                            return Stack(
                              children: [
                                ImageAnimatedContainer(width: widget.sizeContainer, frontImagePath: waves1),
                                StreamBuilder<Duration>(
                                    stream: _audioPlayer.positionStream,
                                    builder: (context, snapshot) {
                                      final currentPosition = snapshot.data?.inSeconds ?? 0;
                                      final totalDuration = _audioPlayer.duration?.inSeconds ?? 1;
                                      final progresAudio = currentPosition / totalDuration; //es un %
                                      final widthAudio = widget.sizeContainer * (currentPosition / totalDuration);
                                      return Stack(
                                        children: [
                                          Row(
                                            children: [
                                              ImageAnimatedContainer(width: widthAudio, frontImagePath: waves2),
                                            ],
                                          ),
                                          Container(
                                            width: widget.sizeContainer,
                                            child: Slider(
                                                min: 0.0,
                                                max: totalDuration.toDouble(),
                                                value: currentPosition.toDouble(),
                                                onChanged: (pos) {
                                                  _audioPlayer.seek(Duration(seconds: pos.toInt()));
                                                }),
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
