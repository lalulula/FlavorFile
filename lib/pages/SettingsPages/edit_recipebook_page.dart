import 'package:flavorfile/services/setting_services.dart';
import 'package:flutter/material.dart';

class EditRecipeBook extends StatefulWidget {
  const EditRecipeBook({Key? key}) : super(key: key);

  @override
  State<EditRecipeBook> createState() => _EditRecipeBookState();
}

class _EditRecipeBookState extends State<EditRecipeBook> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchUserRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "레시피를 불러오는데 에러가 발생했습니다. 잠시 후에 다시 시도해 주세요",
              ),
            );
          } else if (snapshot.hasData) {
            final recipes = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                final recipeName = recipe['recipeName'];
                return Text(recipeName);
              },
            );
          } else {
            return const Center(
              child: Text("레시피를 찾을 수 없습니다."),
            );
          }
        },
      ),
    );
  }
}
