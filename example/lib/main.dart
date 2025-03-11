import 'dart:developer';

import 'package:clisitef/model/clisitef_configuration.dart';
import 'package:clisitef/model/clisitef_data.dart';
import 'package:clisitef/model/data_events.dart';
import 'package:clisitef/model/modalidade.dart';
import 'package:clisitef/model/pinpad_information.dart';
import 'package:clisitef/model/tipo_pinpad.dart';
import 'package:clisitef/model/transaction.dart';
import 'package:clisitef/model/transaction_events.dart';
import 'package:clisitef/pdv/clisitef_pdv.dart';
import 'package:clisitef/pdv/simulated_pin_pad_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import './dj/dj_sitef_checkout_start.dart';

import 'package:clisitef/clisitef.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _clisitefPlugin = CliSitef.instance;

  late CliSiTefPDV pdv;

  String pinPadInfo = '';

  final bool _isSimulated = false; //Indicate if has PinPad

  TransactionEvents transactionStatus = TransactionEvents.unknown;

  List<String> dataReceived = [];

  String _lastTitle = '';

  String _lastMsgCustomer = '';

  String _lastMsgCashier = '';

  String _lastMsgCashierCustomer = '';

  bool _showAbortButton = false;

  bool _abortTransaction = false;

  @override
  void initState() {
    super.initState();
    CliSiTefConfiguration configuration = CliSiTefConfiguration(
      enderecoSitef: 'intranet5.wbagestao.com',
      codigoLoja: '00000000',
      numeroTerminal: '000009',
      cnpjAutomacao: '05481336000137',
      cnpjLoja: '05481336000137',
      tipoPinPad: TipoPinPad.auto,
      parametrosAdicionais: '',
    );

    pdv = CliSiTefPDV(client: _clisitefPlugin, configuration: configuration, isSimulated: _isSimulated);

    configureCliSitefCallbacks();
  }

  void configureCliSitefCallbacks() {
    pdv.pinPadStream.stream.listen((PinPadInformation event) {
      setState(() {
        PinPadInformation pinPad = event;
        pinPadInfo =
            'isPresent: ${pinPad.isPresent.toString()} \n isBluetoothEnabled: ${pinPad.isBluetoothEnabled.toString()} \n isConnected: ${pinPad.isConnected.toString()} \n isReady: ${pinPad.isReady.toString()} \n event: ${pinPad.event.toString()} ';
      });
    });

    pdv.dataStream.stream.listen((CliSiTefData event) {
      if (kDebugMode) {
        log(event.buffer);
        log(event.event.toString());
      }

      if (event.event == DataEvents.menuTitle) {
        _lastTitle = event.buffer;

        while (true) {}
      }

      if (event.event == DataEvents.messageCashier) {
        _lastMsgCashier = event.buffer;
      }

      if (event.event == DataEvents.messageCustomer) {
        _lastMsgCustomer = event.buffer;
      }

      if (event.event == DataEvents.messageCashierCustomer) {
        _lastMsgCashierCustomer = event.buffer;
      }

      if (event.event == DataEvents.messageQrCode) {
        _lastMsgCashierCustomer = event.buffer;
      }

      if ((event.event == DataEvents.showQrCodeField) || (event.event == DataEvents.removeQrCodeField)) {
        _lastMsgCashierCustomer = event.buffer;
      }

      if (event.event == DataEvents.confirmation) {
        Widget cancelButton = ElevatedButton(
          child: const Text("Cancelar"),
          onPressed: () {
            pdv.client.continueTransaction('0');
            Navigator.of(context).pop();
          },
        );
        Widget continueButton = ElevatedButton(
          child: const Text("Continuar"),
          onPressed: () {
            pdv.client.continueTransaction('1');
            Navigator.of(context).pop();
          },
        );

        AlertDialog alert = AlertDialog(
          title: Text(event.buffer),
          actions: [
            cancelButton,
            continueButton,
          ],
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }

      if (event.event == DataEvents.confirmGoBack) {
        Widget backButton = ElevatedButton(
          child: const Text("Voltar"),
          onPressed: () {
            pdv.client.continueTransaction('1');
            Navigator.of(context).pop();
          },
        );
        Widget confirmeButton = ElevatedButton(
          child: const Text("Confirmar"),
          onPressed: () {
            pdv.client.continueTransaction('0');
            Navigator.of(context).pop();
          },
        );

        AlertDialog alert = AlertDialog(
          title: Text(event.buffer),
          actions: [
            backButton,
            confirmeButton,
          ],
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }

      if (event.event == DataEvents.pressAnyKey) {
        Widget continueButton = ElevatedButton(
          child: const Text("Continuar"),
          onPressed: () {
            pdv.client.continueTransaction('1');
            Navigator.of(context).pop();
          },
        );

        AlertDialog alert = AlertDialog(
          title: Text(event.buffer),
          actions: [
            continueButton,
          ],
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }

      if (event.event == DataEvents.abortRequest) {
        setState(() {
          _showAbortButton = true;
          if (_abortTransaction) {
            //pdv.client.abortTransaction(continua: 1);
            //pdv.client.finishLastTransaction(false);
            //pdv.continueTransaction('0');
            cancelCurrentTransaction();
            _showAbortButton = false;
            _abortTransaction = false;
          } else {
            pdv.continueTransaction('1');
          }
        });
      } else {
        _showAbortButton = false;
      }

      if (event.event == DataEvents.getFieldInternal ||
          event.event == DataEvents.getField ||
          event.event == DataEvents.getFieldBarCode ||
          event.event == DataEvents.getFieldCurrency) {
        showDialog(
            context: context,
            builder: (context) {
              return SimulatedPinPadWidget(
                title: _lastTitle,
                options: event.buffer,
                submit: pdv.continueTransaction,
                cancel: () async {
                  pdv.continueTransaction('-1');
                },
              );
            });
      }

      if (event.event == DataEvents.menuOptions) {
        showDialog(
            context: context,
            builder: (context) {
              List<String> options = event.buffer.split(';');
              return Scaffold(
                appBar: AppBar(
                  title: Text(_lastTitle),
                  automaticallyImplyLeading: false,
                ),
                body: ListView.builder(
                  itemCount: options.length - 1,
                  itemBuilder: (context, index) {
                    final item = options[index].split(':');
                    final opcao = item[0];
                    final descricao = item[1];

                    return ListTile(
                      title: Text(descricao),
                      subtitle: Text(opcao),
                      onTap: () {
                        pdv.continueTransaction(opcao);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              );
            });
      }

      setState(() {});
    });
  }

  void pinpad() async {
    try {
      await pdv.isPinPadPresent();

      setState(() {
        PinPadInformation pinPad = pdv.pinPadStream.pinPadInfo;
        if (pinPad.isPresent) {
          pdv.client.setPinpadDisplayMessage('XPOS - DJSystem');
        }
        pinPadInfo =
            'isPresent: ${pinPad.isPresent.toString()} \n isBluetoothEnabled: ${pinPad.isBluetoothEnabled.toString()} \n isConnected: ${pinPad.isConnected.toString()} \n isReady: ${pinPad.isReady.toString()} \n event: ${pinPad.event.toString()} ';
      });
    } on Exception {
      if (kDebugMode) {
        log('Failed!');
      }
    }
  }

  void transaction() async {
    try {
      setState(() {
        dataReceived = [];
      });
      Stream<Transaction> paymentStream = await pdv.payment(
        Modalidade.vendaCarteiraDigital.value,
        100,
        cupomFiscal: '1',
        dataFiscal: DateTime.now(),
        // restricoes: '[27;28]',
      );

      if (_isSimulated) {
        if (kDebugMode) {
          log('here is simulated');
        }
      }

      paymentStream.listen((Transaction transaction) {
        setState(() {
          transactionStatus = transaction.event ?? TransactionEvents.unknown;
          if (transactionStatus == TransactionEvents.transactionConfirm) {
            dataReceived.add(pdv.cliSitetRespMap[134]!); //Map com todos os campos retornados

            //campos mapeados em propriedades
            dataReceived.add(pdv.cliSiTefResp.nsuHost);
            dataReceived.add(pdv.cliSiTefResp.viaCliente);

            dataReceived.add(pdv.cliSiTefResp.viaEstabelecimento);
          }
        });
      });
    } on Exception catch (e) {
      setState(() {
        transactionStatus = TransactionEvents.transactionError;
      });
      if (kDebugMode) {
        log(e.toString());
      }
    }
  }

  void cancelCurrentTransaction() async {
    try {
      await pdv.client.abortTransaction(continua: 1);
    } on Exception catch (e) {
      if (kDebugMode) {
        log('Cancel!');
        log(e.toString());
      }
    }
  }

  void cancel() async {
    try {
      await pdv.cancelTransaction();
      setState(() {
        dataReceived = [];
      });
    } on Exception catch (e) {
      if (kDebugMode) {
        log('Cancel!');
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: DjSitefCheckout(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ElevatedButton(onPressed: () => pinpad(), child: Text('Verificar presenca pinpad')),
                ElevatedButton(onPressed: () => transaction(), child: Text('Iniciar transacao')),
                Visibility(
                  visible: _showAbortButton,
                  child: ElevatedButton(
                      onPressed: () {
                        _abortTransaction = true;
                      },
                      child: Text('Cancelar transacao atual')),
                ),
                ElevatedButton(onPressed: () => cancel(), child: Text('Cancela ultima transacao')),
                Text("PinPadInfo:"),
                Text(pinPadInfo),
                Text("\n\nTransaction Status:"),
                Text(transactionStatus.name),
                Text("Mensagem Operador:"),
                Text(_lastMsgCashier),
                Text("Mensagem Cliente:"),
                Text(_lastMsgCustomer),
                Text("Mensagem Operador e Cliente:"),
                Text(_lastMsgCashierCustomer),
                Text("\n\nData Received:"),
                Text(dataReceived.join('\n')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
