import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorfile/pages/SettingsPages/settings_styles.dart';
import 'package:flavorfile/services/user_services.dart';
import 'package:flutter/material.dart';

class EditUserInfo extends StatefulWidget {
  const EditUserInfo({Key? key}) : super(key: key);

  @override
  State<EditUserInfo> createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
  final TextEditingController _userNameController = TextEditingController();
  String initUsername = '';
  String email = '';
  String noRecipe = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final userData = await fetchUserData() as Map<String, dynamic>;
      setState(() {
        initUsername = userData['username'];
        _userNameController.text = initUsername;
        email = userData['email'].toString();
        noRecipe = userData['recipes'].length.toString();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void _editUserInfo() {
    final user = FirebaseAuth.instance.currentUser!.uid;

    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user)
          .update({'username': _userNameController.text.trim()});
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(content: Text("사용자 정보가 업데이트 되었습니다!"));
          });
    } catch (e) {
      print("Error updating userdata $e");
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/default_profile.jpg',
                    height: 200,
                    width: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: screenWidth * 3 / 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 3, color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("사용자 이름", style: dataIndicatorStyle),
                          TextFormField(
                            controller: _userNameController,
                            // decoration: const UnderlineInputBorder(),
                          ),
                          const Divider(thickness: 1),
                          Text("이메일", style: disabledDataIndicatorStyle),
                          const SizedBox(height: 5),
                          Text(email, style: disabledDataTextStyle),
                          const Divider(thickness: 1),
                          Text("레시피 개수", style: disabledDataIndicatorStyle),
                          const SizedBox(height: 5),
                          Text(noRecipe, style: disabledDataTextStyle),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: btnStyle,
                  onPressed: _editUserInfo,
                  child: Text(
                    "저장하기",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
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
