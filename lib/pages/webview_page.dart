import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => WebViewPageState();
}

late final WebViewController webViewController;

class WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => debugPrint('Page started loading: $url'),
          onPageFinished: (url) => debugPrint('Page finished loading: $url'),
          onUrlChange: (change) => debugPrint('url changed to ${change.url}'),
          onProgress: (progress) =>
              debugPrint('WebView is loading (progress : $progress%)'),
          onWebResourceError: (error) =>
              debugPrint('Page resource error code: ${error.errorCode}'),
          onNavigationRequest: (request) {
            if (request.url.startsWith('https://www.facebook.com')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://heyflutter.com'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('WebView Page'),
          ),
          body: WebViewWidget(controller: webViewController),
          floatingActionButton: FloatingActionButton(
            onPressed: () => webViewController
                .loadRequest(Uri.parse('https://www.youtube.com')),
            child: const Icon(Icons.import_export, size: 32),
          ),
        ),
      );
}

Future<bool> onWillPop() async {
  if (await webViewController.canGoBack()) {
    webViewController.goBack();
    return false;
  } else {
    return true;
  }
}
