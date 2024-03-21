import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RightOptions extends StatefulWidget {
  const RightOptions({super.key});

  @override
  State<RightOptions> createState() => _RightOptionsState();
}

class _RightOptionsState extends State<RightOptions> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      bottom: 60,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedPositioned(
            bottom: isExpanded ? 65 : 0,
            duration: const Duration(milliseconds: 300),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              //backgroundColor: Colors.black.withOpacity(0.8),
              child: SvgPicture.asset(
                'assets/images/svg/microphone.svg',
                height: 22,
                width: 22,
                color: Colors.red,
              ),
            ),
          ),
          AnimatedPositioned(
            bottom: isExpanded ? 130 : 0,
            duration: const Duration(milliseconds: 300),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              //backgroundColor: Colors.black.withOpacity(0.8),
              child: SvgPicture.asset(
                'assets/images/svg/no-video.svg',
                height: 22,
                width: 22,
                color: Colors.red,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: CircleAvatar(
              radius: 28,
              backgroundColor: isExpanded ? Colors.white70 : Colors.grey,
              child: isExpanded
                  ? const Icon(
                      Icons.arrow_circle_down_rounded,
                      color: Colors.red,
                      size: 35,
                    )
                  : const Icon(
                      Icons.arrow_circle_up_rounded,
                      color: Colors.red,
                      size: 35,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
