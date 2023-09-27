import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ColetasController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String erro = '';

  ColetasController() {
    getPosicao();
  }

  getPosicao() async {
    try {
      Position posicao = await _posicaoAtual();
      lat = posicao.latitude;
      long = posicao.longitude;
    } catch (e) {
      erro = e.toString();
    }
    notifyListeners();
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;

    //Verificando se a localização está habilitada
    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error('Por favor, habilite a localização do seu aparelho');
    }

    //Verificando se já existe a permissão de utilizar a localização
    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização');
      }
    }

    //Verificando se o usuário negou permanentimente o acesso a localização
    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Você precisa autorizar o acesso à localização');
    }

    return await Geolocator.getCurrentPosition();
  }
}
