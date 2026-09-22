import 'package:flutter/material.dart';
import 'package:yes_no_app/domian/entities/message.dart';


class ChatProvider extends ChangeNotifier{

final ScrollController chatScrollController = ScrollController();


  List<Message> messageList = [
    Message(text: "Hola mi Amor",imageURL: 'https://media.tenor.com/UaU4_VgrJw0AAAAj/age-of-empires-aoe.gif' , fromWho: FromWho.mine ),
    Message(text: "Ya dejaste del trabajo",imageURL: 'https://media.tenor.com/UaU4_VgrJw0AAAAj/age-of-empires-aoe.gif', fromWho: FromWho.mine),
    Message(text: "Ya dejaste del trabajo",imageURL: 'https://i.makeagif.com/media/11-16-2016/b3YPg6.gif', fromWho: FromWho.him)
  ];
  Future<void> sendMessage(String text) async {
  final newMessage = Message(text: text, imageURL: 'https://i.makeagif.com/media/11-16-2016/b3YPg6.gif', fromWho: FromWho.mine);
  messageList.add(newMessage);

  notifyListeners();

 }

 void movescrollToBotttom() async{
  await Future.delayed(const Duration(milliseconds: 300));
  chatScrollController.animateTo(
  chatScrollController.position.maxScrollExtent, 
  duration: const Duration(microseconds: 300),
   curve: Curves.easeOut);
 }

}


