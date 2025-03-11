import 'package:flutter/material.dart';

class DjSitefUserCallBackInput extends StatefulWidget {
  const DjSitefUserCallBackInput({super.key});

  @override
  State<DjSitefUserCallBackInput> createState() => _DjSitefUserCallBackInputState();
}

class _DjSitefUserCallBackInputState extends State<DjSitefUserCallBackInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 380,
        maxHeight: 380,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'anything here',
                border: OutlineInputBorder(),
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
                  child: ElevatedButton(
                    child: const Text('Option Error'),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 380,
                  ),
                  height: 60,
                  child: ElevatedButton(
                    child: const Text('Option Sucess'),
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
