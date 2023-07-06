import 'package:flutter/material.dart';

class CustomButtons extends StatelessWidget {
  final Function()? onTap;
  final dynamic buttonName;
  const CustomButtons(
      {super.key, required this.onTap, required this.buttonName});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: screenWidth * 3 / 4,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
              color: const Color.fromARGB(119, 234, 62, 50),
              borderRadius: BorderRadius.circular(8)),
          child: Text(buttonName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ))),
    );
  }
}
