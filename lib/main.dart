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

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delicious Ghanaian Meals"),
      ),
      body: Container(
        margin: EdgeInsets.all(
          8,
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              child: StoryView(
                [
                  StoryItem(FutureBuilder<File>(
                    builder: (context, AsyncSnapshot<File> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError)
                          return Container(
                            child: Center(
                              child: Text(
                                'error occurred: ${snapshot.error}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            color: Colors.black,
                          );

                        if (snapshot.hasData) {
                          var controller = VideoPlayerController.file(snapshot.data);

                          return FutureBuilder<void>(
                            builder:
                                (BuildContext context, AsyncSnapshot<void> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
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
                    future: DefaultCacheManager().getSingleFile(url),
                  ),
                      duration: Duration(seconds: 15)),
                  StoryItem.text(
                    "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
                    Colors.orange,
                    roundedTop: true,
                  ),
                  StoryItem.inlineImage(
                    NetworkImage(
                        "https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
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
                },
                progressPosition: ProgressPosition.top,
                repeat: true,
                inline: true,


              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MoreStories()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(8))),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "View more stories",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
