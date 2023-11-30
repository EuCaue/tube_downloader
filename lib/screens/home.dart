import 'dart:io';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tube_downloader/models/youtube_video_item.dart';
import 'package:tube_downloader/widgets/custom_app_bar.dart';
import 'package:tube_downloader/widgets/custom_drawer.dart';
import 'package:tube_downloader/widgets/search_field.dart';
import 'package:tube_downloader/widgets/youtube_video.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Logger logger = Logger(printer: PrettyPrinter());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoadingDownloading = false;
  bool isLoadingSearch = false;
  String _videoFormat = "mp3";
  int downloadVideoPercentage = 0;

  YoutubeVideoItem youtubeVideo = YoutubeVideoItem(
    title: "",
    author: "",
    url: "",
    duration: const Duration(seconds: 0),
    thumbnailUrl: "",
    id: VideoId("https://www.youtube.com/watch?v=r0_NPaX16t0"),
  );

  void downloadVideo() async {
    if (isLoadingDownloading) return;

    Directory? downloadsDir = await getDownloadsDirectory();
    String downloadsPathDir = downloadsDir!.path;
    // NOTE: Android does not support the downloads dir

    if (Platform.isAndroid) {
      downloadsPathDir = "/storage/emulated/0/Download/";
      logger.d(downloadsPathDir);
    }

    final YoutubeExplode yt = YoutubeExplode();

    setState(() {
      isLoadingDownloading = true;
    });
    try {
      final Future<StreamManifest> streamManifest =
          yt.videos.streamsClient.getManifest(youtubeVideo.id);
      final StreamInfo videoStreamInfo = await streamManifest.then((v) {
        return _videoFormat == "mp3" ? v.audioOnly.last : v.muxed.last;
      });

      final Stream<List<int>> videoStream =
          yt.videos.streamsClient.get(videoStreamInfo);
      logger.d(youtubeVideo.title.trim());
      final File file = File(
          "$downloadsPathDir/${youtubeVideo.title.trim().replaceAll("/", " ")}.$_videoFormat");

      final IOSink fileStream = file.openWrite();

      final int videoSize = videoStreamInfo.size.totalBytes;
      int count = 0;
      await for (final data in videoStream) {
        count += data.length;
        final progress = ((count / videoSize) * 100).ceil();
        setState(() {
          downloadVideoPercentage = progress;
        });
        fileStream.add(data);
      }
      await fileStream.close();
      logger.d("Youtube Video Downloaded Successfully");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        width: 275,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        content: Text(
          "${youtubeVideo.title} Downloaded Successfully in $downloadsPathDir !",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ));
    } catch (e) {
      logger.e("Youtube  Error: $e");
    } finally {
      yt.close();
      setState(() {
        isLoadingDownloading = false;
        downloadVideoPercentage = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(scaffoldKey: _scaffoldKey, title: "Youtube Downloader"),
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: Center(
        child: youtubeContainer(context),
      ),
    );
  }

  FilledButton downloadButton() {
    return FilledButton(
      onPressed: downloadVideo,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.all(8),
        fixedSize: const Size(190, 50),
        visualDensity: const VisualDensity(horizontal: 1),
        enabledMouseCursor: SystemMouseCursors.click,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      child: isLoadingDownloading
          ? CircularProgressIndicator(
              color: Colors.white,
              value: double.parse(
                    downloadVideoPercentage.toString(),
                  ) /
                  100,
            )
          : const Text(
              "Download video",
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFFFFFFFF),
              ),
            ),
    );
  }

  Column youtubeContainer(BuildContext context) {
    return Column(
      children: [
        SearchField(
          onVideoFound: (YoutubeVideoItem video) {
            setState(() {
              youtubeVideo = video;
            });
          },
        ),
        const SizedBox(height: 40),
        if (youtubeVideo.url.length > 1)
          Column(
            children: [
              const SizedBox(height: 15),
              YoutubeVideo(youtubeVideo: youtubeVideo),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  downloadButton(),
                  SizedBox(width: MediaQuery.of(context).size.width / 30),
                  dropdownFormatVideo(context)
                ],
              ),
            ],
          )
        else
          isLoadingSearch ? const LinearProgressIndicator() : const SizedBox()
      ],
    );
  }

  DropdownButton<String> dropdownFormatVideo(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      fontSize: 18,
    );

    return DropdownButton<String>(
      borderRadius: BorderRadius.circular(10),
      padding: const EdgeInsets.only(left: 12, right: 12),
      iconSize: 32.0,
      value: _videoFormat,
      style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w500),
      alignment: Alignment.center,
      items: <DropdownMenuItem<String>>[
        DropdownMenuItem(
          alignment: Alignment.center,
          value: "mp4",
          child: Text("Video mp4", style: textStyle),
        ),
        DropdownMenuItem(
          alignment: Alignment.center,
          value: "mp3",
          child: Text("Audio mp3", style: textStyle),
        )
      ],
      onChanged: (String? value) {
        setState(() {
          _videoFormat = value!;
        });
      },
      hint: const Text("Select item"),
    );
  }
}
