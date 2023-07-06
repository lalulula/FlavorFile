import 'package:flavorfile/pages/MyRecipeBookPages/recipe_details_page.dart';
import 'package:flutter/material.dart';

class RecipeCover extends StatefulWidget {
  const RecipeCover({
    super.key,
    required this.recipeData,
    required this.recipeId,
  });

  final Map<String, dynamic> recipeData;
  final String recipeId;

  @override
  State<RecipeCover> createState() => _RecipeCoverState();
}

class _RecipeCoverState extends State<RecipeCover> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RecipeDetailPage(
                  recipeData: widget.recipeData, recipeId: widget.recipeId),
              fullscreenDialog: true),
        );
      },
      child: SizedBox(
        width: 300,
        height: 400,
        child: Hero(
          tag: widget.recipeId,
          child: Container(
            decoration: BoxDecoration(
              image: widget.recipeData['recipeImage'].length != 0
                  ? DecorationImage(
                      image: NetworkImage(widget.recipeData['recipeImage'][0]),
                      fit: BoxFit.cover,
                      opacity: 0.5)
                  : const DecorationImage(
                      image: AssetImage('assets/images/linenote.jpg'),
                      fit: BoxFit.cover,
                      opacity: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 3, color: Colors.black12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  widget.recipeData['recipeName'],
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 40, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(
                  '총 재료 ${widget.recipeData['ingredients'].length}개',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
