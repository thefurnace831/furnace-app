import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:furnace_app/welcome.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'api/room.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  static const List<String> _genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];

  static const List<String> _ethnicityOptions = [
    'American Indian/Alaska Native',
    'Asian',
    'Black or African American',
    'Hispanic/Latino',
    'Native Hawaiian/Pacific Islander',
    'White',
    'Two or more races',
    'Prefer not to say',
  ];

  static const List<String> _relationOptions = [
    'Parent',
    'Guardian',
    'Sibling',
    'Spouse',
    'Grandparent',
    'Other',
  ];

  static final _emailRegex = RegExp(r'^[\w\.\-\+]+@[\w\.\-]+\.\w{2,}$');

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _eCname = TextEditingController();
  final TextEditingController _eCphone = TextEditingController();

  final FocusNode _idFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _schoolFocus = FocusNode();
  final FocusNode _eCnameFocus = FocusNode();
  final FocusNode _eCphoneFocus = FocusNode();

  String? _gender;
  String? _ethnicity;
  String? _ecRelation;
  DateTime? _birthdate;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _submitting = false;

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _numberController.dispose();
    _schoolController.dispose();
    _birthdateController.dispose();
    _eCname.dispose();
    _eCphone.dispose();

    _idFocus.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _numberFocus.dispose();
    _schoolFocus.dispose();
    _eCnameFocus.dispose();
    _eCphoneFocus.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    final base = _requiredValidator(value, 'Email');
    if (base != null) return base;
    if (!_emailRegex.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _phoneValidator(String? value, String fieldName) {
    final base = _requiredValidator(value, fieldName);
    if (base != null) return base;
    final digits = value!.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10 ? null : 'Enter a 10-digit phone number';
  }

  String? _passwordValidator(String? value) {
    final base = _requiredValidator(value, 'Password');
    if (base != null) return base;
    if (value!.length < 8) return 'At least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Include an uppercase letter';
    if (!RegExp(r'\d').hasMatch(value)) return 'Include a number';
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    return value == _passwordController.text ? null : 'Passwords do not match';
  }

  InputDecoration _inputDecoration(
    String label, {
    String? hint,
    IconData? icon,
    Widget? suffix,
    String? helper,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      prefixIcon: icon == null ? null : Icon(icon),
      suffixIcon: suffix,
    );
  }

  void _focusNext(FocusNode next) => FocusScope.of(context).requestFocus(next);

  String _formatDate(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickBirthdate() async {
    final now = DateTime.now();
    final initial = _birthdate ?? DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: now,
    );
    if (picked == null) return;
    setState(() {
      _birthdate = picked;
      _birthdateController.text = _formatDate(picked);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_submitting,
      child: Scaffold(
        appBar: AppBar(title: const Text('Create account')),
        body: FurnaceBackground(
          pattern: true,
          child: FurnaceContent(
            maxWidth: 720,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
            child: AutofillGroup(
              child: FurnacePanel(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const FurnaceBrandHeader(
                        title: 'New Member Registration',
                        subtitle: 'The Furnace',
                        logoWidth: 220,
                      ),
                      const SizedBox(height: 24),
                      const FurnaceSectionHeader(
                        title: 'Student details',
                        icon: Icons.assignment_ind_outlined,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _idController,
                        focusNode: _idFocus,
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _focusNext(_nameFocus),
                        validator: (v) => _requiredValidator(v, 'Student ID'),
                        decoration: _inputDecoration(
                          'Student ID Number',
                          hint: 'StudentId',
                          icon: Icons.badge_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        style: const TextStyle(color: Colors.black),
                        textCapitalization: TextCapitalization.words,
                        autofillHints: const [AutofillHints.name],
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _focusNext(_emailFocus),
                        validator: (v) {
                          final base = _requiredValidator(v, 'Name');
                          if (base != null) return base;
                          if (v!.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          'First & Last Name',
                          icon: Icons.person_outline,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _focusNext(_passwordFocus),
                        validator: _emailValidator,
                        decoration: _inputDecoration(
                          'Email',
                          icon: Icons.email_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        style: const TextStyle(color: Colors.black),
                        obscureText: !_passwordVisible,
                        autofillHints: const [AutofillHints.newPassword],
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            _focusNext(_confirmPasswordFocus),
                        validator: _passwordValidator,
                        decoration: _inputDecoration(
                          'Password',
                          icon: Icons.lock_outline,
                          helper: 'Min 8 characters, 1 uppercase, 1 number',
                          suffix: IconButton(
                            icon: Icon(_passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(
                                () => _passwordVisible = !_passwordVisible),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        style: const TextStyle(color: Colors.black),
                        obscureText: !_confirmPasswordVisible,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _focusNext(_numberFocus),
                        validator: _confirmPasswordValidator,
                        decoration: _inputDecoration(
                          'Confirm Password',
                          icon: Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(_confirmPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(() =>
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _numberController,
                        focusNode: _numberFocus,
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.phone,
                        autofillHints: const [
                          AutofillHints.telephoneNumberNational
                        ],
                        inputFormatters: [_UsPhoneFormatter()],
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _focusNext(_schoolFocus),
                        validator: (v) => _phoneValidator(v, 'Phone number'),
                        decoration: _inputDecoration(
                          'Phone number',
                          hint: '123-456-7890',
                          icon: Icons.phone_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _ethnicity,
                        isExpanded: true,
                        validator: (v) => _requiredValidator(v, 'Ethnicity'),
                        items: _ethnicityOptions
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _ethnicity = v),
                        decoration: _inputDecoration(
                          'Ethnicity',
                          icon: Icons.groups_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _schoolController,
                        focusNode: _schoolFocus,
                        style: const TextStyle(color: Colors.black),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _focusNext(_eCnameFocus),
                        validator: (v) => _requiredValidator(v, 'School name'),
                        decoration: _inputDecoration(
                          'School name',
                          hint: 'School',
                          icon: Icons.school_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _gender,
                        isExpanded: true,
                        validator: (v) => _requiredValidator(v, 'Gender'),
                        items: _genderOptions
                            .map((g) =>
                                DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (v) => setState(() => _gender = v),
                        decoration: _inputDecoration(
                          'Gender',
                          icon: Icons.wc_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _birthdateController,
                        readOnly: true,
                        onTap: _pickBirthdate,
                        style: const TextStyle(color: Colors.black),
                        validator: (v) => _requiredValidator(v, 'Birthdate'),
                        decoration: _inputDecoration(
                          'Birthdate',
                          icon: Icons.cake_outlined,
                          suffix: const Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 18),
                      const FurnaceSectionHeader(
                        title: 'Emergency contact',
                        icon: Icons.health_and_safety_outlined,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _eCname,
                        focusNode: _eCnameFocus,
                        style: const TextStyle(color: Colors.black),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => _focusNext(_eCphoneFocus),
                        validator: (v) {
                          final base =
                              _requiredValidator(v, 'Emergency contact name');
                          if (base != null) return base;
                          if (v!.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          'First & Last Name',
                          icon: Icons.person_outline,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _eCphone,
                        focusNode: _eCphoneFocus,
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [_UsPhoneFormatter()],
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).unfocus(),
                        validator: (v) =>
                            _phoneValidator(v, 'Emergency contact phone'),
                        decoration: _inputDecoration(
                          'Phone Number',
                          hint: '123-456-7890',
                          icon: Icons.phone_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _ecRelation,
                        isExpanded: true,
                        validator: (v) => _requiredValidator(v, 'Relation'),
                        items: _relationOptions
                            .map((r) =>
                                DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: (v) => setState(() => _ecRelation = v),
                        decoration: _inputDecoration(
                          'Relation',
                          icon: Icons.family_restroom_outlined,
                        ),
                      ),
                      const SizedBox(height: 32),
                      FilledButton.icon(
                        onPressed: _submitting ? null : registerAccount,
                        icon: _submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.person_add_alt_1_rounded),
                        label: Text(
                          _submitting ? 'Creating account' : 'Create account',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*
  Adds an account to the parse database with the given fields.
  The email supplied by the user is assigned to the object's username
  to enforce unique emails and allow for duplicate names.
  */
  Future<void> registerAccount() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final user = ParseUser(email, password, email);
    user.set('fullName', _nameController.text.trim());
    user.set('studentId', _idController.text.trim());
    user.set(
        'phoneNumber', _numberController.text.replaceAll(RegExp(r'\D'), ''));
    user.set('ethnicity', _ethnicity);
    user.set('schoolName', _schoolController.text.trim());
    user.set('gender', _gender);
    user.set('birthday', _birthdateController.text);
    final ecParts = _eCname.text.trim().split(RegExp(r'\s+'));
    user.set('ecFirstName', ecParts.first);
    user.set(
        'ecLastname', ecParts.length > 1 ? ecParts.sublist(1).join(' ') : '');
    user.set('ecRelation', _ecRelation);
    user.set('ecPhone', _eCphone.text.replaceAll(RegExp(r'\D'), ''));

    try {
      final response = await user.signUp();

      // Allow admins to view/edit info
      final acl = ParseACL();
      acl.setReadAccess(userId: "role:Admin", allowed: true);
      acl.setWriteAccess(userId: "role:Admin", allowed: true);
      user.setACL(acl);
      await user.save();

      if (!mounted) return;

      if (!response.success) {
        _showError(response.error?.message ?? 'Sign-up failed');
        return;
      }

      await user.login();
      if (!mounted) return;

      TextInput.finishAutofillContext();

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, _, child) => ScaleTransition(
            alignment: Alignment.center,
            scale: animation,
            child: child,
          ),
          pageBuilder: (context, _, __) => WelcomePage(
            false,
            null,
            Room(
              roomId: '',
              roomName: '',
              qrRoomValue: '',
              qrCheckoutValue: '',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _UsPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final capped = digits.length > 10 ? digits.substring(0, 10) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i == 3 || i == 6) buffer.write('-');
      buffer.write(capped[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
