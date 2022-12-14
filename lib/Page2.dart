import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AllVideosPage extends StatefulWidget {
  const AllVideosPage({Key? key}) : super(key: key);

  @override
  State<AllVideosPage> createState() => _AllVideosPageState();
}

class _AllVideosPageState extends State<AllVideosPage> {
  List<VideoPlayerController> controller = [];
  List<ChewieController> chewieController = [];
  List<VideoPlayerController> networkController = [];
  List<ChewieController> networkChewieController = [];

  List assetsVideos = [];
  List networkVideos = [];

  static var res2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      assetsVideos = res2.assetsVideos;
      networkVideos = res2.networkVideos;

      for (var e in assetsVideos) {
        controller.add(VideoPlayerController.asset(e)
          ..initialize().then(
            (_) {
              setState(() {});
            },
          ));
      }

      for (var e in controller) {
        chewieController.add(ChewieController(
          videoPlayerController: e,
          autoPlay: false,
          looping: false,
        ));
        setState(() {});
      }

      Timer.periodic(const Duration(microseconds: 200), (timer) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(res.category),
        centerTitle: true,
        backgroundColor: Colors.teal.withOpacity(0.5),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ...assetsVideos
                .map(
                  (e) => Container(
                    margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
                    height: 230,
                    width: double.infinity,
                    color: Colors.teal.withOpacity(0.3),
                    child: AspectRatio(
                      aspectRatio:
                          controller[assetsVideos.indexOf(e)].value.aspectRatio,
                      child: Chewie(
                        controller: chewieController[assetsVideos.indexOf(e)],
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var e in controller) {
      chewieController[controller.indexOf(e)].dispose();
      e.dispose();
    }
    for (var e in networkController) {
      networkChewieController[networkController.indexOf(e)].dispose();
      e.dispose();
    }

    super.dispose();
  }
}
