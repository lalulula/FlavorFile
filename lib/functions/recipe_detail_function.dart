import 'package:flutter/material.dart';

imageSlider(image, pagePosition, active, index, recipeId) {
  double margin = active ? 5 : 20;
  return Hero(
    tag: index == 0 ? recipeId! : UniqueKey(),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(image)),
          ),
        ),
      ),
    ),
  );
}

List<Widget> imageIndicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: const EdgeInsets.all(3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black54 : Colors.black12,
          shape: BoxShape.circle),
    );
  });
}

// Future<void> dialogBuilder2(BuildContext context, recipeData) {
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return Dialog(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(25.0))),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Text(
//                   '재료 (총 ${recipeData['ingredients'].length}개)',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyLarge!
//                       .copyWith(fontSize: 20, fontWeight: FontWeight.normal),
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 5, color: Colors.blueAccent)),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Text(
//                           "재료",
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyLarge!
//                               .copyWith(
//                                   fontWeight: FontWeight.bold, fontSize: 25),
//                         ),
//                         Text(
//                           "용량",
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyLarge!
//                               .copyWith(
//                                   fontWeight: FontWeight.bold, fontSize: 25),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 300,
//                       child: ListView.builder(
//                         itemCount: recipeData['ingredients'].length,
//                         itemBuilder: (context, index) {
//                           final ingredient =
//                               recipeData['ingredients'][index]['ingredient'];
//                           final amount =
//                               recipeData['ingredients'][index]['amount'];
//                           return Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Text(
//                                     "$ingredient",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyLarge!
//                                         .copyWith(fontSize: 25),
//                                   ),
//                                   amount == ""
//                                       ? Text(
//                                           "-",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyLarge!
//                                               .copyWith(fontSize: 25),
//                                         )
//                                       : Text(
//                                           "$amount",
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyLarge!
//                                               .copyWith(fontSize: 25),
//                                         )
//                                 ],
//                               )
//                             ],
//                           );
//                           // return ListTile(
//                           //   title: Text(
//                           //     '$ingredient : $amount',
//                           //     textAlign: TextAlign.center,
//                           //   ),
//                           // );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       icon: const Icon(Icons.close))
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

Future<void> dialogBuilder(BuildContext context, recipeData) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  '재료 (총 ${recipeData['ingredients'].length}개)',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
              recipeData['ingredients'].isEmpty
                  ? const Text("재료를 추가해보세요!")
                  : SizedBox(
                      height: 400,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Center(
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(1),
                              },
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '재료',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                              ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '용량',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                for (var index = 0;
                                    index < recipeData['ingredients'].length;
                                    index++)
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              textAlign: TextAlign.center,
                                              '${recipeData['ingredients'][index]['ingredient']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(fontSize: 20)),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: recipeData['ingredients']
                                                        [index]['amount'] ==
                                                    ""
                                                ? const Text(
                                                    "-",
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Text(
                                                    textAlign: TextAlign.center,
                                                    '${recipeData['ingredients'][index]['amount']}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                            fontSize: 20))),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
