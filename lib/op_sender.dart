import 'dart:io';
import 'dart:convert';
import 'package:udp/udp.dart';

class OpSender {
  static send(String ip, int port, String op) async {
    List<int> bytes = utf8.encode(op);

    var sender = await UDP.bind(Endpoint.any(port: const Port(65000)));
    var dataLength = await sender.send(bytes, Endpoint.unicast(InternetAddress(ip),port: Port(port)));
  }
}

//9C-6B-00-03-D6-A9