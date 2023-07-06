import 'package:flavorfile/pages/ShareRecipePages/shared_recipe_detail_page.dart';
import 'package:flavorfile/services/food_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:lottie/lottie.dart';

class ShareRecipePage extends StatefulWidget {
  const ShareRecipePage({Key? key}) : super(key: key);

  @override
  State<ShareRecipePage> createState() => _ShareRecipePageState();
}

class _ShareRecipePageState extends State<ShareRecipePage> {
  List<Map<String, dynamic>> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes().then((data) {
      setState(() {
        recipes = data.cast<Map<String, dynamic>>();
        recipes.shuffle();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(recipes);
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(
                child: Lottie.network(
                    "https://assets6.lottiefiles.com/packages/lf20_6yhhrbk6.json"),
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Text(
                                "다른 레시피",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500),
                              ),
                            ],
                          )),
                    ),
                  ),
                  if (recipes.isNotEmpty)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 500,
                        child: CardSwiper(
                          cardsCount: recipes.length,
                          cardBuilder: (context, index, percentThresholdX,
                              percentThresholdY) {
                            final recipe = recipes[index];
                            // print(recipe);
                            final title = recipe['name'];
                            final thumbNail = recipe['thumbnail_url'];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SharedRecipeDetails(
                                                sharedRecipeData: recipe)));
                              },
                              child: Hero(
                                tag: recipe['id'],
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 4,
                                          color: Colors.grey.shade300),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        alignment: FractionalOffset.topCenter,
                                        image: NetworkImage(thumbNail),
                                      )),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Container(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          color: Colors.white,
                                          padding: const EdgeInsets.fromLTRB(
                                              30, 30, 30, 30),
                                          child: Text(title,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                ],
              ),
      ),
    );
  }
}
