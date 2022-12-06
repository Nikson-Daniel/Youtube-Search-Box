import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_searchbox/search.dart';
import 'package:youtube_searchbox/searchClass.dart';
import 'package:http/http.dart' as http;



Future<void> main() async {
  runApp(YoutubeApp());
}

List<String> titleList = [

];

List<String> playlist = [

];

///
class YoutubeApp extends StatelessWidget {
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
      home: YoutubeAppDemo(),
    );
  }
}

///
class YoutubeAppDemo extends StatefulWidget {
  

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

    playlist = [
            'SxmhhtiaJlY',
            '7x3-0nQ5IQo',
            '7sa6YEoWsec',
            '4BK8VO3Txcc',
            'k589d-bIpGE',
            'MJ4bfSdUT2g',
            't2hZ93ZrbLM',
            '1lRfwHi9l8c',
            '04vi9iLF9sw',
            'zryJNQIGoOc',
    ];

    setTitleList();
 
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    )
      ..onInit = () {
        
        _controller.loadPlaylist(
          list: playlist,
          listType: ListType.playlist,
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
                  IconButton(
            icon: Icon(
              Icons.search,
            ),
            iconSize: 30,
            color: Colors.white,
            splashColor: Colors.purple,
            onPressed: () async{
              
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchClass()),
            );
  //            print(titleList[0]);
  // print(titleList[1]);
  // print(titleList[2]);
  // print(titleList[3]);
  // print(titleList[4]);
  // print(titleList[5]);
  // print(titleList[6]);
  // print(titleList[7]);
  // print(titleList[8]);
  // print(titleList[9]);
            
                              
            },
          ),
                                 
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

  setTitleList() async{

  for(int i = 0; i < playlist.length;i++){

    var jsonData = await getDetail(playlist[i]);
    String title = jsonData['title'];
    titleList.add(title.toString());
    temporaryTitlr.add(title.toString());
    
  }
 
  
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



Future<dynamic> getDetail(String userUrl) async {
    String embedUrl = "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=$userUrl&format=json";

    var res = await http.get(Uri.parse(embedUrl));
    print("get youtube detail status code: " + res.statusCode.toString());

    try {
      if (res.statusCode == 200) {
        return json.decode(res.body);

      } else {
        return null;
      }
    } on FormatException catch (e) {
      print('invalid JSON'+ e.toString());
      
      return null;
    }
  }


