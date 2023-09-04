// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flavorfile/pages/MyRecipeBookPages/styles.dart';
import 'package:flavorfile/widgets/custom_appbar.dart';
import 'package:flavorfile/class/ingredients.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditRecipePage extends StatefulWidget {
  const EditRecipePage(
      {super.key, required this.initialRecipeData, this.recipeId});
  final Map<String, dynamic> initialRecipeData;
  final String? recipeId;

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final TextEditingController _recipeNameController = TextEditingController();
  final List<Ingredients> _ingredientsList = [];
  final List<String> _howToList = [];
  final List<String> _recipeImageUrls = [];
  final List<XFile> _selectedImages = [];
  bool isHovered = false;

  String imageURL = "";
  bool _showUploadingDialog = false; // Add this line

  @override
  void initState() {
    super.initState();
    _recipeNameController.text = widget.initialRecipeData['recipeName'] ?? " ";
    List<Map<String, dynamic>> initialIngredients =
        List<Map<String, dynamic>>.from(
            widget.initialRecipeData['ingredients']);
    _ingredientsList.addAll(initialIngredients.map((ingredient) => Ingredients(
        ingredient: ingredient['ingredient'], amount: ingredient['amount'])));

    _howToList.addAll(
      List<String>.from(widget.initialRecipeData['order']),
    );

    _recipeImageUrls.addAll(
      List<String>.from(widget.initialRecipeData['recipeImage']),
    );
    for (var imageUrl in _recipeImageUrls) {
      final file = XFile(imageUrl);
      _selectedImages.add(file);
    }
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    setState(() {
      _ingredientsList.add(Ingredients(ingredient: '', amount: ''));
    });
    print(_ingredientsList.length);
  }

  void _addSteps() {
    setState(() {
      _howToList.add("");
    });
  }

  Future<void> _selectAndUploadImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('${file?.path}');
    if (file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child("recipe-images");

    Reference referenceImageForUpload =
        referenceDirImages.child(uniqueFileName);

    setState(() {
      _showUploadingDialog = true;
    });

    try {
      await referenceImageForUpload.putFile(File(file.path));
      imageURL = await referenceImageForUpload.getDownloadURL();
      setState(() {
        _recipeImageUrls.add(imageURL);
        _selectedImages.add(file); // Add selected image to _selectedImages
        _showUploadingDialog = false;
      });
      print(_recipeImageUrls.length);
    } catch (e) {
      print(e);
      setState(() {
        _recipeImageUrls
            .remove(imageURL); // Remove failed upload from _recipeImageUrls
        _showUploadingDialog = false;
      });
    }
  }

  void _deleteImage(int index) {
    // print(index);
    // print(_selectedImages);
    // print(_recipeImageUrls);
    setState(() {
      _selectedImages.removeAt(index);
      _recipeImageUrls.removeAt(index);
    });
  }

  Widget _buildSelectedImages() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _recipeImageUrls.length + (_showUploadingDialog ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _recipeImageUrls.length) {
            final imageURL = _recipeImageUrls[index];

            return GestureDetector(
              onTap: () => _deleteImage(index),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 200,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(imageURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 200,
              width: 150,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _editRecipe() async {
    print(widget.initialRecipeData);
    final updatedRecipeData = {
      'recipeName': _recipeNameController.text.trim(),
      'ingredients': _ingredientsList.map((e) {
        return {'ingredient': e.ingredient, 'amount': e.amount};
      }).toList(),
      'order': _howToList,
      'recipeImage': _recipeImageUrls
    };
    print(updatedRecipeData);
    try {
      FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.recipeId)
          .update(updatedRecipeData);
      Navigator.pop(context, updatedRecipeData);
    } catch (e) {
      print("error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  returnPage: '레시피 정보',
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _recipeNameController,
                      decoration: InputDecoration(
                        hintText: "레시피 이름",
                        focusedBorder: focusedBorderStyle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "재료",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _addIngredient,
                      child: Text(
                        "재료 추가하기",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 15,
                            ),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _ingredientsList.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            initialValue: _ingredientsList[index].ingredient,
                            onChanged: (value) {
                              _ingredientsList[index].ingredient = value;
                            },
                            decoration: InputDecoration(
                              hintText: "재료",
                              focusedBorder: focusedBorderStyle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: _ingredientsList[index].amount,
                              onChanged: (value) {
                                _ingredientsList[index].amount = value;
                              },
                              decoration: InputDecoration(
                                hintText: "용량",
                                focusedBorder: focusedBorderStyle,
                              ),
                            )),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _ingredientsList.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete_outline_rounded))
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "순서",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _addSteps,
                      child: Text(
                        "순서 추가하기",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 15,
                            ),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _howToList.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _howToList[index],
                              onChanged: (value) {
                                _howToList[index] = value;
                              },
                              decoration: InputDecoration(
                                labelText: "",
                                focusedBorder: focusedBorderStyle,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _howToList.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                          )
                        ],
                      );
                    }),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "이미지",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _selectAndUploadImage,
                      child: Text(
                        "이미지 추가하기",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 15,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSelectedImages(),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.indigo.shade200),
                  ),
                  onPressed: _editRecipe,
                  child: Text(
                    ' 레시피 업데이트',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
