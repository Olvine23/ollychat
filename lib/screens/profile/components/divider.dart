import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Divider(
      thickness: 0.2,
    );
  }
}
