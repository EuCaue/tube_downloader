import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tube_downloader/models/youtube_video_item.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchField extends StatefulWidget {
  final Function(YoutubeVideoItem) onVideoFound;

  const SearchField({super.key, required this.onVideoFound});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _textController = TextEditingController();
  bool isLoading = false;
  bool error = false;

  late YoutubeVideoItem youtubeVideo;

  void _handleSubmit(String ytVideoUrl) async {
    setState(() {
      isLoading = true;
    });
    _textController.clear();
    final yt = YoutubeExplode();
    try {
      final Video youtubeVideoData = await yt.videos.get(ytVideoUrl);

      final YoutubeVideoItem youtubeVideoItem = YoutubeVideoItem(
        title: youtubeVideoData.title,
        author: youtubeVideoData.author,
        url: youtubeVideoData.url,
        id: youtubeVideoData.id,
        duration: youtubeVideoData.duration,
        thumbnailUrl: youtubeVideoData.thumbnails.highResUrl,
      );
      widget.onVideoFound(youtubeVideoItem);
    } catch (e) {
      setState(() {
        error = true;
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          error = false;
        });
      });

      Logger(printer: PrettyPrinter()).e(e);
    } finally {
      setState(() {
        isLoading = false;
      });
      yt.close();
    }
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      width: 700,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black87.withOpacity(0.05),
            blurRadius: 0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: TextField(
        onSubmitted: _handleSubmit,
        controller: _textController,
        decoration: InputDecoration(
          hintText: 'Youtube URL Video',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          contentPadding: const EdgeInsets.all(20),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.search, size: 32),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _searchField(),
        if (isLoading)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Loading video...",
                    style: TextStyle(fontSize: 32),
                  ),
                  SizedBox(width: 20),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        if (error)
          const Center(
            child: Text(
              "Couldn't find any video with this URL!",
              style: TextStyle(fontSize: 32, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
