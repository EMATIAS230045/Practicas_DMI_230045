enum FromWho { me, hers }

enum MessageStatus { sent, delivered, read }

class Message {
  final String text;
  final String? imageUrl;
  final FromWho fromWho;
  final DateTime createdAt;
  MessageStatus status;

  Message({
    required this.text,
    this.imageUrl,
    required this.fromWho,
    DateTime? createdAt,
    this.status = MessageStatus.sent,
  }) : createdAt = createdAt ?? DateTime.now();
}