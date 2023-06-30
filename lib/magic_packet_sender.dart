import 'dart:io';
import 'dart:convert';
import 'package:udp/udp.dart';

class MagicPacketSender {
  late List<int> macBytes = [];

  MagicPacketSender(String mac) {
    mac = mac.replaceAll(RegExp(r'[-:]'), '');

    for (int i = 0; i < mac.length; i += 2) {
      String hex = mac.substring(i, i + 2);
      int byte = int.parse(hex, radix: 16);
      macBytes.add(byte);
    }
  }

  send(String ip, int port) async {
    var bytes = getMagicPacket();

    var sender = await UDP.bind(Endpoint.any(port: const Port(65000)));
    var dataLength = await sender.send(bytes, Endpoint.unicast(InternetAddress(ip),port: Port(port)));
  }

  sendOP(String ip, int port) async {
    String code = "OPWOL";
    List<int> bytes = utf8.encode(code);

    var sender = await UDP.bind(Endpoint.any(port: const Port(65000)));
    var dataLength = await sender.send(bytes, Endpoint.unicast(InternetAddress(ip),port: Port(port)));
  }

  sendBroadcast(int port) async {
    var bytes = getMagicPacket();

    var sender = await UDP.bind(Endpoint.any(port: const Port(65000)));
    var dataLength = await sender.send(bytes, Endpoint.broadcast(port: Port(port)));
  }

  List<int> getMagicPacket() {
    List<int> bytes = [0xff, 0xff, 0xff, 0xff, 0xff, 0xff];
    for(var i=0; i<16; i++) {
      bytes.addAll(macBytes);
    }

    return bytes;
  }
}

//9C-6B-00-03-D6-A9