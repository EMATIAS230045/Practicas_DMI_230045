import 'dart:math';
import 'package:dio/dio.dart';
import 'package:yes_no_app/domian/entities/message.dart';
import 'package:yes_no_app/infrastructure/models/yes_no_model.dart';

class GetYesNoAnswer {
  final _dio = Dio();

  Future<Message> getAnswer() async {
    final random = Random().nextDouble();

    if (random < 0.40) {
      // 40% de probabilidad -> Sí
      return await _fetchApiAnswer('yes', 'Sí');
    } else if (random < 0.80) {
      // 40% de probabilidad -> No
      return await _fetchApiAnswer('no', 'No');
    } else {
      // 20% de probabilidad -> Tal vez (sin GIF)
      return Message(
        text: 'Tal vez',
        imageUrl: 'https://i0.wp.com/heartbitsvgcom.wpcomstaging.com/wp-content/uploads/2020/11/917a025237c981df309b9a0997adc1f2.gif?resize=1000%2C666&ssl=1',
        fromWho: FromWho.hers,
      );
    }
  }

  Future<Message> _fetchApiAnswer(String forceType, String textResponse) async {
    try {
      final response = await _dio.get('https://yesno.wtf/api?force=$forceType');
      final yesNoModel = YesNoModel.fromJsonMap(response.data);

      return Message(
        text: textResponse,
        imageUrl: yesNoModel.image,
        fromWho: FromWho.hers,
      );
    } catch (e) {
      // Si la API falla, mantiene la respuesta de texto sin GIF
      return Message(
        text: textResponse,
        imageUrl: null,
        fromWho: FromWho.hers,
      );
    }
  }
}