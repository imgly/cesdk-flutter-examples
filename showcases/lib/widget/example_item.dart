import 'package:flutter/material.dart';
import 'package:showcases/model/example.dart';

/// An [ExampleItem] is used to display an [Example].
class ExampleItem extends StatelessWidget {
  /// Create a new instance with the given [example] and [key].
  const ExampleItem(this.example, {super.key});

  /// The represented [Example].
  final Example example;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: example.example.invoke,
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
          padding:
              const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 242, 242, 242)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              example.title,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(example.description, style: const TextStyle(fontSize: 12))
          ]),
        ));
  }
}
