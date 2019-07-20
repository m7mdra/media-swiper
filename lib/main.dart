import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:media_swiper/story_view.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delicious Ghanaian Meals"),
      ),
      body: PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Story(

            globalKey: GlobalKey(),
            onComplete: () {
              _pageController.animateToPage(index + 1,
                  duration: Duration(milliseconds: 500), curve: Curves.easeInExpo);
            },
            canGoToPreviousStory: (){
              _pageController.animateToPage(index - 1,
                  duration: Duration(milliseconds: 500), curve: Curves.easeInExpo);
            },

          );
        },
        itemCount: 3,
        controller: _pageController,
      ),
    );
  }
}

class Story extends StatelessWidget {
  final VoidCallback onComplete;
  final VoidCallback canGoToPreviousStory;

  const Story({
    this.canGoToPreviousStory,
    Key key,
    @required this.globalKey,
    this.onComplete,
  }) : super(key: key);

  final GlobalKey<StoryViewState> globalKey;

  @override
  Widget build(BuildContext context) {
    return StoryView(
      [
        StoryItem(
            Center(
              child: FutureBuilder<File>(
                builder: (context, AsyncSnapshot<File> snapshot) {
                  globalKey.currentState.pause();
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError)
                      return Container(
                        child: Text(
                          'error occurred: ${snapshot.error}',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.black,
                      );

                    if (snapshot.hasData) {
                      var controller =
                          VideoPlayerController.file(snapshot.data);

                      return FutureBuilder<void>(
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            globalKey.currentState.resume();

                            controller.setLooping(true);
                            controller.play();

                            return AspectRatio(
                              child: VideoPlayer(controller),
                              aspectRatio: controller.value.aspectRatio,
                            );
                          } else
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            );
                        },
                        future: controller.initialize(),
                      );
                    }
                    return Container(
                      color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }
                },
                future: DefaultCacheManager().getSingleFile(
                    "https://gcs-vimeo.akamaized.net/exp=1563011881~acl=%2A%2F637949211.mp4%2A~hmac=75506a50320b18251a9e71fa16975cb54860d1e9a5ffaa0617349d786ab8cd60/vimeo-prod-skyfire-std-us/01/3327/7/191636228/637949211.mp4"),
              ),
            ),
            duration: Duration(seconds: 5)),
        StoryItem.text(
          "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
          Colors.orange,
          roundedTop: true,
        ),
        StoryItem.inlineImage(
          NetworkImage("https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
          caption: Text(
            "Banku & Tilapia. The food to keep you charged whole day.\n#1 Local food.",
            style: TextStyle(
              color: Colors.white,
              backgroundColor: Colors.black54,
              fontSize: 17,
            ),
          ),
        ),
        StoryItem.inlineImage(
          NetworkImage(
              "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg"),
          caption: Text(
            "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
            style: TextStyle(
              color: Colors.white,
              backgroundColor: Colors.black54,
              fontSize: 17,
            ),
          ),
        ),
      ],
      onStoryShow: (s) {
        print("Showing a story");
      },
      onComplete: () {
        print("Completed a cycle");
        onComplete();
      },
      canGoPrevious: (){
        canGoToPreviousStory();
        print("canGoToPreviousStory");

      },
      progressPosition: ProgressPosition.top,
      repeat: false,
      inline: true,
      key: globalKey,
    );
  }
}

class MoreStories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("More"),
      ),
      body: StoryView(
        [
          StoryItem.text(
            "I guess you'd love to see more of our food. That's great.",
            Colors.blue,
          ),
          StoryItem.text(
            "Nice!\n\nTap to continue.",
            Colors.red,
          ),
          StoryItem.pageImage(
            NetworkImage(
                "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg"),
            caption: "Still sampling",
          )
        ],
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
      ),
    );
  }
}
