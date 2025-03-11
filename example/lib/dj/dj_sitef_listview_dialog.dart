import 'package:flutter/material.dart';

class DjSitefListViewDialog extends StatefulWidget {
  const DjSitefListViewDialog({super.key});

  @override
  State<DjSitefListViewDialog> createState() => _DjSitefListViewDialogState();
}

class _DjSitefListViewDialogState extends State<DjSitefListViewDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).colorScheme.background,
      constraints: BoxConstraints(
        maxWidth: 400,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 60,
                          width: double.maxFinite,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Option $index',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8.0),
            constraints: const BoxConstraints(
              maxWidth: 380,
            ),
            height: 80,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Option fail'),
            ),
          ),
        ],
      ),
    );
  }
}
