import 'package:flutter/material.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/util/dimension.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({required this.title, required this.onTap, super.key});
  final VoidCallback onTap;
  final String title;
  @override
  Widget build(BuildContext context) => InkWell(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: onTap,
    child: SizedBox(
      height: 50,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: context.color.black),
          borderRadius: Dimension.rAll18,
        ),
        child: Center(child: Text(title, style: context.textTheme.workSansW500s18)),
      ),
    ),
  );
}
