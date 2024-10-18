import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Homepage
class YoutubeTutorial extends StatefulWidget {
  const YoutubeTutorial({super.key, required this.ytc});
  final List ytc;
  @override
  _YoutubeTutorialState createState() => _YoutubeTutorialState();
}

class _YoutubeTutorialState extends State<YoutubeTutorial> {
  YoutubePlayerController? _controller =
      YoutubePlayerController(initialVideoId: '');
  final List _controllers = []; // This for your video id's
  static List<YoutubePlayerController>?
      _controllersYoutube; // this is your YouTube Controller data
  var videoData;
  ScrollController scroll = ScrollController();
  PlayerState? _playerState;
  YoutubeMetaData? _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  List yId = [];
  List _ids = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _ids = widget.ytc;
    _controller = YoutubePlayerController(
      initialVideoId: _ids[0]['link'],
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    setState(() {
      isLoading = false;
    });
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    setState(() {
      isLoading = true;
    });
    if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
      setState(() {
        isLoading = false;
        _playerState = _controller!.value.playerState;

        _videoMetaData = _controller!.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _controller!.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return _controller!.initialVideoId == true
        ? SizedBox()
        : YoutubePlayerBuilder(
            onExitFullScreen: () {
              // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
              // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
            },
            player: YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              topActions: <Widget>[
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    _controller!.metadata.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  onPressed: () {
                 
                  },
                ),
              ],
              onReady: () {
                _isPlayerReady = true;
              },
              onEnded: (data) {
                _controller!.load(
                    _ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]
                        ['link']);
              },
            ),
            builder: (context, player) => Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: white),
                backgroundColor: appliteBlue,
                title: Text(
                  'Tutorial',
                  style: TextStyle(
                    fontSize: 18.dp,
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // extendBodyBehindAppBar: true,
              // extendBody: true,
              backgroundColor: appliteBlue,
              body: SingleChildScrollView(
                controller: scroll,
                child: Column(
                  children: [
                    player,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.skip_previous,
                                  color: white2,
                                ),
                                onPressed: _isPlayerReady
                                    ? () => _controller!.load(_ids[
                                        (_ids.indexOf(_controller!
                                                    .metadata.videoId) -
                                                1) %
                                            _ids.length]['link'])
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(
                                  _controller!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: white2,
                                ),
                                onPressed: _isPlayerReady
                                    ? () {
                                        _controller!.value.isPlaying
                                            ? _controller!.pause()
                                            : _controller!.play();
                                        setState(() {});
                                      }
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(
                                  _muted ? Icons.volume_off : Icons.volume_up,
                                  color: white2,
                                ),
                                onPressed: _isPlayerReady
                                    ? () {
                                        _muted
                                            ? _controller!.unMute()
                                            : _controller!.mute();
                                        setState(() {
                                          _muted = !_muted;
                                        });
                                      }
                                    : null,
                              ),
                              FullScreenButton(
                                controller: _controller,
                                color: white2,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.skip_next,
                                  color: white2,
                                ),
                                onPressed: _isPlayerReady
                                    ? () {
                                        _controller!.load(_ids[(_ids.indexOf(
                                                    _controller!
                                                        .metadata.videoId) +
                                                1) %
                                            _ids.length]['link']);
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    isLoading
                        ? shimmer()
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20))),
                            width: w,
                            height: h,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              controller: scroll,
                              padding: EdgeInsets.only(bottom: 150),
                              itemCount: _ids.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () async {
                                      _controller!.load(_ids[index]['link']);

                                      setState(() {});
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: h / 10,
                                                  width: h / 10,
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.network(
                                                              'https://img.youtube.com/vi/${_ids[index]['link']}/0.jpg'),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Card(
                                                          color: Colors.black12,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Icon(
                                                              Icons
                                                                  .play_arrow_rounded,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: w / 1.8,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _ids[index]['title']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    _ids[index]['des']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _controller!.pause();
                                                  });
                                                },
                                                icon: Icon(Icons.close))
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.black26,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget shimmer() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20))),
      height: h,
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) => SizedBox(
          child: Shimmer.fromColors(
              baseColor: Color.fromARGB(255, 229, 228, 228),
              highlightColor: Color.fromARGB(255, 240, 240, 230),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: black,
                              borderRadius: BorderRadius.circular(5)),
                          height: h / 12,
                          width: h / 10,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: black,
                                  borderRadius: BorderRadius.circular(5)),
                              height: 20,
                              width: w / 1.5,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: black,
                                  borderRadius: BorderRadius.circular(5)),
                              height: 10,
                              width: w / 1.8,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: black, borderRadius: BorderRadius.circular(5)),
                      height: 3,
                      width: w,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget myCard() {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Text(
                'Help',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Any Troubleshoot using app',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              const Text(
                ' please check location is on',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ],
      ),
    );
  }
}
