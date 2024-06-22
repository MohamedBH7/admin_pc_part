import 'package:flutter/material.dart';

class PageIndicatorRow extends StatelessWidget {
  final int currentPage;
  final int totalPageCount;

  const PageIndicatorRow({super.key, 
    required this.currentPage,
    required this.totalPageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        totalPageCount,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: currentPage == index ? 15.0 : 5.0,
          height: 190.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}
