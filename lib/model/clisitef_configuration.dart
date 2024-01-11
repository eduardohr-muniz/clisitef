library clisitef;

import 'package:flutter_clisitef/model/tipo_pinpad.dart';

class CliSiTefConfiguration {
  CliSiTefConfiguration({
    required this.enderecoSitef,
    required this.codigoLoja,
    required this.numeroTerminal,
    required this.cnpjLoja,
    required this.cnpjAutomacao,
    required this.tipoPinPad,
    required this.parametrosAdicionais,
    required this.tipoComunicacao,
    required this.tokenRegistro,
  });

  final String enderecoSitef;

  final String codigoLoja;

  final String numeroTerminal;

  final String cnpjLoja;

  final String cnpjAutomacao;

  final TipoPinPad tipoPinPad;

  final String parametrosAdicionais;

  final String tipoComunicacao;

  final String tokenRegistro;
}
