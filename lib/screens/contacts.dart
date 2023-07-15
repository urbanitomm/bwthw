import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/utils/mydrawer.dart';
import 'package:progetto_wearable/utils/myappbar.dart';
import 'package:progetto_wearable/utils/funcs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/screens/homepage.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  static const route = '/contacts/';
  static const routename = 'Contacts';
  @override
  ContactState createState() => ContactState();
}

//Since we don't expect patients to have more than a few contacts databases will not be used
//Instead the contacts will be stored in the shared preferences using json encoding

final drRossi = Contacts(0, 'Dottoressa Rossi', '33344455566');
final drVerdi = Contacts(1, 'Dottor Verdi', '36912345678');
final mamma = Contacts(2, 'Mamma', '34587654321');
List<Contacts> telBook = [];
final roles = ['Medic', 'Psychologyst', 'Trusted person'];
var textController1 = TextEditingController();
var textController2 = TextEditingController();

class ContactState extends State<ContactsPage> {
  bool isDarkModeEnabled = false; //default value
  Future<void> loadTheme() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      isDarkModeEnabled = sp.getBool('isDarkModeEnabled') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPref();
    loadTheme();
    print('loaded');
  }

  Future<void> loadPref() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      //Initialization of the address book
      startContacts().then((_) {
        setState(() {
          updateBook().then((telBookNew) {
            setState(() {
              telBook = telBookNew;
            });
          });
        });
      });
    });
  }

  bool? validatorName;
  bool? validatorNumber;
  bool? validatorRole;

  //Alert dialogue that adds a contact
  asyncAddDialog(BuildContext context) async {
    int? codeRole;
    String? name;
    String? number;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String? selectedValue;
        return AlertDialog(
          title: const Text('Add a contact'), // Add a comma here
          content: SizedBox(
            height: 220,
            child: Column(
              children: [
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null) {
                      validatorRole = false; //role not validated
                      return 'Please enter some text';
                    } else {
                      validatorRole = true; //role validated
                      return null;
                    }
                  },
                  value: selectedValue,
                  isDense: true,
                  onSaved: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                      codeRole = roleToCode(selectedValue!);
                    });
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                      codeRole = roleToCode(selectedValue!);
                    });
                  },
                  // Array list of items
                  items: roles.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onChanged: (text) {
                    name = text;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      validatorName = false; //Name not validated
                      return 'Please enter some text';
                    } else if (validateName(name)) {
                      validatorName = false; //Name not validated
                      return 'Invalid name';
                    }
                    validatorName = true; //Name validated
                    return null;
                  },
                  controller: textController1,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    hintText: 'Insert name',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.grey[400],
                      onPressed: () {
                        textController1.clear();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onChanged: (text) {
                    number = text;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (number) {
                    if (number == null || number.isEmpty) {
                      validatorNumber = false; //Number not validated
                      return 'Please enter some text';
                    } else if (validateMobile(number)) {
                      validatorNumber = false; //Number not validated
                      return 'Invalid number';
                    }
                    validatorNumber = true; //Number validated
                    return null;
                  },
                  controller: textController2,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    hintText: 'Insert number',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.grey[400],
                      onPressed: () {
                        textController2.clear();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                //Dismissing the box will clear the informations
                name = null;
                number = null;
                codeRole = null;
                selectedValue = null;
                textController1.clear();
                textController2.clear();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Add contact',
                  style: TextStyle(color: Colors.green)),
              onPressed: () async {
                //Validation checks
                if (codeRole != null &&
                    name != null &&
                    number != null &&
                    validatorName == true &&
                    validatorNumber == true) {
                  final newContact = Contacts(codeRole, name, number);
                  //Update the phone book using set state
                  setState(() {
                    addAddress(newContact).then((_) {
                      setState(() {
                        updateBook().then((telBookNew) {
                          setState(() {
                            telBook = telBookNew;
                          });
                        });
                      });
                    });
                  });
                  //Dismissing the box will clear the informations
                  name = null;
                  number = null;
                  codeRole = null;
                  selectedValue = null;
                  textController1.clear();
                  textController2.clear();
                  Navigator.pop(context);
                }
              },
            )
          ],
        );
      },
    );
  }

  //Alert dialogue that deletes a contact
  asyncDeleteDialog(
      BuildContext context, Contacts delAddress, int index) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete This Contact?'),
          content: const Text('This will delete the contact from your device.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                setState(() {
                  deleteAddress(delAddress, index).then((_) {
                    setState(() {
                      deleteAddress(delAddress, index).then((_) {
                        setState(() {
                          updateBook().then((telBookNew) {
                            setState(() {
                              telBook = telBookNew;
                            });
                          });
                        });
                      });
                    });
                  });
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
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
            drawer: const MyDrawer(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Homepage()));
              },
              child: const Icon(Icons.arrow_back),
            ),
            body: Column(
              children: [
                Expanded(
                  ///  height: 400,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: telBook.length,
                      itemBuilder: (context, index) {
                        final item = telBook[index];
                        return Card(
                          child: ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(vertical: 4),
                            title: Text(
                              item.name!,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            leading: getIcon(item.role!),
                            trailing: IconButton(
                              iconSize: 25,
                              icon: const Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                call(item.number!);
                              },
                            ),
                            onTap: () {
                              //unused
                            },
                            onLongPress: () {
                              setState(() async {
                                await asyncDeleteDialog(
                                    context, telBook[index], index);
                              });
                            },
                          ),
                        );
                      }),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      asyncAddDialog(context);
                    });
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 18,
                    color: Colors.yellow,
                  ),
                  label: const Text("ADD CONTACT",
                      style: TextStyle(fontSize: 20, color: Colors.yellow)),
                ),
              ],
            ))); //build
  } //HomePage
}

class Contacts {
  int? role; // 0=medic, 1=psychologist, 2=trusted person
  String? name;
  String? number;

  Contacts(this.role, this.name, this.number);

  //Conversion to and from String/Contacts using json
  //encoding/decoding to give persistance to the data
  Contacts.fromJson(Map<String, dynamic> json)
      : role = json['role'],
        name = json['name'],
        number = json['number'];

  Map<String, dynamic> toJson() => {
        'role': role,
        'name': name,
        'number': number,
      };
}

//Initializes the contacts the first time
startContacts() async {
  final sp = await SharedPreferences.getInstance();
  //Check if its the first time the contacts are initialized
  if (sp.getBool('initContacts') == null ||
      sp.getBool('initContacts') == false) {
    sp.setBool('initContacts', true);
  }
  //Manually prepopulates the phone book
  if (sp.getInt('nContacts') == null) {
    sp.setInt('nContacts', 3);
    sp.setString('Contact1', json.encode(drRossi));
    sp.setString('Contact2', json.encode(drVerdi));
    sp.setString('Contact3', json.encode(mamma));
    telBook.add(drRossi);
    telBook.add(drVerdi);
    telBook.add(mamma);
  }
  await updateBook();
}

//Updates addresses to the telephone book if the number of contacts changes
updateBook() async {
  final sp = await SharedPreferences.getInstance();
  int nContacts = sp.getInt('nContacts')!;
  //If eliminating the addresses holes appear we can reorganize the shared preferences
  for (int i = 0; i < nContacts; i++) {
    if (sp.getString('Contact${i + 1}') != null &&
        sp.getString('Contact$i') == null) {
      sp.setString('Contact$i', sp.getString('Contact${i + 1}')!);
      sp.remove('Contact${i + 1}');
    }
  }
  //Imports all the addresses from the shared preferences to a list
  List<Contacts> telBooknew = [];
  for (int i = 0; i < nContacts; i++) {
    String nAddress = 'Contact${i.toString()}';
    Contacts newAddress =
        Contacts.fromJson(await json.decode(sp.getString(nAddress)!));
    telBooknew.add(newAddress);
  }
  return telBooknew;
}

//Deletes undesired contacts
deleteAddress(Contacts delAddress, int index) async {
  final sp = await SharedPreferences.getInstance();
  if (telBook.contains(delAddress)) {
    //Change the amount of contacts and remove
    int nNumbers = sp.getInt('nContacts')! - 1;
    sp.setInt('nContacts', nNumbers);
    telBook.remove(delAddress);
    sp.remove('Contact$index');
    await updateBook();
  }
}

//Adds more contacts
addAddress(Contacts addAddress) async {
  final sp = await SharedPreferences.getInstance();
  //Contacts starts from zero so Contact$nNumbers is always available
  int nNumbers = sp.getInt('nContacts')!;
  sp.setString('Contact$nNumbers', json.encode(addAddress));
  sp.setInt('nContacts', nNumbers + 1);
  await updateBook();
}

//Icon retrieval based on the role of the contact
getIcon(int role) {
  double iconSize = 25;
  Icon? roleIcon;
  switch (role) {
    case 0: //medic
      roleIcon = Icon(Icons.medical_services, size: iconSize);
      break;
    case 1: //psychologyst
      roleIcon = Icon(Icons.psychology, size: iconSize);
      break;
    case 2: //trusted person
      roleIcon = Icon(Icons.person, size: iconSize);
      break;
    default:
      roleIcon = Icon(Icons.person, size: iconSize);
  }
  return roleIcon;
}

//Functions for the conversion from/to String and Int
roleToCode(String role) {
  int code = 0;
  if (role == 'Medic') {
    code = 0;
  } else if (role == 'Psychologyst') {
    code = 1;
  } else if (role == 'Trusted person') {
    code = 2;
  }
  return code;
}

codeToRole(int code) {
  String role = 'Medic';
  switch (code) {
    case 0: //medic
      role = 'Medic';
      break;
    case 1: //psychologyst
      role = 'Psychologyst';
      break;
    case 2: //trusted person
      role = 'Trusted person';
      break;
  }
  return role;
}

//Phone number validation
bool validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(pattern);
  if (value.length == 0) {
    return true; //no number
  } else if (!regExp.hasMatch(value)) {
    return true; //invalid number
  }
  return false; //ok
}

bool validateName(String value) {
  String pattern = r'^[A-Z a-z]+$';
  RegExp regExp = RegExp(pattern);
  if (value.length == 0) {
    return true; //no name
  } else if (!regExp.hasMatch(value)) {
    return true; //invalid name
  }
  return false; //ok
}
