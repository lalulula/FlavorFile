// import 'dart:convert';

// import 'package:http/http.dart' as http;

// Future<List<Map<String, dynamic>>> fetchRecipes() async {
//   const apiKey = '35647f78d9msheab090fd61dff7ep131422jsn59e83faaf79b';
//   final url = Uri.parse('https://tasty.p.rapidapi.com/recipes/list');

//   final response = await http.get(url, headers: {'X-RapidAPI-Key': apiKey});

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     final recipes = data['results'];
//     return List<Map<String, dynamic>>.from(recipes);
//   } else {
//     throw Exception('Failed to fetch recipes');
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchRecipes({int count = 40}) async {
  const apiKey = '35647f78d9msheab090fd61dff7ep131422jsn59e83faaf79b';
  final url = Uri.parse(
      'https://tasty.p.rapidapi.com/recipes/list?from=0&size=$count&random=true');

  final response = await http.get(url, headers: {'X-RapidAPI-Key': apiKey});

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final recipes = data['results'];
    return List<Map<String, dynamic>>.from(recipes);
  } else {
    throw Exception('Failed to fetch recipes');
  }
}
