import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoupangHtmlAdConfig {
  final String html;
  final double width;
  final double height;

  CoupangHtmlAdConfig({
    required this.html,
    required this.width,
    required this.height,
  });
}

class CoupangHtmlAdView extends StatefulWidget {
  final String html;
  final double width;
  final double height;

  CoupangHtmlAdView(CoupangHtmlAdConfig config)
      : this.html = config.html,
        this.width = config.width,
        this.height = config.height;

  @override
  _CoupangHtmlAdViewState createState() => _CoupangHtmlAdViewState();
}

class _CoupangHtmlAdViewState extends State<CoupangHtmlAdView> {
  late MethodChannel _channel;

  @override
  void didUpdateWidget(CoupangHtmlAdView oldWidget) {
    if (oldWidget.html != widget.html) {
      _onDataChanged(widget.html);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _onDataChanged(String html) {
    _channel.invokeMethod("onDataChanged", {"data": _constructHTMLData(html)});
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return Container(
        width: widget.width,
        height: widget.height,
        child: _buildAdView(),
      );
    }
    debugPrint(
      'coupang_ad_view package only support for Andoid and IOS.\n'
      'Current platform is ${Platform.operatingSystem}',
    );
    return Container();
  }

  Widget _buildAdView() {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'flutter.coupang.ad/CoupangAdView',
        creationParams: {
          "data": _constructHTMLData(widget.html),
        },
        creationParamsCodec: const JSONMessageCodec(),
        onPlatformViewCreated: (viewId) => _onPlatformViewCreated(viewId),
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'flutter.coupang.ad/CoupangAdView',
        creationParams: {
          "data": _constructHTMLData(widget.html),
        },
        creationParamsCodec: const JSONMessageCodec(),
        onPlatformViewCreated: (viewId) => _onPlatformViewCreated(viewId),
      );
    }
    return Container();
  }

  void _onPlatformViewCreated(int viewId) {
    _channel = MethodChannel('coupang_ad_view_$viewId');
    _listenForNativeEvents(viewId);
  }

  void _listenForNativeEvents(int viewId) {
    EventChannel eventChannel =
        EventChannel("coupang_ad_view_event_$viewId", JSONMethodCodec());
    eventChannel.receiveBroadcastStream().listen(_processNativeEvent);
  }

  void _processNativeEvent(dynamic event) async {
    if (event is Map) {
      String eventName = event["event"];
      switch (eventName) {
        case "onLinkOpened":
          break;
        case "onError":
          break;
        default:
          break;
      }
    }
  }

  String _constructHTMLData(String html) {
    return "<html><header>" +
        "<meta name='viewport' content='width=device-width, " +
        "initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>" +
        "</header><body>" +
        html +
        "</body></html>";
  }
}
