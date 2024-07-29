import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialHandles extends StatelessWidget {
  final IconData icon;
  final String platform;
   final String url;
  const SocialHandles({
    super.key,
    required this.icon,
    required this.platform, required this.url,
  });
  
   Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        _launchURL(url);
      },
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: AppColors.secondaryColor,
          ),
          SizedBox(
            width: 3.w,
          ),
          Text(
            platform,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: AppColors.secondaryColor),
          ),
          Text("handle goes here ")
        ],
      ),
    );
  }
}
