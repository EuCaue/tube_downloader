import 'package:youtube_explode_dart/youtube_explode_dart.dart';

base class YoutubeVideoItem {
  //  TODO: add the youtube video formats 
  final String title;
  final String author;
  final VideoId id;
  final String url;
  final String thumbnailUrl;
  final Duration? duration;

  YoutubeVideoItem({
    required this.title,
    required this.author,
    required this.url,
    required this.id,
    required this.thumbnailUrl,
    required this.duration,
  });
}
