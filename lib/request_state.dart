library request_state;

import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as http;

abstract class RequestState<T extends StatefulWidget> extends State<T> {

  /// The status of the request, used to determine what body to show
  RequestStatus _requestStatus = RequestStatus.idle;

  /// The last received response. `null` initially, only assigned once a response is actually received
  @protected
  http.Response latestResponse;

  /// Widget to show before a request has been sent for the first time
  @protected
  Widget idleBody(BuildContext context);

  /// Widget to show once a request has been sent but no response has been received yet
  @protected
  Widget waitingForResponseBody(BuildContext context);

  /// Widget to show when a response has successfully been received
  @protected
  Widget receivedResponseBody(BuildContext context);

  /// Widget to show when getting a response failed. By default shows the same as [idleBody]
  @protected
  Widget requestFailedBody(BuildContext context) => idleBody(context);

  @override
  Widget build(BuildContext context) {
    return activeBody;
  }

  Widget get activeBody {
    Widget body;

    switch (_requestStatus) {
      case RequestStatus.idle:
        body = idleBody(context);
        break;
      case RequestStatus.waitingForResponse:
        body = waitingForResponseBody(context);
        break;
      case RequestStatus.receivedResponse:
        body = receivedResponseBody(context);
        break;
      case RequestStatus.requestFailed:
        body = requestFailedBody(context);
        break;
    }

    return body;
  }

  /// Send an http request and trigger the response logic of this widget
  void sendRequest(
    /// The URL to send the request to
    String url, {
    /// The type of request. As of now only `get` and `post` requests are supported
    RequestType type = RequestType.get,
    /// Body of the request as a JSON Map
    Map<String, dynamic> body,
    /// Callback to fire when requesting response succeeds
    void Function(http.Response response) onReceived,
    /// Callback to fire when requesting response fails
    void Function(Exception exception) onError,
  }) async {

    setState(() => _requestStatus = RequestStatus.waitingForResponse);

    Future<http.Response> responseFuture;

    try {
      switch (type) {
        case RequestType.get:
          responseFuture = http.Dio().get(url);
          break;
        case RequestType.post:
          responseFuture = http.Dio().post(url, data: body);
          break;
      }

      http.Response response = await responseFuture;

      if (onReceived != null) onReceived(response);
      setState(() {
        latestResponse = response;
        _requestStatus = RequestStatus.receivedResponse;
      });

    } catch (e) {
      setState(() => _requestStatus = RequestStatus.requestFailed);
      if (onError != null) onError(e);
      throw(e);
    }
  }

}

/// The type of http request to send. For now only supports get and post requests, if you
/// need support for other feel free to create an issue on GitHub.
enum RequestType {
  get,
  post,
}

/// The status of the request
enum RequestStatus {
  /// Before the request a been sent for the first time
  idle,
  /// The request has been sent but no response has been received yet
  waitingForResponse,
  /// A response was successfully received
  receivedResponse,
  /// There was some issue sending the request
  requestFailed,
}
