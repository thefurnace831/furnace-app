import 'package:flutter/material.dart';
import 'package:furnace_app/welcome.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/room.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _ethnicityController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _eClastName = TextEditingController();
  final TextEditingController _eCfirstName = TextEditingController();
  final TextEditingController _eCrelation = TextEditingController();
  final TextEditingController _eCphone = TextEditingController();

  static final _emailRegex = RegExp(r'^[\w\.\-\+]+@[\w\.\-]+\.\w{2,}$');
  static final _digitsOnly = RegExp(r'^\d+$');
  static final _dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      labelText: label,
      hintText: hint ?? label,
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Furnace Registration Page"),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/logo.png',
                    height: 150, width: 200, fit: BoxFit.fitWidth)),

            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _idController,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration("Student Id Number", hint: "StudentId"),
                            validator: (value) {
                              final base = _requiredValidator(value, 'Student ID');
                              if (base != null) return base;
                              if (!_digitsOnly.hasMatch(value!.trim())) {
                                return 'Student ID must contain only digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.black),
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration("First & Last Name"),
                            validator: (value) {
                              final base = _requiredValidator(value, 'Name');
                              if (base != null) return base;
                              if (value!.trim().length < 2) {
                                return 'Name must be at least 2 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration("Email"),
                            validator: (value) {
                              final base = _requiredValidator(value, 'Email');
                              if (base != null) return base;
                              if (!_emailRegex.hasMatch(value!.trim())) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.black),
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration("Password"),
                            validator: (value) {
                              final base = _requiredValidator(value, 'Password');
                              if (base != null) return base;
                              if (value!.trim().length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _numberController,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration("Phone number", hint: "1234567890"),
                            validator: (value) {
                              final base = _requiredValidator(value, 'Phone number');
                              if (base != null) return base;
                              final digits = value!.replaceAll(RegExp(r'\D'), '');
                              if (digits.length != 10) {
                                return 'Phone number must be 10 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _ethnicityController,
                            style: const TextStyle(color: Colors.black),
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration("Ethnicity"),
                            validator: (value) => _requiredValidator(value, 'Ethnicity'),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _schoolController,
                            style: const TextStyle(color: Colors.black),
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration("School name", hint: "School"),
                            validator: (value) => _requiredValidator(value, 'School name'),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _genderController,
                            style: const TextStyle(color: Colors.black),
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration("Gender"),
                            validator: (value) => _requiredValidator(value, 'Gender'),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _birthdateController,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.datetime,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration("Birthdate", hint: "MM/DD/YYYY"),
                            validator: (value) {
                              final base = _requiredValidator(value, 'Birthdate');
                              if (base != null) return base;
                              if (!_dateRegex.hasMatch(value!.trim())) {
                                return 'Use format MM/DD/YYYY';
                              }
                              final parts = value.trim().split('/');
                              final month = int.tryParse(parts[0]) ?? 0;
                              final day = int.tryParse(parts[1]) ?? 0;
                              final year = int.tryParse(parts[2]) ?? 0;
                              if (month < 1 || month > 12 || day < 1 || day > 31 || year < 1900) {
                                return 'Enter a valid date';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _eCfirstName,
                            style: const TextStyle(color: Colors.black),
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration("Emergency contact first name"),
                            validator: (value) => _requiredValidator(value, 'Emergency contact first name'),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _eClastName,
                            style: const TextStyle(color: Colors.black),
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration("Emergency Contact Last Name"),
                            validator: (value) => _requiredValidator(value, 'Emergency contact last name'),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _eCphone,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration("Emergency Contact Phone Number", hint: "1234567890"),
                            validator: (value) {
                              final base = _requiredValidator(value, 'Emergency contact phone');
                              if (base != null) return base;
                              final digits = value!.replaceAll(RegExp(r'\D'), '');
                              if (digits.length != 10) {
                                return 'Phone number must be 10 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _eCrelation,
                            style: const TextStyle(color: Colors.black),
                            textInputAction: TextInputAction.done,
                            decoration: _inputDecoration("Emergency Contact Relation"),
                            validator: (value) => _requiredValidator(value, 'Emergency contact relation'),
                          ),
                          const SizedBox(height: 30),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FilledButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    registerAccount();
                                  },
                                  child: const Text('Sign Up',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ]),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /*
  Adds an account to the parse database with the given fields
  Note that the email supplied by the user is actually assigned to the object's username
  This is to enforce unique emails and allow for duplicate names
  */
  void registerAccount() async {
    if (!_formKey.currentState!.validate()) return;

    final studentId = _idController.text.trim();
    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final number = _numberController.text.trim();
    final ethnicity = _ethnicityController.text.trim();
    final school = _schoolController.text.trim();
    final gender = _genderController.text.trim();
    final birthday = _birthdateController.text.trim();
    final ecLastname = _eClastName.text.trim();
    final ecFirstName = _eCfirstName.text.trim();
    final ecRelation = _eCrelation.text.trim();
    final ecPhone = _eCphone.text.trim();

    final user = ParseUser(email, password, email);
    user.set('fullName', fullName);
    user.set('studentId', studentId);
    user.set('phoneNumber', number);
    user.set('ethnicity', ethnicity);
    user.set('schoolName', school);
    user.set('gender', gender);
    user.set('birthday', birthday);
    user.set('ecLastname', ecLastname);
    user.set('ecFirstName', ecFirstName);
    user.set('ecRelation', ecRelation);
    user.set('ecPhone', ecPhone);

    var response = await user.signUp();

    if (response.success) {
      await user.login();

      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('email', email);
      sharedPreferences.setString('pass', password);
      sharedPreferences.setString('fullName', fullName);
      sharedPreferences.setString('number', number);
      sharedPreferences.setString('studentId', studentId);
      sharedPreferences.setString('ethnicity', ethnicity);
      sharedPreferences.setString('school', school);
      sharedPreferences.setBool('loggedIn', true);

      if (!mounted) return;
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, animationTime, child) {
            return ScaleTransition(
              alignment: Alignment.center,
              scale: animation,
              child: child,
            );
          },
          pageBuilder: (context, animation, animationTime) {
            return WelcomePage(
                false,
                null,
                Room(
                    roomId: '',
                    roomName: '',
                    qrRoomValue: '',
                    qrCheckoutValue: ''));
          },
        ),
      );
    } else {
      showError(response.error!.message);
    }
  }
}
