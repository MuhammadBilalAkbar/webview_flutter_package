import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => WebViewPageState();
}

final webViewController = WebViewController()
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
        if (request.url.startsWith('https://flutter.dev/')) {
          debugPrint('blocking navigation to ${request.url}');
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://www.amazon.com'))
  ..runJavaScript(
      "document.getElementsByTagName('header')[0].style.display='none'");

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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              webViewController.loadRequest(
                Uri.parse('https://www.youtube.com'),
              );
            },
            child: const Icon(Icons.import_export, size: 32),
          ),
        ),
      );
}
