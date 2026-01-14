import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({required this.title, required this.value, super.key});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      title: Text(title),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );
}
