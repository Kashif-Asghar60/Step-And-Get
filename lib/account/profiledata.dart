import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../provider/pointsprovider.dart';

class ProfileData extends StatefulWidget {
  @override
  State<ProfileData> createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? selectedDate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    _fetchAndPopulateProfileData();
  }

  Future<void> _fetchAndPopulateProfileData() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> profileSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('profile')
              .doc(uid)
              .get();

      if (profileSnapshot.exists) {
        Map<String, dynamic> profileData = profileSnapshot.data()!;
        _firstNameController.text = profileData['firstName'] ?? '';
        _secondNameController.text = profileData['lastName'] ?? '';
        _emailController.text = profileData['email'] ?? '';
        _phoneController.text = profileData['phone'] ?? '';
        String? dateOfBirthString = profileData['dateOfBirth'];
        if (dateOfBirthString != null && dateOfBirthString.isNotEmpty) {
          setState(() {
            selectedDate = DateTime.parse(dateOfBirthString);
          });
        }
      }
    } catch (error) {
      print('Error fetching profile data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 250,
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _editMode ? _buildEditMode() : _buildViewMode(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewMode() {
    return Column(
      children: [
        // Display the profile data
        TextFormField(
          readOnly: true,
          controller: _firstNameController,
          decoration: InputDecoration(
            labelText: 'First Name',
          ),
        ),
        TextFormField(
          readOnly: true,
          controller: _secondNameController,
          decoration: InputDecoration(
            labelText: 'Last Name',
          ),
        ),
        TextFormField(
          readOnly: true,
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
          ),
        ),
        TextFormField(
          readOnly: true,
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
          ),
        ),
        if (selectedDate != null)
          Text(
            'Date of Birth: ${DateFormat.yMMMd().format(selectedDate!)}',
          ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _editMode = true;
            });
          },
          child: Text('Update Profile'),
        ),
      ],
    );
  }

  Widget _buildEditMode() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter First Name";
              } else {
                return null;
              }
            },
          ),
          TextFormField(
            controller: _secondNameController,
            decoration: InputDecoration(
              labelText: 'Last Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter Last Name";
              } else {
                return null;
              }
            },
          ),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter a phone number";
              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return "Please enter a valid phone number";
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email ( Optional ) Get extra 10 points ',
            ),
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? DateFormat.yMMMd().format(selectedDate!)
                          : 'Date of Birth',
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _uploadData();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1500),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      final DateTime now = DateTime.now();
      int age = now.year - picked.year;

      if (now.month < picked.month ||
          (now.month == picked.month && now.day < picked.day)) {
        age--;
      }

      if (age >= 18) {
        setState(() {
          selectedDate = picked;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Age Validation'),
              content: Text('You must be 18 years or older to continue.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _uploadData() async {
    String uid = _auth.currentUser!.uid;
    if (_formKey.currentState!.validate()) {
      String? email = _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim();
      String? phone = _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim();

      Map<String, dynamic> updatedData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _secondNameController.text.trim(),
        'dateOfBirth': selectedDate.toString(),
      };

      if (email != null) {
        updatedData['email'] = email;
      }
      if (phone != null) {
        updatedData['phone'] = phone;
      }

      DocumentReference profileDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('profile')
          .doc(uid);

      bool profileDocExists = (await profileDocRef.get()).exists;

      await profileDocRef
          .set(updatedData, SetOptions(merge: true))
          .then((_) async {
        if (email != null && !profileDocExists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('points')
              .add({
            'emailBonusPoints': 10,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
        await context.read<PointsProvider>().updatePoints(uid, 10);
        Fluttertoast.showToast(
          msg: "Data updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {
          _editMode = false;
        });
      }).catchError((error) {
        Fluttertoast.showToast(
          msg: "Error updating data",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      Fluttertoast.showToast(
        msg: "Please fill in all required fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
