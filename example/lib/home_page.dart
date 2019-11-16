import 'package:flutter/material.dart';

import 'get_with_onreceived.dart';
import 'post.dart';
import 'simple_get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Spacer(flex: 3),
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Request State Example",
                  style: Theme.of(context)
                      .textTheme
                      .display2
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text("Basic Get Request"),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SimpleGetPage(),
              )),
            ),
            RaisedButton(
              child: Text("Post Request With Body"),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PostPage(),
              )),
            ),
            RaisedButton(
              child: Text("Get Request with onReceived"),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GetWithOnreceivedPage(),
              )),
            ),
            Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
