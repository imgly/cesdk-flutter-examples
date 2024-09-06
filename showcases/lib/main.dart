import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:showcases/data/examples.dart';
import 'package:showcases/widget/example_item.dart';

import 'widget/header.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMG.LY Editor',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'IMG.LY Editor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    loadExamples();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title:
              Text(widget.title, style: const TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    key: const Key("main_scroll"),
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (context, index) {
                      final item = examples[index];
                      return Column(children: [
                        Header(item.title, item.subtitle),
                        const SizedBox(height: 4),
                        ListView.builder(
                            itemBuilder: (context, index) {
                              final example = item.items[index];
                              return ExampleItem(example,
                                  key: Key(example.title));
                            },
                            itemCount: item.items.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true)
                      ]);
                    },
                    itemCount: examples.length)),
          ],
        ));
  }
}
