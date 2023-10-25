import 'package:clisitef_example/dj/dj_sitef_alert_dialog_confirm_cancel.dart';
import 'package:clisitef_example/dj/dj_sitef_listview_dialog.dart';
import 'package:clisitef_example/dj/dj_sitef_qr_code.dart';
import 'package:clisitef_example/dj/dj_sitef_user_callback_input.dart';
import 'package:dj_styles/dj_styles.dart';
import 'package:flutter/material.dart';

class DjSitefCheckout extends StatefulWidget {
  const DjSitefCheckout({super.key});

  @override
  State<DjSitefCheckout> createState() => _DjSitefCheckoutState();
}

class _DjSitefCheckoutState extends State<DjSitefCheckout> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Image.asset('', height: 150,)
            Container(
              height: 150,
              color: Colors.white,
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: Center(
                child: Text(
                  'Image here',
                ),
              ),
            ),
            Text(
              'Event message',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),

            //condicional para carregando
            Visibility(
              visible: isVisible,
              child: SizedBox(
                height: 100,
                width: 100,
                child: DJLoading(
                    size: 1,
                    color: Theme.of(context).primaryColor,
                    shadowColor: Theme.of(context).primaryColorLight),
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                maxWidth: 380,
              ),
              height: 60,
              child: DjElevatedButton(
                label: 'CANCELAR',
                textColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.error,
                borderColor: Theme.of(context).colorScheme.error,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: DjSitefUserCallBackInput(),
                      );
                    },
                  );
                },
              ),
            ),
            //remove this after test
            Wrap(
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: DjSitefAlertDialogConfirmCancel(),
                        );
                      },
                    );
                  },
                  child: Text('Alert Dialog'),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: DjSitefListViewDialog(),
                        );
                      },
                    );
                  },
                  child: Text('ListView Dialog'),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: DjSitefQrCodeView(),
                        );
                      },
                    );
                  },
                  child: Text('Qr code dialog'),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: DjSitefUserCallBackInput(),
                        );
                      },
                    );
                  },
                  child: Text('Input dialog'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  child: Text('Event loading'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
