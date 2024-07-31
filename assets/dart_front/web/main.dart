import 'chat.dart';

void main() async {
  var socket = WebsocketClientConnect();
  socket.connectSocketChannel();
  socket.pushInput();
}
