import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/screens/homepage.dart';
import 'package:path_provider/path_provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static const route = '/profile/';
  static const routeDisplayName = 'ProfilePage';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //File? _profilePicture;
  File? profilePicture;
  bool isDarkModeEnabled = false; //default value
  String name = '';
  String surname = '';
  String email = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  Future<void> loadPref() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      isDarkModeEnabled = sp.getBool('isDarkModeEnabled') ?? false;
      name = sp.getString('name') ?? 'Giacomo';
      surname = sp.getString('surname') ?? 'Cappon';
      email = sp.getString('email') ?? '1234@567.com';
      nameController.text = name;
      surnameController.text = surname;
      emailController.text = email;
      final profilePicturePath = sp.getString('profilePicture');
      /*if (base64Image != null) {
        final bytes = base64Decode(base64Image);
        _profilePicture = File.fromRawPath(bytes);
      }*/
      if (profilePicturePath != null) {
        profilePicture =
            File(profilePicturePath.replaceFirst('/', Platform.pathSeparator));
      }
    });
  }

  Future<void> savePref() async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('name', name);
    sp.setString('surname', surname);
    sp.setString('email', email);
    if (profilePicture != null) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/profile_picture.jpg');
      await file.writeAsBytes(await profilePicture!.readAsBytes());
      sp.setString('profilePicture', file.path);
    }
  }

  Future<XFile?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkModeEnabled
          ? ThemeData(
              brightness: Brightness.dark,
              colorScheme: const ColorScheme.dark(
                primary: Colors.black,
                background: Colors.black,
                onBackground: Colors.black,
                secondary: Colors.yellow,
              ),
            )
          : ThemeData(
              brightness: Brightness.light,
              colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(190, 71, 70, 70),
                background: Color.fromARGB(255, 0, 0, 0),
                onBackground: Colors.white,
                secondary: Colors.yellow,
              ),
            ),
      home: Scaffold(
        appBar: const MyAppbar(),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Homepage()));
          },
          child: const Icon(Icons.arrow_back),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final pickedFile = await pickImage();
                      if (pickedFile != null) {
                        setState(() {
                          profilePicture = File(pickedFile.path);
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: profilePicture != null
                            ? DecorationImage(
                                image: FileImage(profilePicture!),
                                fit: BoxFit.cover)
                            : DecorationImage(
                                image: AssetImage('assets/images/img.jpg'),
                                fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: surnameController,
                        onChanged: (value) {
                          setState(() {
                            surname = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Surname',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          savePref();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
