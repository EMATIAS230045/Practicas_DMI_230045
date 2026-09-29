import 'package:flutter/material.dart';
import 'package:yes_no_app/config/helpers/get_yes_no_answer.dart';
import 'package:yes_no_app/domian/entities/message.dart';

class ChatProvider extends ChangeNotifier {
  final chatScrollController = ScrollController();
  final getYesNoAnswer = GetYesNoAnswer();

  List<Message> messageList = [
    Message(text: 'Hi Teacher', fromWho: FromWho.me, status: MessageStatus.read),
    Message(text: 'my name is Matias? where about are you?', fromWho: FromWho.me, status: MessageStatus.read),
  ];

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final newMessage = Message(
      text: text,
      fromWho: FromWho.me,
      status: MessageStatus.sent,
    );
    messageList.add(newMessage);

    notifyListeners();
    moveScrollToBottom();

    // Simular el cambio de estado de las palomitas
    _simulateMessageStatus(newMessage);

    // Responder solo si el mensaje termina en ?
    if (text.trim().endsWith('?')) {
      await herReply();
    }
  }

  void _simulateMessageStatus(Message message) async {
    // 1 segundo para 'Entregado'
    await Future.delayed(const Duration(seconds: 1));
    message.status = MessageStatus.delivered;
    notifyListeners();

    // 1.5 segundos más para 'Visto'
    await Future.delayed(const Duration(milliseconds: 1500));
    message.status = MessageStatus.read;
    notifyListeners();
  }

  Future<void> herReply() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final herMessage = await getYesNoAnswer.getAnswer();
    messageList.add(herMessage);
    notifyListeners();

    moveScrollToBottom();
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));

    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}