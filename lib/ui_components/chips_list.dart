import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../app_theme.dart';

class ChipsList extends StatelessWidget {
  final List<String> stringList;
  const ChipsList({Key? key, required this.stringList}) : super(key: key);

  Widget buildChip(String label) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      label: Text( label,
        style: const TextStyle(color: AppTheme.chipsColor, fontSize: 12),
      ),
      backgroundColor: AppTheme.chipsBackgroundColor,
      elevation: 3.0,
      shadowColor: Colors.grey[60],
      padding: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppTheme.chipsColor, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 6.0,
        runSpacing: 3.0,
        children: stringList.map((e) => buildChip(e)).toList());
  }
}