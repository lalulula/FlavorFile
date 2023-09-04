import 'package:flutter/material.dart';

class OtherAuthentication extends StatelessWidget {
  const OtherAuthentication({
    super.key,
    required this.screenWidth,
    required this.imagePath,
    required this.btnText,
    this.authFunction,
  });
  final String imagePath;
  final String btnText;
  final Function()? authFunction;

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: authFunction,
      child: Container(
          width: screenWidth * 3 / 4,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 30,
              ),
              const SizedBox(width: 15),
              Text(btnText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      )),
            ],
          )),
    );
  }
}
