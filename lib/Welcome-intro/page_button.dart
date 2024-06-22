import 'package:flutter/material.dart';

class PageButton extends StatelessWidget {
  final int currentPage;
  final PageController pageController;
  final Function onNextPressed;

  const PageButton({super.key, 
    required this.currentPage,
    required this.pageController,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (currentPage < 2) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            onNextPressed();
          }
        },
        child: currentPage < 2 ? const Text("Next") : const Text("Get Started"),
      ),
    );
  }
}
