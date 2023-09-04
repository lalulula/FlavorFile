import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flavorfile/pages/MyRecipeBookPages/styles.dart';
import 'package:flavorfile/widgets/custom_appbar.dart';
import 'package:flavorfile/class/ingredients.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final TextEditingController _recipeNameController = TextEditingController();
  final List<Ingredients> _ingredientsList = [];
  final List<String> _howToList = [];
  final List<String> _recipeImageUrls = [];
  final List<XFile> _selectedImages = [];

  String imageURL = "";
  bool _showUploadingDialog = false;

  @override
  void initState() {
    super.initState();
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
        _showUploadingDialog =
            false; // Set the flag to hide the progress indicator
      });
      print(_recipeImageUrls.length);
    } catch (e) {
      print(e);
      setState(() {
        _recipeImageUrls
            .remove(imageURL); // Remove failed upload from _recipeImageUrls
        _showUploadingDialog =
            false; // Set the flag to hide the progress indicator
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
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ..._selectedImages.asMap().entries.map((entry) {
            final index = entry.key;
            final image = entry.value;
            return GestureDetector(
              onTap: () => _deleteImage(index),
              child: SizedBox(
                height: 200,
                width: 150,
                child: Image.file(
                  File(image.path),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
          if (_showUploadingDialog)
            const SizedBox(
              height: 200,
              width: 150,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _saveRecipe() async {
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;

    final recipeData = {
      'recipeName': _recipeNameController.text.trim(),
      'ingredients': _ingredientsList.map((e) {
        return {'ingredient': e.ingredient, 'amount': e.amount};
      }).toList(),
      'order': _howToList,
      'recipeImage': _recipeImageUrls
    };
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Lottie.network(
                  "https://assets10.lottiefiles.com/packages/lf20_R2MChv.json"));
        });
    try {
      final recipeDoc = await FirebaseFirestore.instance
          .collection('recipes')
          .add(recipeData);

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        "recipes": FieldValue.arrayUnion([recipeDoc.id])
      });

      recipeData.clear();
      _recipeNameController.clear();
      _ingredientsList.clear();
      _howToList.clear();
      _recipeImageUrls.clear();
      _selectedImages.clear();
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('레시피 저장'),
          content: const Text('레시피 저장 완료!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
                          child: TextField(
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
                            child: TextField(
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
                            child: TextField(
                              onChanged: (value) {
                                _howToList[index] = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Step $index',
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
                  onPressed: _saveRecipe,
                  child: Text(
                    '레시피북에 추가',
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
