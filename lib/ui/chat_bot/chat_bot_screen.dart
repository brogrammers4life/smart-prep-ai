import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: "https://mediafiles.botpress.cloud/ec1e7060-9a5b-4fd6-bcda-e80970dfe7e6/webchat/bot.html",
        ),
      )
    );
  }
}
