import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SharedRecipeDetails extends StatefulWidget {
  const SharedRecipeDetails({Key? key, required this.sharedRecipeData})
      : super(key: key);

  final Map<String, dynamic> sharedRecipeData;

  @override
  _SharedRecipeDetailsState createState() => _SharedRecipeDetailsState();
}

class _SharedRecipeDetailsState extends State<SharedRecipeDetails> {
  VideoPlayerController? _videoController;

  bool isLoading = true;
  bool showVideo = true;

  @override
  void initState() {
    super.initState();
    final List<dynamic>? sectionsList = widget.sharedRecipeData["sections"];

    if (sectionsList != null) {
      for (final section in sectionsList) {
        if (section != null) {
          final List<dynamic>? componentsList = section["components"];
          print(componentsList!);
        }
      }
    }

    // final List<dynamic>? sectionsList = widget.sharedRecipeData["sections"];

    // if (sectionsList != null) {
    //   for (final section in sectionsList) {
    //     if (section != null) {
    //       final String rawText = section["raw_text"];
    //       final String ingredientName = section["ingredient"]["name"];
    //       final String extraComment = section["extra_comment"];

    //       print("Ingredient: $ingredientName");
    //       print("Raw Text: $rawText");
    //       print("Extra Comment: $extraComment");
    //       print("----------------------------------");
    //     }
    //   }
    // } else {
    //   // Handle the case when "ingredients" is null
    //   print("none");
    // }

//     final List<dynamic> instructionsList =
//         widget.sharedRecipeData["instructions"];

//     String instructions = "";

//     for (final instruction in instructionsList) {
//       final String step = instruction["instruction"];
//       instructions += "$step\n";
//     }

// // Print the instructions
//     print("Instructions:");
//     print(instructions);
    final String? videoURL = widget.sharedRecipeData["original_video_url"];
    if (videoURL != null && videoURL.isNotEmpty) {
      // ignore: deprecated_member_use
      _videoController = VideoPlayerController.network(videoURL);
      _videoController!.addListener(() {
        if (_videoController!.value.isInitialized) {
          setState(() {
            isLoading = false;
          });
        }
        setState(() {});
      });
      _videoController!.setLooping(true);
      _videoController!.initialize().then((_) => setState(() {}));
      _videoController!.play();
    } else {
      showVideo = false;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: 600,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(widget.sharedRecipeData["name"]),
                if (showVideo && _videoController != null)
                  Center(
                    child: InkWell(
                      onTap: () {
                        if (_videoController!.value.isPlaying) {
                          _videoController!.pause();
                        } else {
                          _videoController!.play();
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          ),
                          if (isLoading) const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                if (!showVideo || _videoController == null)
                  const Text('No video available.'),
                if (_videoController?.value.isBuffering ?? false)
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
