enum FromWho{ mine, him}


class Message {  
  final String text;
  final String imageURL;
  final FromWho fromWho;

  Message({
    required this.text,
    required this.imageURL,
    required this.fromWho
     }
    );
}