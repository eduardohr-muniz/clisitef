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
              child: const Center(
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
              child: const SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                maxWidth: 380,
              ),
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const Dialog(
                        child: Text('DjSitefUserCallBackInput()'),
                      );
                    },
                  );
                },
                child: const Text('CANCELAR'),
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
                        return const Dialog(
                          child: Text("DjSitefAlertDialogConfirmCancel()"),
                        );
                      },
                    );
                  },
                  child: const Text('Alert Dialog'),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Dialog(
                          child: Text("DjSitefListViewDialog()"),
                        );
                      },
                    );
                  },
                  child: const Text('ListView Dialog'),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Dialog(
                          child: Text("DjSitefQrCodeView()"),
                        );
                      },
                    );
                  },
                  child: const Text('Qr code dialog'),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Dialog(
                          child: Text("DjSitefUserCallBackInput()"),
                        );
                      },
                    );
                  },
                  child: const Text('Input dialog'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  child: const Text('Event loading'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
