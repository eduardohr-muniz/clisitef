import 'package:dj_styles/dj_styles.dart';
import 'package:flutter/material.dart';

class DjSitefAlertDialogConfirmCancel extends StatefulWidget {
  const DjSitefAlertDialogConfirmCancel({super.key});

  @override
  State<DjSitefAlertDialogConfirmCancel> createState() =>
      _DjSitefAlertDialogState();
}

class _DjSitefAlertDialogState extends State<DjSitefAlertDialogConfirmCancel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 380,
        maxHeight: 280,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 380,
                  ),
                  height: 60,
                  child: DjElevatedButton(
                    label: 'Option Error',
                    textColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.error,
                    borderColor: Theme.of(context).colorScheme.error,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 380,
                  ),
                  height: 60,
                  child: DjElevatedButton(
                    label: 'Option Sucess',
                    textColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    borderColor: Theme.of(context).primaryColor,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
