import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

const kWebUrl =
    'https://ap.studio-uat.chubb.com/v2/sg/dbs/staycation/pweb-sp/en-SG';

class TXWebView extends StatefulWidget {
  const TXWebView({Key? key, this.webUrl}) : super(key: key);
  final String? webUrl;
  @override
  _TXWebViewState createState() => _TXWebViewState();
}

class _TXWebViewState extends State<TXWebView> {
  WebViewController? _controller;
  bool isLoading = true;
  double _progressValue = 0.0;

  Widget _buildWebView() {
    return WebView(
      initialUrl: widget.webUrl ?? kWebUrl,
      onWebViewCreated: (WebViewController controller) {
        _controller = controller;
        // _loadLocalHtmlFile();
      },
      onPageStarted: (value) {},
      onProgress: (int progress) {
        if (kDebugMode) {
          print('Progress $progress');
        }
        setState(() {
          _progressValue += progress;
        });
      },
      onPageFinished: (String url) {
        setState(() {
          isLoading = false;
        });
        if (kDebugMode) {
          print('Page finished loading: $url');
        }
      },
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: <JavascriptChannel>{
        JavascriptChannel(
          name: 'paymentSuccessCallback',
          onMessageReceived: (JavascriptMessage message) {
            if (kDebugMode) {
              print("message from the web view=\"${message.message}\"");
            }
            //this is success call back
            Navigator.of(context, rootNavigator: true).pop("Discard");
          },
        )
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            // elevation: 0,
            title: const Text(
              'Insurance',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Transform.scale(
                scale: 1.5,
                child: IconButton(
                  mouseCursor: null,
                  icon: const Icon(Icons.close_outlined, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            )),
        body: Column(children: [
          isLoading
              ? LinearProgressIndicator(
                  backgroundColor: Colors.orange,
                  value: _progressValue,
                )
              : Container(),
          Expanded(child: _buildWebView()),
        ]),
      ),
    );
  }

  _loadLocalHtmlFile() async {
    String fileText = """
    <!DOCTYPE html>
<html>
    
    <head>
        <title>Hello Test WKWebView</title>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content=""/>
        <meta http-equiv="Content-Type" content="no-cache"/>
        <meta http-equiv="Expires" content="-1"/>
        <meta name="apple-mobile-web-app-capable" content="yes"/>
    </head>
    <body>
        
        <button type="button" id="BackToHome">Back To Home</button></br>
        <script>
            var backToHomeButton = document.getElementById('BackToHome');
            backToHomeButton.addEventListener('click', function() {
                // Swift
                window
                .webkit
                .messageHandlers
                .paymentSuccessCallback.postMessage('Payment Success Again');
                
            }, false);
        </script>
        
    </body>
    
</html>
    """;
    print(fileText);
    _controller?.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
