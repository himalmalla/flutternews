import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  String blogUrl;
  ArticleView({required this.blogUrl});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late WebViewController _controller;
  bool buttonshow = false;

  void scrollToTop() {
    _controller.runJavascript("window.scrollTo({top: 0, behavior: 'smooth'});");
    floatingButtonVisibility();
  }

  void floatingButtonVisibility() async {
    int y = await _controller.getScrollY();
    if (y > 50) {
      setState(() {
        buttonshow = true;
      });
    } else {
      setState(() {
        buttonshow = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Flutter"),
            Text(
              "News",
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
        elevation: 0.0,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: Container(
        child: WebView(
          initialUrl: widget.blogUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
          gestureRecognizers: Set()
            ..add(Factory(() => VerticalDragGestureRecognizer()
              ..onDown = (tap) {
                floatingButtonVisibility();
              })),
        ),
      ),
      floatingActionButton: Visibility(
          visible: buttonshow,
          child: FloatingActionButton.extended(
            onPressed: () {
              scrollToTop();
            },
            label: const Text(
              "Go to Top",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            icon: const Icon(Icons.navigation),
            backgroundColor: Colors.blueAccent,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
