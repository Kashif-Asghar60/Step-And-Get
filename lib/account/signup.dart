// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:step_n_get/account/sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:step_n_get/screens/bottom_navBar.dart';
//
// class SignupScreen extends StatefulWidget {
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   DateTime? selectedDate;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _secondNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _firstNameController.dispose();
//     _secondNameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(
//                 child: SizedBox(
//                   width: 250,
//                   child: Image.asset(
//                     'assets/logo.png',
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: _firstNameController,
//                         decoration: InputDecoration(
//                           labelText: 'First Name',
//                           labelStyle: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 16,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade300),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Please Enter First Name";
//                           } else {
//                             return null;
//                           }
//                         },
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _secondNameController,
//                         decoration: InputDecoration(
//                           labelText: 'Last Name',
//                           labelStyle: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 16,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade300),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Please Enter Last Name";
//                           } else {
//                             return null;
//                           }
//                         },
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _phoneController,
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                           labelText: 'Phone Number',
//                           labelStyle: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 16,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade300),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Please enter a phone number";
//                           } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
//                             return "Please enter a valid phone number";
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           labelText: 'Email ( Optional )',
//                           labelStyle: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 16,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade300),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _passwordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           labelStyle: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 16,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade300),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Please Enter Password";
//                           } else {
//                             return null;
//                           }
//                         },
//                       ),
//                       SizedBox(height: 20),
//                       GestureDetector(
//                         onTap: () => _selectDate(context),
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 10),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   selectedDate != null
//                                       ? DateFormat.yMMMd().format(selectedDate!)
//                                       : 'Date of Birth',
//                                   style: TextStyle(
//                                     color: selectedDate != null
//                                         ? Colors.black
//                                         : Colors.grey[400],
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.calendar_today,
//                                 color: Colors.grey[400],
//                               ),
//                               SizedBox(width: 10),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 40),
//                       Container(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: _signUp,
//                           child: Text(
//                             'Sign Up',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             primary: Colors.orange,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Already have an account?',
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                           SizedBox(width: 5),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => SignInScreen()),
//                               );
//                             },
//                             child: Text(
//                               'Sign In',
//                               style: TextStyle(
//                                 color: Colors.orange,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1500),
//       lastDate: DateTime.now(),
//     );
//
//     if (picked != null && picked != selectedDate) {
//       final DateTime now = DateTime.now();
//       int age = now.year - picked.year;
//
//       if (now.month < picked.month ||
//           (now.month == picked.month && now.day < picked.day)) {
//         // Subtract 1 from the age if the current date is before the birthdate in the current year
//         age--;
//       }
//
//       if (age >= 18) {
//         setState(() {
//           selectedDate = picked;
//         });
//       } else {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Age Validation'),
//               content: Text('You must be 18 years or older to continue.'),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('OK'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     }
//   }
//
//   ///signup
//
//   Future<void> _signUp() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         // Check if user already exists with the provided email
//         final existingUser = await FirebaseAuth.instance
//             .fetchSignInMethodsForEmail(_emailController.text.trim());
//         if (existingUser.isNotEmpty) {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Account Exist'),
//                 content: Text('You already have an account with this email.'),
//                 actions: <Widget>[
//                   TextButton(
//                     child: Text('OK'),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//           return;
//         }
//
//         // Proceed with user registration
//         UserCredential userCredential =
//             await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
//
//         // Save user data to Firestore
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userCredential.user!.uid)
//             .set({
//           'firstName': _firstNameController.text.trim(),
//           'lastName': _secondNameController.text.trim(),
//           'email': _emailController.text.trim(),
//           'dateOfBirth': selectedDate,
//         });
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BottomNavBar(),
//           ),
//         );
//
//         // Navigate to home screen or perform any other actions
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'weak-password') {
//           print('The password provided is too weak.');
//         } else if (e.code == 'email-already-in-use') {
//           print('The account already exists for that email.');
//         }
//         // Handle other FirebaseAuthException errors
//       } catch (e) {
//         print(e.toString());
//         // Handle other exceptions
//       }
//     }
//   }
// }
