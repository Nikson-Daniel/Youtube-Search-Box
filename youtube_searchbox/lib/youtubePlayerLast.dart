import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_searchbox/search.dart';
import 'package:youtube_searchbox/searchClass.dart';
import 'package:http/http.dart' as http;



Future<void> main() async {
  runApp(YoutubeAppDemo(videoId: "dshb",));
}

String vid = "nothing here";

List<String> titleList = [

];

List<String> playlist = [

];

///
class YoutubeAppLast extends StatelessWidget {
   final String accuratePlay;

  const YoutubeAppLast({
    Key? key,
    required this.accuratePlay

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Player IFrame Demo',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: YoutubeAppDemo(videoId: accuratePlay,),
    );
    vid = accuratePlay;
  }
}

///
class YoutubeAppDemo extends StatefulWidget {
  final String videoId;

  const YoutubeAppDemo({
    Key? key,
    required this.videoId

  }) : super(key: key);

  

  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
  
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  late YoutubePlayerController _controller;
  final controller = TextEditingController();
  List<dynamic> searches = allSearch;
  
  

  @override
  void initState() {
    super.initState();
    

  

   
 
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    )
      ..onInit = () {
        
        
        _controller.loadVideoById(
          videoId: videoUniqueId,
          startSeconds: 1,
        );
      }
      ..onFullscreenChange = (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      };
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          appBar: 
            
            AppBar(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Column(
                children: [
                  
                                 
          ],
              ),
            ),
           actions: const [VideoPlaylistIconButton()],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (kIsWeb && constraints.maxWidth > 750) {
                  return Column(
                    children: [
                      
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [    
                                                                  
                                player,
                                const VideoPositionIndicator(),
                              ],
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: Controls(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                return ListView(
                  children: [
                    player,
                    const VideoPositionIndicator(),
                    const Controls(),
                  ],
                );
              },
            ),
          ),
        );

        
      },
    );
  }

 



  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

///
class Controls extends StatelessWidget {
  ///
  const Controls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
        ],
        
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}

///
class VideoPlaylistIconButton extends StatelessWidget {
  ///
  const VideoPlaylistIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;

    return IconButton(
      onPressed: () async {
        controller.pauseVideo();
        
        
        controller.playVideo();
      },
      icon: const Icon(Icons.playlist_play_sharp),
    );
  }
}

///
class VideoPositionIndicator extends StatelessWidget {
  ///
  const VideoPositionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;

    return StreamBuilder<Duration>(
      stream: controller.getCurrentPositionStream(),
      initialData: Duration.zero,
      builder: (context, snapshot) {
        final position = snapshot.data?.inMilliseconds ?? 0;
        final duration = controller.metadata.duration.inMilliseconds;

        return LinearProgressIndicator(
          value: duration == 0 ? 0 : position / duration,
          minHeight: 1,
        );
      },
    );
  }
}

///
class VideoPositionSeeker extends StatelessWidget {
  ///
  const VideoPositionSeeker({super.key});

  @override
  Widget build(BuildContext context) {
    var value = 0.0;

    return Row(
      children: [
        Container(height: 100, width: 100,),
        const Text(
          'Seek',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: StreamBuilder<Duration>(
            stream: context.ytController.getCurrentPositionStream(),
            initialData: Duration.zero,
            builder: (context, snapshot) {
              final position = snapshot.data?.inSeconds ?? 0;
              final duration = context.ytController.metadata.duration.inSeconds;

              value = position == 0 || duration == 0 ? 0 : position / duration;

              return StatefulBuilder(
                builder: (context, setState) {
                  return Slider(
                    value: value,
                    onChanged: (positionFraction) {
                      value = positionFraction;
                      setState(() {});

                      context.ytController.seekTo(
                        seconds: (value * duration).toDouble(),
                        allowSeekAhead: true,
                      );
                    },
                    min: 0,
                    max: 1,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
  
  
  
}






