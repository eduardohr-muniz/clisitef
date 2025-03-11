import 'package:flutter/material.dart';

class DjSitefQrCodeView extends StatefulWidget {
  const DjSitefQrCodeView({super.key});

  @override
  State<DjSitefQrCodeView> createState() => _DjSitefQrCodeViewState();
}

class _DjSitefQrCodeViewState extends State<DjSitefQrCodeView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 380,
        maxHeight: MediaQuery.sizeOf(context).height * 0.6,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 70,
                color: Theme.of(context).primaryColorLight,
                child: Center(
                  child: Text(
                    'Event message here',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                // QrImageView(
                //   data: 'event qr code data todo here',
                //   size: 300,
                // ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 10,
              left: 10,
              right: 10,
            ),
            constraints: const BoxConstraints(
              maxWidth: 380,
            ),
            height: 60,
            child: ElevatedButton(
              child: const Text('Option Success'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
