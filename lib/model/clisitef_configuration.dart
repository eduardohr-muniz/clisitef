library clisitef;

import 'package:clisitef/model/tipo_pinpad.dart';

class CliSiTefConfiguration {
  CliSiTefConfiguration(
      {required this.enderecoSitef,
      required this.codigoLoja,
      required this.numeroTerminal,
      required this.cnpjLoja,
      required this.cnpjEmpresa,
      required this.tipoPinPad});

  final String enderecoSitef;

  final String codigoLoja;

  final String numeroTerminal;

  final String cnpjLoja;

  final String cnpjEmpresa;

  final TipoPinPad tipoPinPad;
}
