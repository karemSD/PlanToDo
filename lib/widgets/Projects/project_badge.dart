import 'package:flutter/material.dart';

import '../../Values/values.dart';

class ColouredProjectBadge extends StatelessWidget {
  const ColouredProjectBadge({
    Key? key,
    required this.projeImagePath,
  }) : super(key: key);
  final String projeImagePath;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.network(projeImagePath));
  }
}
