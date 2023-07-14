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
// TEST FOR GITHUB

class _ProfileState extends State<Profile> {
  //File? _profilePicture;
  File? profilePicture;
  bool isDarkModeEnabled = false; //default value
  bool isGoogleUser = false;
  String name = '';
  String surname = '';
  String email = '';
  String photoUrl = '';
  String GoogleName = '';
  String GoogleEmail = '';
  String profilePicturePath = '';
  TextEditingController nameController = TextEditingController();
  late TextEditingController googleNameController = TextEditingController();
  late TextEditingController googleEmailController = TextEditingController();
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
      isGoogleUser = sp.getBool('isGoogleUser') ?? false;
      GoogleEmail = sp.getString('Google_email') ?? '';
      GoogleName = sp.getString('Google_name') ?? '';
      photoUrl = sp.getString('photoUrl') ?? '';
      nameController.text = name;
      surnameController.text = surname;
      emailController.text = email;
      profilePicturePath = sp.getString('profilePicture') ?? '';
      googleNameController = TextEditingController(text: GoogleName);
      googleEmailController = TextEditingController(text: GoogleEmail);
      /*if (base64Image != null) {
        final bytes = base64Decode(base64Image);
        _profilePicture = File.fromRawPath(bytes);
      }*/
      if (profilePicturePath != null && profilePicturePath != '') {
        profilePicture =
            File(profilePicturePath.replaceFirst('/', Platform.pathSeparator));
      }
    });
  }

  Future<void> savePref() async {
    print('saving preferences');
    final sp = await SharedPreferences.getInstance();
    sp.setString('name', name);
    sp.setString('surname', surname);
    sp.setString('email', email);
    sp.setBool('isGoogleUser', isGoogleUser);
    sp.setString('photoUrl', photoUrl);
    sp.setString('GoogleName', GoogleName);
    sp.setString('GoogleEmail', GoogleEmail);
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
    final sp = await SharedPreferences.getInstance();
    sp.setString('profilePicture', pickedFile!.path);
    print('saved image path');
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
                    onTap: !isGoogleUser
                        ? () async {
                            final pickedFile = await pickImage();
                            if (pickedFile != null) {
                              setState(() {
                                profilePicture = File(pickedFile.path);
                              });
                            }
                          }
                        : null,
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: isGoogleUser &&
                                photoUrl.isEmpty &&
                                profilePicture != null
                            ? DecorationImage(
                                image: FileImage(profilePicture!),
                                fit: BoxFit.cover,
                              )
                            : (!isGoogleUser && profilePicture != null
                                ? DecorationImage(
                                    image: FileImage(profilePicture!),
                                    fit: BoxFit.cover,
                                  )
                                : (photoUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(photoUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : (profilePicture != null
                                        ? DecorationImage(
                                            image: FileImage(profilePicture!),
                                            fit: BoxFit.cover,
                                          )
                                        : DecorationImage(
                                            image: AssetImage(
                                                'assets/images/img.jpg'),
                                            fit: BoxFit.cover,
                                          )))),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      if (!isGoogleUser)
                        TextField(
                          controller: nameController,
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                          onEditingComplete: () {
                            savePref();
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                        )
                      else
                        TextField(
                            controller: googleNameController,
                            enabled:
                                false, // Set the enabled property to false to make it read-only
                            decoration: InputDecoration(
                              labelText: 'Username Google',
                            )

                            // show the value of GoogleName in the TextField
                            ),
                      const SizedBox(height: 8),
                      if (!isGoogleUser)
                        TextField(
                          controller: surnameController,
                          onChanged: (value) {
                            setState(() {
                              surname = value;
                            });
                          },
                          onEditingComplete: () {
                            savePref();
                          },
                          decoration: InputDecoration(
                            labelText: 'Surname',
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (!isGoogleUser)
                        TextFormField(
                          controller: emailController,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onEditingComplete: () {
                            if (emailController.text.isNotEmpty &&
                                emailController.text.contains('@') &&
                                emailController.text.contains('.')) {
                              setState(() {
                                email = emailController.text;
                              });
                              savePref();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Invalid Email'),
                                    content: Text('Please enter a valid email'),
                                    actions: [
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          emailController.text = email;
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        )
                      else
                        TextField(
                            controller: googleEmailController,
                            enabled:
                                false, // Set the enabled property to false to make it read-only
                            decoration: InputDecoration(
                              labelText: 'Email Google',
                            )),
                      const SizedBox(height: 16),
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
