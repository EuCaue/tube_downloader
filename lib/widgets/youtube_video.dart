import 'package:flutter/material.dart';
import 'package:tube_downloader/models/youtube_video_item.dart';

class YoutubeVideo extends StatelessWidget {
  const YoutubeVideo({
    super.key,
    required this.youtubeVideo,
  });

  final YoutubeVideoItem youtubeVideo;

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours > 0 ? '${duration.inHours}:' : ''}$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double breakpoint = 600.0;

        if (constraints.maxWidth < breakpoint) {
          return mobileView(context);
        } else {
          return defaultView(context);
        }
      },
    );
  }

  Row defaultView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: Theme.of(context).colorScheme.onSurface),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  youtubeVideo.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Image.network(
                  youtubeVideo.thumbnailUrl,
                  scale: 0.9,
                  semanticLabel: "Youtube Video Thumbnail",
                ),
                const SizedBox(height: 20),
                Text(
                  "Duration: ${formatDuration(youtubeVideo.duration!)}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // titleAndDuration(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column mobileView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.925,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: Theme.of(context).colorScheme.onSurface),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.network(
                  youtubeVideo.thumbnailUrl,
                  semanticLabel: "Youtube Video Thumbnail",
                ),
                titleAndDurationMobile(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column titleAndDurationMobile(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 20.0, left: 8.0),
          child: Text(
            youtubeVideo.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Text(
            "Duration: ${formatDuration(youtubeVideo.duration!)}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
