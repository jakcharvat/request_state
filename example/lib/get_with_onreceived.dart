import 'dart:convert';

import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:request_state/request_state.dart';

class GetWithOnreceivedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Get Request"),
        actions: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              return IconButton(
                icon: Icon(Icons.code),
                onPressed: () => Utils(context).openSource(
                    "https://github.com/jakcharvat/request_state/blob/master/example/lib/get_with_onreceived.dart"),
              );
            },
          )
        ],
      ),
      body: Center(
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends RequestState<_Body> {
  int _responseCount = 0;

  @override
  Widget idleBody(BuildContext context) {
    return RaisedButton(
      child: Text("Send Request"),
      onPressed: () => sendRequest(
        "https://jsonplaceholder.typicode.com/todos/1",
        onReceived: (response) {
          setState(() => _responseCount++);
        },
      ),
    );
  }

  @override
  Widget receivedResponseBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(JsonEncoder.withIndent("    ").convert(latestResponse.data)),
        SizedBox(height: 10.0),
        RaisedButton(
          child: Text("Resend Response"),
          onPressed: () => sendRequest(
            "https://jsonplaceholder.typicode.com/todos/1",
            onReceived: (response) {
              setState(() => _responseCount++);
            },
          ),
        )
      ],
    );
  }

  @override
  Widget waitingForResponseBody(BuildContext context) {
    return CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 64.0),
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Received $_responseCount ${_responseCount == 1 ? "response" : "responses"}",
                style: Theme.of(context).textTheme.display2,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        activeBody,
      ],
    );
  }
}
