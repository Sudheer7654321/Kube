import 'package:flutter/material.dart';

class LinkPage extends StatefulWidget {
  final uri;
  const LinkPage({super.key, required this.uri});

  @override
  State<LinkPage> createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(child: Column(children: [Text(widget.uri)])),
    );
  }
}
