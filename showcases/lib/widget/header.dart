import 'package:flutter/material.dart';

/// A [Header] is used to display the title of a section.
class Header extends StatelessWidget {
  /// Create a new instance with the given [title] and key.
  const Header(this.title, this.subtitle, {super.key});

  /// The [title] of the header.
  final String title;

  /// The [subtitle] of the header.
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(left: 30, right: 30),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(180, 0, 0, 0)),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(180, 0, 0, 0)),
            ),
          ],
        ));
  }
}
