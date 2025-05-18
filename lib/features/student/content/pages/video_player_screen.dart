import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String youtubeLink;
  final String title;

  const VideoPlayerScreen({super.key, required this.youtubeLink, required this.title});

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isError = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeLink);
    if (videoId == null) {
      setState(() {
        _isError = true;
      });
      return;
    }
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false, enableCaption: true, forceHD: false),
    )..addListener(() {
      if (_controller.value.isFullScreen != _isFullScreen) {
        setState(() {
          _isFullScreen = _controller.value.isFullScreen;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
        );
      },
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
        );
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: colorScheme.primary,
        progressColors: ProgressBarColors(playedColor: colorScheme.primary, handleColor: colorScheme.primaryContainer),
        onReady: () {
          _controller.play();
        },
        onEnded: (_) {
          _controller.pause();
        },
      ),
      builder:
          (context, player) => Scaffold(
            // Rest of the Scaffold remains unchanged
            appBar:
                _isFullScreen
                    ? null
                    : AppBar(
                      elevation: 0,
                      backgroundColor: colorScheme.surfaceContainer,
                      title: Text(widget.title, overflow: TextOverflow.ellipsis),
                    ),
            body:
                _isError
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 10.w, color: colorScheme.error),
                          SizedBox(height: 2.h),
                          Text(
                            'Failed to load video',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          ElevatedButton(onPressed: () => context.pop(), child: const Text('Go Back')),
                        ],
                      ),
                    )
                    : player,
          ),
    );
  }
}
