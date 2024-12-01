import 'package:flutter/material.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

class Sample extends StatefulWidget {
  final String path;
  const Sample({super.key, required this.path});

  @override
  State<Sample> createState() => SampleState();
}

class SampleState extends State<Sample> {
  GlobalKey shareableWidget = GlobalKey();
  int originalSize = 500;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Your Card"),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RepaintBoundary(
              key: shareableWidget,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    widget.path,
                    width: 150,
                    height: 150,
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 2)),
                  Image.asset(
                    "assets/images/myself/description.png",
                    width: 250,
                    height: 80,
                  ),
                ],
              )),
          const Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 15)),
          ElevatedButton.icon(
            onPressed: () {
              ShareFilesAndScreenshotWidgets().shareScreenshot(shareableWidget,
                  originalSize, "Card", "Card.jpg", "image/jpg");
            },
            icon: const Icon(
              Icons.share,
            ),
            label: const Text("Share"),
            style: TextButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }
}
