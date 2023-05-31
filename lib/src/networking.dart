// ignore_for_file: unused_catch_clause

import 'dart:async';
import 'package:console_bars/console_bars.dart';
import 'package:http/http.dart' as http;
import 'package:udp/udp.dart';

/// Finds working links from a list of links.
///
/// Returns a list of working links.
Future<List<String>> findWorkingLinks(List<String> links,
    {Duration timeout = const Duration(seconds: 3), int retries = 3}) async {
  final workingLinks = <String>[];

  final linkBar = FillingBar(
    desc: "Testing links",
    total: links.length,
    time: true,
    percentage: false,
    width: 50,
  );

  for (final link in links) {
    linkBar.increment();
    if (await checkLink(link, timeout: timeout, retries: retries)) {
      workingLinks.add(link);
    }
  }

  return workingLinks;
}

/// Checks if a link is working.
///
/// Returns true if the link is working, false otherwise.
Future<bool> checkLink(String link,
    {Duration timeout = const Duration(seconds: 3), int retries = 3}) async {
  try {
    if (link.startsWith('http')) {
      return await checkHttp(link, timeout: timeout);
    } else if (link.startsWith('udp')) {
      return await checkUdp(link, timeout: timeout);
    }
  } on Exception catch (e) {
    return false;
  }

  return false;
}

/// Checks if an HTTP link is working.
///
/// Returns true if the link is working, false otherwise.
Future<bool> checkHttp(String link,
    {Duration timeout = const Duration(seconds: 3), int retries = 3}) async {
  for (var i = 0; i < retries; i++) {
    try {
      final response = await http.get(Uri.parse(link)).timeout(timeout);
      if (response.statusCode >= 100 && response.statusCode < 600) {
        return true;
      }
    } on TimeoutException catch (e) {
      continue;
    } catch (e) {
      break;
    }
  }
  return false;
}

/// Checks if a UDP link is working.
///
/// Returns true if the link is working, false otherwise.
Future<bool> checkUdp(String link,
    {Duration timeout = const Duration(seconds: 3), int retries = 3}) async {
  String portStr = link.split(':').last;
  portStr = portStr.split('/').first;
  final port = int.parse(portStr);

  final endpoint = Endpoint.loopback(port: Port(port));
  final socket = await UDP.bind(endpoint);

  for (var i = 0; i < retries; i++) {
    try {
      final data = 'ping'.codeUnits;
      // ignore: unused_local_variable
      final response = await socket.send(data, Endpoint.any(port: Port(port)));

      await Future.delayed(Duration(milliseconds: 500));

      var isOnline = false;

      await socket.asStream(timeout: timeout).listen((event) {
        if (event != null) {
          isOnline = true;
        }
      }).asFuture();

      if (isOnline) {
        return true;
      } else {
        continue;
      }
    } on TimeoutException catch (e) {
      continue;
    } catch (e) {
      break;
    }
  }

  socket.close();
  return false;
}
