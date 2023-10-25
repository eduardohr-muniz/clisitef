library clisitef;

import 'package:clisitef/clisitef_sdk.dart';
import 'package:clisitef/model/clisitef_configuration.dart';
import 'package:clisitef/model/clisitef_data.dart';
import 'package:clisitef/model/clisitef_resp.dart';

import 'package:clisitef/model/pinpad_events.dart';
import 'package:clisitef/model/pinpad_information.dart';
import 'package:clisitef/model/transaction.dart';
import 'package:clisitef/model/transaction_events.dart';
import 'package:clisitef/pdv/stream/data_stream.dart';
import 'package:clisitef/pdv/stream/pin_pad_stream.dart';
import 'package:clisitef/pdv/stream/transaction_stream.dart';
import 'package:flutter/services.dart';

class CliSiTefPDV {
  CliSiTefPDV(
      {required this.client,
      required this.configuration,
      this.isSimulated = false}) {
    cliSiTefResp = CliSiTefResp();
    _isReady = _init();
    client.setEventHandler(null, onPinPadEvent);
    client.setDataHandler(onData);
  }

  Future _init() async {
    _isReady = client.configure(
      configuration.enderecoSitef,
      configuration.codigoLoja,
      configuration.numeroTerminal,
      configuration.cnpjEmpresa,
      configuration.cnpjLoja,
      configuration.tipoPinPad,
    );
  }

  late Future _isReady;

  late CliSiTefResp cliSiTefResp;

  Map<int, String> cliSitetRespMap = {};

  Future get isReady => _isReady;

  CliSiTefConfiguration configuration;

  CliSiTefSDK client;

  TransactionStream? _transactionStream;

  bool isSimulated;

  final PinPadStream _pinPadStream = PinPadStream();

  PinPadStream get pinPadStream => _pinPadStream;

  final DataStream _dataStream = DataStream();

  DataStream get dataStream => _dataStream;

  Future<Stream<Transaction>> payment(
    int modalidade,
    double valor, {
    required String cupomFiscal,
    required DateTime dataFiscal,
    String operador = '',
    String restricoes = '',
  }) async {
    if (_transactionStream != null) {
      throw Exception('Another transaction is already in progress.');
    }
    cliSiTefResp.clear();
    cliSitetRespMap = {};
    try {
      bool success = await client.startTransaction(
        modalidade,
        valor,
        cupomFiscal,
        dataFiscal,
        operador,
        restricoes: restricoes,
      );
      if (!success) {
        throw Exception('Unable to start payment process');
      }
    } on Exception {
      rethrow;
    }

    _transactionStream = TransactionStream(
      onCancel: () => client.abortTransaction(),
    );
    client.setEventHandler(onTransactionEvent, onPinPadEvent);
    return _transactionStream!.stream;
  }

  Future<bool> continueTransaction(String data) async {
    return client.continueTransaction(data);
  }

  Future<bool> isPinPadPresent() async {
    if (isSimulated) {
      PinPadInformation pinPadSimulatedInfo =
          PinPadInformation(isPresent: true);
      pinPadSimulatedInfo.isConnected = true;
      pinPadSimulatedInfo.isReady = true;
      pinPadStream.emit(pinPadSimulatedInfo);
      return true;
    }
    PinPadInformation pinPad = await client.getPinpadInformation();
    PinPadInformation pinPadStreamInfo = _pinPadStream.pinPadInfo;
    pinPadStreamInfo.isPresent = pinPad.isPresent;
    pinPadStream.emit(pinPadStreamInfo);
    return _pinPadStream.pinPadInfo.isPresent;
  }

  Future<void> cancelTransaction() async {
    try {
      await client.finishLastTransaction(false);
    } on PlatformException catch (e) {
      if (e.code == '-12') {
        await client.abortTransaction();
      } else {
        rethrow;
      }
    }

    if (_transactionStream != null) {
      _transactionStream!.success(false);
      _transactionStream!.emit(_transactionStream!.transaction);
    }
  }

  onTransactionEvent(TransactionEvents event, {PlatformException? exception}) {
    Transaction? t = _transactionStream?.transaction;
    if (t != null) {
      switch (event) {
        case TransactionEvents.transactionConfirm:
          _transactionStream?.success(true);
          break;
        case TransactionEvents.transactionOk:
          _transactionStream?.success(true);
          break;
        case TransactionEvents.transactionError:
        case TransactionEvents.transactionFailed:
          _transactionStream?.success(false);
          break;
        default:
        //noop
      }
      _transactionStream?.event(event);
      _transactionStream?.done();
      _transactionStream = null;
    }
  }

  onPinPadEvent(PinPadEvents event, {PlatformException? exception}) {
    PinPadInformation pinPad = _pinPadStream.pinPadInfo;
    pinPad.event = event;
    switch (event) {
      case PinPadEvents.startBluetooth:
        pinPad.waiting = true;
        pinPad.isBluetoothEnabled = false;
        break;
      case PinPadEvents.endBluetooth:
        pinPad.waiting = false;
        pinPad.isBluetoothEnabled = true;
        break;
      case PinPadEvents.waitingPinPadConnection:
        pinPad.waiting = true;
        pinPad.isConnected = false;
        break;
      case PinPadEvents.pinPadOk:
        pinPad.waiting = false;
        pinPad.isConnected = true;
        break;
      case PinPadEvents.waitingPinPadBluetooth:
        pinPad.waiting = true;
        pinPad.isReady = false;
        break;
      case PinPadEvents.pinPadBluetoothConnected:
        pinPad.waiting = false;
        pinPad.isReady = true;
        break;
      case PinPadEvents.pinPadBluetoothDisconnected:
        pinPad.waiting = false;
        pinPad.isReady = false;
        break;
      case PinPadEvents.unknown:
      case PinPadEvents.genericError:
        _pinPadStream.error(exception ?? 'Unhandled event $event');
        return;
    }
    _pinPadStream.emit(pinPad);
  }

  void onData(CliSiTefData data) {
    if ((data.fieldId > 0) && (data.buffer.isNotEmpty)) {
      cliSitetRespMap[data.fieldId] = data.buffer;
    }

    switch (data.fieldId) {
      case 29:
        cliSiTefResp.digitado = true;
      case 100:
        cliSiTefResp.modalidadePagamento = data.buffer;
      case 101:
        cliSiTefResp.modalidadePagtoExtenso = data.buffer;
      case 102:
        cliSiTefResp.modalidadePagtoDescrita = data.buffer;
      case 105:
        cliSiTefResp.dataHoraTransacao = data.buffer;
      case 106:
        cliSiTefResp.idCarteiraDigital = data.buffer;
      case 107:
        cliSiTefResp.nomeCarteiraDigital = data.buffer;
      case 110:
        cliSiTefResp.modalidadeCancelamento = data.buffer;
      case 111:
        cliSiTefResp.modalidadeCancelamentoExtenso = data.buffer;
      case 112:
        cliSiTefResp.modalidadeCancelamentoDescrita = data.buffer;
      case 120:
        cliSiTefResp.autenticacao = data.buffer;
      case 121:
        cliSiTefResp.viaCliente = data.buffer;
      case 122:
        cliSiTefResp.viaEstabelecimento = data.buffer;
      case 123:
        cliSiTefResp.tipoComprovante = data.buffer;
      case 125:
        cliSiTefResp.codigoVoucher = data.buffer;
      case 130:
        cliSiTefResp.saque = double.parse(data.buffer);
      case 131:
        cliSiTefResp.instituicao = data.buffer;
      case 132:
        cliSiTefResp.codigoBandeiraPadrao = data.buffer;
      case 133:
        cliSiTefResp.nsuTef = data.buffer;
      case 134:
        cliSiTefResp.nsuHost = data.buffer;
      case 135:
        cliSiTefResp.codigoAutorizacao = data.buffer;
      case 136:
        cliSiTefResp.bin = data.buffer;
      case 137:
        cliSiTefResp.saldoAPagar = double.parse(data.buffer);
      case 138:
        cliSiTefResp.valorTotalRecebido = double.parse(data.buffer);
      case 139:
        cliSiTefResp.valorEntrada = double.parse(data.buffer);
      case 140:
        cliSiTefResp.dataPrimeiraParcela = data.buffer;
      case 143:
        cliSiTefResp.valorGorjeta = double.parse(data.buffer);
      case 144:
        cliSiTefResp.valorDevolucao = double.parse(data.buffer);
      case 145:
        cliSiTefResp.valorPagamento = double.parse(data.buffer);
      case 146:
        cliSiTefResp.valorASerCancelado = double.parse(data.buffer);
      case 155:
        cliSiTefResp.tipoCartaoBonus = data.buffer;
      case 156:
        cliSiTefResp.nomeInstituicao = data.buffer;
      case 157:
        cliSiTefResp.codigoEstabelecimento = data.buffer;
      case 158:
        cliSiTefResp.codigoRedeAutorizadora = data.buffer;
      case 160:
        cliSiTefResp.numeroCupomOriginal = data.buffer;
      case 161:
        cliSiTefResp.numeroIdentificadorCupomPagamento = data.buffer;
      case 200:
        cliSiTefResp.saldoDisponivel = double.parse(data.buffer);
      case 201:
        cliSiTefResp.saldoBloqueado = double.parse(data.buffer);
      case 501:
        cliSiTefResp.tipoDocumentoConsultado = data.buffer;
      case 502:
        cliSiTefResp.numeroDocumento = data.buffer;
      case 504:
        cliSiTefResp.taxaServico = double.tryParse(data.buffer) ?? 0;
      case 505:
        cliSiTefResp.numeroParcelas = int.tryParse(data.buffer) ?? 0;
      case 506:
        cliSiTefResp.dataPreDatado = data.buffer;
      case 507:
        cliSiTefResp.primeiraParcela = data.buffer;
      case 508:
        cliSiTefResp.diasEntreParcelas = int.tryParse(data.buffer) ?? 0;
      case 509:
        cliSiTefResp.mesFechado = data.buffer;
      case 510:
        cliSiTefResp.garantia = data.buffer;
      case 511:
        cliSiTefResp.numeroParcelasCDC = int.tryParse(data.buffer) ?? 0;
      case 512:
        cliSiTefResp.numeroCartaoCreditoDigitado = data.buffer;
      case 513:
        cliSiTefResp.dataVencimentoCartao = data.buffer;
      case 514:
        cliSiTefResp.codigoSegurancaCartao = data.buffer;
      case 515:
        cliSiTefResp.dataTransacaoCanceladaReimpressa = data.buffer;
      case 516:
        cliSiTefResp.numeroDocumentoCanceladoReimpresso = data.buffer;
      case 670:
        cliSiTefResp.dadoPinPad = data.buffer;
      case 950:
        cliSiTefResp.cnpjCredenciadoraNFCE = data.buffer;
      case 951:
        cliSiTefResp.bandeiraNFCE = data.buffer;
      case 952:
        cliSiTefResp.numeroAutorizacaoNFCE = data.buffer;
      case 953:
        cliSiTefResp.codigoCredenciadoraSAT = data.buffer;
      case 1002:
        cliSiTefResp.dataValidadeCartao = data.buffer;
      case 1003:
        cliSiTefResp.nomePortadorCartao = data.buffer;
      case 1190:
        cliSiTefResp.ultimosQuatroDigitosCartao = data.buffer;
      case 1321:
        cliSiTefResp.nsuHostAutorizadorTransacaoCancelada = data.buffer;
      case 4153:
        cliSiTefResp.codigoPSP = data.buffer;
    }
    _dataStream.sink.add(data);
  }
}
