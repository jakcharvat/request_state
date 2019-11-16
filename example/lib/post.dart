import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:request_state/request_state.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post Request With Body")),
      body: Center(
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends RequestState<_Body> {
  @override
  Widget idleBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RaisedButton(
          child: Text("Send Request"),
          onPressed: () {
            sendRequest("https://jsonplaceholder.typicode.com/posts",
                type: RequestType.post,
                body: {"title": "foo", "body": "bar", "userId": 1});
          },
        ),
      ],
    );
  }

  @override
  Widget receivedResponseBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(flex: 3),
        Text(
          "Response Received",
          style: Theme.of(context).textTheme.display2,
        ),
        SizedBox(height: 20.0),
        Text(
          JsonEncoder.withIndent("    ").convert(latestResponse.data),
        ),
        Spacer(flex: 4),
      ],
    );
  }

  @override
  Widget waitingForResponseBody(BuildContext context) {
    return CircularProgressIndicator();
  }
}
