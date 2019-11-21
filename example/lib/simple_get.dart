import 'dart:convert';

import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:request_state/request_state.dart';

class SimpleGetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Get Request"),
        actions: <Widget>[
          LayoutBuilder(builder: (context, constraints) {
            return IconButton(
              icon: Icon(Icons.code),
              tooltip: "Show Source",
              onPressed: () => Utils(context).openSource(
                "https://github.com/jakcharvat/request_state/blob/master/example/lib/simple_get.dart",
              ),
            );
          })
        ],
      ),
      body: Center(
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  _Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends RequestState<_Body> {
  @override
  Widget idleBody(BuildContext context) {
    return RaisedButton(
      child: Text("Send Request"),
      onPressed: () {
        sendRequest(
          "https://jsonplaceholder.typicode.com/posts",
        );
      },
    );
  }

  @override
  Widget receivedResponseBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20.0),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 64.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Response Received",
                      style: Theme.of(context).textTheme.display2,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  /// The body of the latest received response as a simple string. Using [JsonEncoder.withIntent]
                  /// to display the response in a friendly-to-read way
                  JsonEncoder.withIndent("    ").convert(latestResponse.data),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget waitingForResponseBody(BuildContext context) {
    return CircularProgressIndicator();
  }
}
