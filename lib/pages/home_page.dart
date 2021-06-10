import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/music.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Duration position = Duration(seconds: 0);
  bool isPlay = true;
  List<Music> mySong = [];
  int index = 0;
  Duration duree = Duration(seconds: 0);

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    configMyPlayer();

    mySong = [
      Music("artiste 2", "music 2", "assets/images/image-1.jpg",
          "https://noisyliens.fr/wp-content/uploads/2021/06/audiohub__4066141002255_zombie-invasion-2015__testversion.mp3"),
      Music("artiste 3", "music 3", "assets/images/image-2.jpg",
          "https://noisyliens.fr/wp-content/uploads/2021/06/audiohub__4066141002828_all-the-summer-girls_276__testversion.mp3")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("My music application",
                style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.black),
        body: Column(
          children: [
            Center(
              child: Container(child: Image.asset(mySong[index].image)),
            ),
            Text(mySong[index].name, style: GoogleFonts.alexBrush()),
            Text(mySong[index].music, style: GoogleFonts.roboto()),
            Container(
              color: Colors.black54,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        fastRewind();
                      },
                      icon: Icon(Icons.fast_rewind)),
                  (isPlay)
                      ? IconButton(
                          onPressed: () {
                            playerStatut(statutPlayer.lecture);
                            setState(() {
                              isPlay = !isPlay;
                            });
                          },
                          icon: Icon(Icons.play_arrow),
                          iconSize: 35,
                        )
                      : IconButton(
                          onPressed: () {
                            playerStatut(statutPlayer.pause);

                            setState(() {
                              isPlay = !isPlay;
                            });
                          },
                          icon: Icon(Icons.pause),
                          iconSize: 35,
                        ),
                  IconButton(
                      onPressed: () {
                        fastForward();
                      },
                      icon: Icon(Icons.fast_forward))
                ],
              ),
            ),
            Slider(
              inactiveColor: Colors.red,
              activeColor: Colors.black,
              min: 0,
              max: 300,
              onChanged: (double cursor) {
                setState(() {
                  Duration time = Duration(seconds: cursor.toInt());
                  position = time;
                });
              },
              value: position.inSeconds.toDouble(),
            )
          ],
        ));
  }

  //fonctions :

  Future play() async {
    await audioPlayer.play(mySong[index].urlSon);
  }

  Future pause() async {
    await audioPlayer.pause();
  }

  void fastForward() {
    if (index < mySong.length - 1) {
      setState(() {
        index++;
      });
    } else {
      setState(() {
        index = 0;
      });
    }

    audioPlayer.stop();
    configMyPlayer();
    play();

    // Duration moveBack = Duration(seconds: 5);
    // setState(() {
    //   position = moveBack;
    // });

    // await audioPlayer.seek(position);
  }

  void fastRewind() {
    if (position > Duration(seconds: 5)) {
      audioPlayer.seek(Duration(seconds: 0));

    } else {
      if (index == 0) {
        setState(() {
          index = mySong.length - 1; 
        });
      } else {
        setState(() {
          index --;
        });
      }
    }

    audioPlayer.stop();
    play();

    
  }

  void configMyPlayer() {
    StreamSubscription positionSubPlay;
    //StreamSubscription positionSubStop;

    positionSubPlay = audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    // positionSubStop = audioPlayer.onAudioPositionChanged.listen((state) {

    //   if(state == statutPlayer.lecture){

    //       duree = await  audioPlayer.
    //   }

    // });
  }

  void playerStatut(statutPlayer statut) {
    switch (statut) {
      case statutPlayer.lecture:
        play();

        break;

      case statutPlayer.pause:
        pause();
        break;

      case statutPlayer.stop:
        print("stop");
        break;

      default:
    }
  }
}

enum statutPlayer {
  lecture,
  pause,
  stop,
}
