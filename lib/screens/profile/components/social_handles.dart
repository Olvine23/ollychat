import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olly_chat/theme/colors.dart';

class SocialHandles extends StatelessWidget {
  final IconData icon;
  final String platform;
  const SocialHandles({
    super.key, required this.icon, required this.platform,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 30,
          color: AppColors.secondaryColor,
        ),
        SizedBox(width: 3.w,),
        Text(platform, style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!.copyWith(color: AppColors.secondaryColor),)
      ],
    );
  }
}
