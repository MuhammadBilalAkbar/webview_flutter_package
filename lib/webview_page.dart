import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => WebViewPageState();
}

WebViewController webViewController = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(Colors.white)
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (progress) {
        debugPrint('WebView is loading (progress : $progress%)');
      },
      onPageStarted: (url) {
        debugPrint('Page started loading: $url');
      },
      onPageFinished: (String url) {
        debugPrint('Page finished loading: $url');
      },
      onWebResourceError: (WebResourceError error) {
        debugPrint('Page resource error code: ${error.errorCode}');
      },
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://flutter.dev/')) {
          debugPrint('blocking navigation to ${request.url}');
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      onUrlChange: (UrlChange change) {
        debugPrint('url change to ${change.url}');
      },
    ),
  )
  ..loadRequest(Uri.parse('https://www.google.com'));

class WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (await webViewController.canGoBack()) {
            webViewController.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('WebView Page'),
          ),
          body: Stack(
            children: [
              WebViewWidget(
                controller: webViewController,
              ),
            ],
          ),
        ),
      );
}
