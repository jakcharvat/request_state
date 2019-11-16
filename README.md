# request_state

An alternative to flutter's built-in `State` class made specifically to deal with async http requests. 

### Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  request_state: ^0.0.1
```

### Using the package

Using `RequestState` is really simple. Assume you have a `StatefulWidget` called `SomeWidget` that you want to work with http requests.

```dart
import 'package:flutter/material.dart';

class SomeWidget extends StatefulWidget {
  @override
  _SomeWidgetState createState() => _SomeWidgetState();
}

class _SomeWidgetState extends State<SomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

To allow this widget to use `RequestState` you:

1) Import `RequestState`: 
```dart
import 'package:request_state/request_state.dart';
```

2) Exchange `State<SomeWidget>` for `RequestState<SomeWidget>`

```dart
import 'package:flutter/material.dart';
import 'package:request_state/request_state.dart';

class SomeWidget extends StatefulWidget {
  @override
  _SomeWidgetState createState() => _SomeWidgetState();
}

class _SomeWidgetState extends RequestState<SomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

Then, you can remove the `build()` method override, and instead you must override `idleBody()`, `waitingForResponseBody()` and `responseReceivedBody()`:

```dart
import 'package:flutter/material.dart';
import 'package:request_state/request_state.dart';

class SomeWidget extends StatefulWidget {
  @override
  _SomeWidgetState createState() => _SomeWidgetState();
}

class _SomeWidgetState extends RequestState<SomeWidget> {
  @override
  Widget idleBody(BuildContext context) {
    return Container();
  }
  
  @override
  Widget waitingForResponseBody(BuildContext context) {
    return CircularProgressIndicator();
  }
  
  @override
  Widget receivedResponseBody(BuildContext context) {
    return Text("Response Received");
  }
}
```

These three methods define what child your widget should show at different stages of the request. `idleBody()`
is shown before a request has been sent for the first time, `waitingForResponseBody()` is shown once a request 
has been sent but no response has been received yet, and `receivedResponseBody()` is shown when a response has 
successfully been received. 

You may also optionally override `requestFailedBody()` to define what is shown when sending the request fails. 
By default this uses the widget provided to `idleBody()`. 

```dart
import 'package:flutter/material.dart';
import 'package:request_state/request_state.dart';

class SomeWidget extends StatefulWidget {
  @override
  _SomeWidgetState createState() => _SomeWidgetState();
}

class _SomeWidgetState extends RequestState<SomeWidget> {
  @override
  Widget idleBody(BuildContext context) {
    return Container();
  }
  
  @override
  Widget waitingForResponseBody(BuildContext context) {
    return CircularProgressIndicator();
  }
  
  @override
  Widget receivedResponseBody(BuildContext context) {
    return Text("Response Received");
  }
  
  @override
  Widget requestFailedBody(BuildContext context) {
    return Text("Sending Request Failed");
  }
}
```

All four of these methods work the way you are used to with normal `State`'s `build()` method.

### Sending a request

To send a request you use the build-in `sendRequest()` method, passing in the URL to send the request to:

```dart
@override
Widget idleBody(BuildContext context) {
  return RaisedButton(
    child: Text("Send Request"),
    onPressed: () {
      sendRequest("https://my-api-url.com");
    }
  );
}
```

This will send a GET request to `https://my-api-url.com`, showing `waitingForResponseBody()` whilst waiting
for a response from the API, and then show `receivedResponse()Body` when a response is received. Alternatively, 
if sending the request fails, it will show the value of `requestFailedBody()`. 

You may optionally also specify the type of the request (only GET or POST supported as of version 0.0.1) by 
passing a value of the `RequestType` enum to named `type` parameter (GET by default), a body for the request,
a `Map<String, dynamic>` passed to the named `body` parameter. 

If you would like to fire a callback when a response is successfully received, you may pass a callback to the 
`onReceived` argument of the `sendRequest()` method. The callback should have a `void` return type and provides
you with a `Response` object (from the `http` package) containing the received response. 

```dart
@override
Widget idleBody(BuildContext context) {
  return RaisedButton(
    child: Text("Send Request"),
    onPressed: () {
      sendRequest("https://my-api-url.com", onReceived: (response) {
        print("Response successfully received. The body of the response is: ${response.body}");
      });
    }
  );
}
```

Similarly, if you would like to fire a callback when sending a request is unsuccessful, you may pass it to the
`onError` argument of the `sendRequest()` method. Like `onReceived`, this should also have a `void` return type,
and provides you with the `Exception` object that was thrown.

```dart
@override
Widget idleBody(BuildContext context) {
  return RaisedButton(
    child: Text("Send Request"),
    onPressed: () {
      sendRequest("https://my-api-url.com", onError: (error) {
        print("Sending request failed. The error is: $error");
      });
    }
  );
}
```

### Contributing

If you encounter a bug or have a suggestion, please open an issue for it on GitHub. Feel free to fork the repo
and submit PRs on the original one. All suggestions and contributions are welcome.
