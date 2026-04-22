import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _eCname = TextEditingController();
  final TextEditingController _eCphone = TextEditingController();

  String? _gender;
  String? _ethnicity;
  String? _ecRelation;
  DateTime? _birthdate;

  ParseUser? _user;
  bool _loading = true;
  bool _saving = false;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    _schoolController.dispose();
    _birthdateController.dispose();
    _eCname.dispose();
    _eCphone.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user == null) {
      if (!mounted) return;
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _user = user;
      _hydrateFromUser(user);
      _loading = false;
    });
  }

  void _hydrateFromUser(ParseUser user) {
    _emailController.text = user.emailAddress ?? user.username ?? '';
    _nameController.text = user.get<String>('fullName') ?? '';
    _idController.text = user.get<String>('studentId') ?? '';
    _numberController.text =
        _formatPhoneForDisplay(user.get<String>('phoneNumber') ?? '');
    _schoolController.text = user.get<String>('schoolName') ?? '';
    final ecFirst = user.get<String>('ecFirstName') ?? '';
    final ecLast = user.get<String>('ecLastname') ?? '';
    _eCname.text = [ecFirst, ecLast]
        .where((s) => s.trim().isNotEmpty)
        .join(' ')
        .trim();
    _eCphone.text = _formatPhoneForDisplay(user.get<String>('ecPhone') ?? '');

    _gender =
        _safeDropdownValue(user.get<String>('gender'), _genderOptions);
    _ethnicity =
        _safeDropdownValue(user.get<String>('ethnicity'), _ethnicityOptions);
    _ecRelation =
        _safeDropdownValue(user.get<String>('ecRelation'), _relationOptions);

    final birthdayRaw = user.get<String>('birthday') ?? '';
    _birthdate = _parseBirthday(birthdayRaw);
    _birthdateController.text =
        _birthdate != null ? _formatDate(_birthdate!) : '';
  }

  String? _safeDropdownValue(String? raw, List<String> options) {
    if (raw == null || raw.trim().isEmpty) return null;
    return options.contains(raw) ? raw : null;
  }

  DateTime? _parseBirthday(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(trimmed);
    if (iso != null) {
      final y = int.tryParse(iso.group(1)!);
      final m = int.tryParse(iso.group(2)!);
      final d = int.tryParse(iso.group(3)!);
      if (y != null && m != null && d != null) {
        try {
          return DateTime(y, m, d);
        } catch (_) {}
      }
    }

    final us = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(trimmed);
    if (us != null) {
      final m = int.tryParse(us.group(1)!);
      final d = int.tryParse(us.group(2)!);
      final y = int.tryParse(us.group(3)!);
      if (y != null && m != null && d != null) {
        try {
          return DateTime(y, m, d);
        } catch (_) {}
      }
    }
    return null;
  }

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  String _formatPhoneForDisplay(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';
    final capped = digits.length > 10 ? digits.substring(0, 10) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i == 3 || i == 6) buffer.write('-');
      buffer.write(capped[i]);
    }
    return buffer.toString();
  }

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

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _phoneValidator(String? value, String fieldName) {
    final base = _requiredValidator(value, fieldName);
    if (base != null) return base;
    final digits = value!.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10 ? null : 'Enter a 10-digit phone number';
  }

  InputDecoration _inputDecoration(
    String label, {
    String? hint,
    IconData? icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: icon == null ? null : Icon(icon),
      suffixIcon: suffix,
      filled: !_editing,
      fillColor: _editing ? null : Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: _editing ? Colors.black : Colors.grey.shade400),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Account')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          if (_editing)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Cancel',
              onPressed: _saving ? null : _cancelEdit,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _idController,
                readOnly: !_editing,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
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
                readOnly: !_editing,
                style: const TextStyle(color: Colors.black),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
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
                readOnly: !_editing,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  final base = _requiredValidator(v, 'Email');
                  if (base != null) return base;
                  if (!_emailRegex.hasMatch(v!.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                decoration: _inputDecoration(
                  'Email',
                  icon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numberController,
                readOnly: !_editing,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.phone,
                inputFormatters: [_UsPhoneFormatter()],
                textInputAction: TextInputAction.next,
                validator: (v) => _phoneValidator(v, 'Phone number'),
                decoration: _inputDecoration(
                  'Phone number',
                  hint: '123-456-7890',
                  icon: Icons.phone_outlined,
                ),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Ethnicity',
                icon: Icons.groups_outlined,
                value: _ethnicity,
                options: _ethnicityOptions,
                onChanged: (v) => setState(() => _ethnicity = v),
                validator: (v) => _requiredValidator(v, 'Ethnicity'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _schoolController,
                readOnly: !_editing,
                style: const TextStyle(color: Colors.black),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (v) => _requiredValidator(v, 'School name'),
                decoration: _inputDecoration(
                  'School name',
                  hint: 'School',
                  icon: Icons.school_outlined,
                ),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Gender',
                icon: Icons.wc_outlined,
                value: _gender,
                options: _genderOptions,
                onChanged: (v) => setState(() => _gender = v),
                validator: (v) => _requiredValidator(v, 'Gender'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthdateController,
                readOnly: true,
                onTap: _editing ? _pickBirthdate : null,
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
              const SizedBox(height: 8),
              const Text(
                'Emergency Contact',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _eCname,
                readOnly: !_editing,
                style: const TextStyle(color: Colors.black),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
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
                readOnly: !_editing,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.phone,
                inputFormatters: [_UsPhoneFormatter()],
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    _phoneValidator(v, 'Emergency contact phone'),
                decoration: _inputDecoration(
                  'Phone Number',
                  hint: '123-456-7890',
                  icon: Icons.phone_outlined,
                ),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Relation',
                icon: Icons.family_restroom_outlined,
                value: _ecRelation,
                options: _relationOptions,
                onChanged: (v) => setState(() => _ecRelation = v),
                validator: (v) => _requiredValidator(v, 'Relation'),
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _saving ? null : _showChangePasswordDialog,
                icon: const Icon(Icons.lock_outline, color: Colors.red),
                label: const Text(
                  'Change password',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        tooltip: _editing ? 'Save changes' : 'Edit',
        onPressed: _saving ? null : _onFabPressed,
        child: _saving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(_editing ? Icons.check : Icons.edit),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    required FormFieldValidator<String> validator,
  }) {
    return IgnorePointer(
      ignoring: !_editing,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        validator: validator,
        items: options
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: onChanged,
        decoration: _inputDecoration(label, icon: icon),
      ),
    );
  }

  void _onFabPressed() {
    if (_editing) {
      _saveChanges();
    } else {
      setState(() => _editing = true);
    }
  }

  void _cancelEdit() {
    final user = _user;
    setState(() {
      _editing = false;
      if (user != null) _hydrateFromUser(user);
    });
    _formKey.currentState?.reset();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    final user = _user;
    if (user == null) return;

    setState(() => _saving = true);

    final email = _emailController.text.trim();
    user.emailAddress = email;
    user.username = email;

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

    final response = await user.save();

    if (!mounted) return;
    setState(() {
      _saving = false;
      if (response.success) {
        _editing = false;
      }
    });

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account updated')),
      );
    } else {
      showError(response.error?.message ?? 'Unable to update account');
    }
  }

  Future<void> _showChangePasswordDialog() async {
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();
    bool submitting = false;

    OutlineInputBorder roundedBorder({Color color = Colors.black}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color),
      );
    }

    try {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (dialogContext, setDialogState) {
              return AlertDialog(
                title: const Text('Change password'),
                content: Form(
                  key: dialogFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: newPassCtrl,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'New password',
                          border: roundedBorder(),
                          enabledBorder: roundedBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'New password is required';
                          }
                          if (v.length < 8) return 'At least 8 characters';
                          if (!RegExp(r'[A-Z]').hasMatch(v)) {
                            return 'Include an uppercase letter';
                          }
                          if (!RegExp(r'\d').hasMatch(v)) {
                            return 'Include a number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: confirmPassCtrl,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Confirm password',
                          border: roundedBorder(),
                          enabledBorder: roundedBorder(),
                        ),
                        validator: (v) {
                          if (v != newPassCtrl.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: submitting
                        ? null
                        : () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: submitting
                        ? null
                        : () async {
                            if (!dialogFormKey.currentState!.validate()) {
                              return;
                            }
                            final user = _user;
                            if (user == null) return;

                            setDialogState(() => submitting = true);
                            user.password = newPassCtrl.text.trim();
                            final response = await user.save();
                            if (!mounted) return;
                            setDialogState(() => submitting = false);

                            if (response.success) {
                              Navigator.of(dialogContext).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Password updated')),
                              );
                            } else {
                              showError(response.error?.message ??
                                  'Unable to update password');
                            }
                          },
                    child: submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Update',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      newPassCtrl.dispose();
      confirmPassCtrl.dispose();
    }
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error!'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
