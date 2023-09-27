import 'package:flutter/material.dart';
import 'package:recicla_app/Controllers/pontos.dart';

class PontosRepository extends ChangeNotifier {
  final List<Pontos> pontos = [
    Pontos(
        nome: 'Reciclagem do Paulista',
        endereco:
            'Av. Rio Branco, 107 - Lot Gurilandia, Mossoró - RN, 59619-400',
        foto:
            'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=k8wosf_2y3eCrEBqWsOhCw&cb_client=search.gws-prod.gps&w=408&h=240&yaw=260.29547&pitch=0&thumbfov=100',
        latitude: -5.17209050989726,
        longitude: -37.34314468349613),
    Pontos(
        nome: 'Mossoró Reciclagem',
        endereco: 'BR-304, 156 - parque industrial, Mossoró - RN, 59600-971',
        foto:
            'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=4h8L08kMxcpYB9Rk5G_YMQ&cb_client=search.gws-prod.gps&w=408&h=240&yaw=316.63617&pitch=0&thumbfov=100',
        latitude: -5.142613605471558,
        longitude: -37.346001298131476),
    Pontos(
        nome: 'Cooperacrevi Mossoró RN - Reciclando para a vida!',
        endereco:
            'Rua Ranieri Barbosa de Paiva, 05 - Dom Jaime Câmara, Mossoró - RN, 59628-803',
        foto:
            'https://lh5.googleusercontent.com/p/AF1QipOIDNtIMXU0axlt_3QLeusV65yTVUqKe3Oy46IS=w426-h240-k-no',
        latitude: -5.235985573913987,
        longitude: -37.31172486625607),
    Pontos(
        nome: 'Macferro',
        endereco:
            'R. Lopes Trovão, 102 - Alto da Conceição, Mossoró - RN, 59600-260',
        foto:
            'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=oOMUupkj53pFcpIrrxOvUg&cb_client=search.gws-prod.gps&w=408&h=240&yaw=144.80238&pitch=0&thumbfov=100',
        latitude: -5.194199458180297,
        longitude: -37.34670687993014)
  ];

  void adicionarPonto(String nome, String caminhoDaImagem) {
    Pontos novoPonto = Pontos(
        nome: nome,
        endereco: '',
        foto: caminhoDaImagem,
        latitude: 0,
        longitude: 0);
    pontos.add(novoPonto);
  }
}
