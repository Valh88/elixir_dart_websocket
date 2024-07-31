// import 'package:web/web.dart';
import 'package:phoenix_socket/phoenix_socket.dart';
import 'package:uuid/uuid.dart';
import 'package:web/web.dart';
import 'dart:async';
import 'dom.dart';

class WebsocketClientConnect extends FormMessagePush {
  PhoenixSocket? socket;
  PhoenixChannel? romChannel;
  // FormMessagePush messagePush = FormMessagePush();
  final _uuid = Uuid().v4();

  WebsocketClientConnect() {
    socket = PhoenixSocket('ws://localhost:4000/socket/websocket');
  }

  void connectSocketChannel() async {
    await socket?.connect();
    romChannel = socket?.addChannel(topic: 'room:42');
    await romChannel?.join().future;
    push();
    await for (Message message in (romChannel?.messages ?? Stream.empty())) {
      if (message.event.value == 'message') {
        addDomMessage(message.payload);
      } else {}
      if (message.event != PhoenixChannelEvent.custom('ping') ||
          message.payload?['from'] == uuid) continue;
      print("received ${message.event} from ${message.payload!['from']}");
      Timer(const Duration(seconds: 1), () {
        romChannel?.push('user', {'from': _uuid});
      });
    }
  }

  String get uuid {
    return _uuid;
  }

  void push() {
    romChannel?.push('user', {'from': _uuid});
  }

  void messages() async {
    await for (var message in (romChannel?.messages ?? Stream.empty())) {
      print(message);
      if (message.event != PhoenixChannelEvent.custom('ping') ||
          message.payload?['from'] == uuid) continue;
      print("received ${message.event} from ${message.payload!['from']}");
    }
  }

  void pushInput() {
    var buttonElement = button();
    var inputElement = input();
    buttonElement.onClick.listen((MouseEvent event) {
      var value = inputElement.value;
      romChannel?.push('message', {'message': value, 'from': _uuid});
    });
  }

  void addDomMessage(Map<String, dynamic>? payload) {
    var elemLi = document.createElement('li');
    elemLi.textContent = "user: ${payload?['from']} - ${payload?['message']}";
    var domUl = document.querySelector('ul');
    domUl?.insertAdjacentElement('beforeEnd', elemLi);
  }
}
