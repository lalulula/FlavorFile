import 'package:flutter/material.dart';

class RecipeToEdit extends StatelessWidget {
  const RecipeToEdit({
    super.key,
    required this.recipeName,
  });

  final recipeName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(150, 20, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.menu),
            Container(
                padding: const EdgeInsets.all(10), child: Text(recipeName)),
          ],
        ),
      ),
    );
  }
}
