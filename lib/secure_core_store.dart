import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

/// CoreStore backed by flutter_secure_storage.
///
/// Values land in the iOS Keychain and Android EncryptedSharedPreferences
/// (backed by the hardware Keystore), instead of the plaintext
/// shared_preferences store the Parse SDK uses by default.
///
/// flutter_secure_storage only holds strings, so each value is wrapped in a
/// JSON envelope tagging its original type so it can be read back correctly.
class SecureCoreStore implements CoreStore {
  SecureCoreStore._(this._storage);

  static SecureCoreStore? _instance;

  static Future<SecureCoreStore> getInstance() async {
    _instance ??= SecureCoreStore._(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
      ),
    );
    return _instance!;
  }

  final FlutterSecureStorage _storage;

  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException {
      // Android can invalidate the encryption key if the user resets device
      // credentials or on some OEM upgrade paths. Wipe and start over rather
      // than throwing on every launch.
      await _storage.deleteAll();
      return null;
    }
  }

  Future<void> _writeEnvelope(String key, String type, dynamic value) {
    return _storage.write(
      key: key,
      value: jsonEncode({'t': type, 'v': value}),
    );
  }

  Future<Map<String, dynamic>?> _readEnvelope(String key) async {
    final raw = await _safeRead(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  @override
  Future<bool> containsKey(String key) => _storage.containsKey(key: key);

  @override
  Future<dynamic> get(String key) async {
    final env = await _readEnvelope(key);
    if (env == null) return null;
    switch (env['t']) {
      case 'l':
        return (env['v'] as List).cast<String>();
      default:
        return env['v'];
    }
  }

  @override
  Future<bool?> getBool(String key) async =>
      (await _readEnvelope(key))?['v'] as bool?;

  @override
  Future<int?> getInt(String key) async =>
      (await _readEnvelope(key))?['v'] as int?;

  @override
  Future<double?> getDouble(String key) async {
    final v = (await _readEnvelope(key))?['v'];
    if (v == null) return null;
    return (v as num).toDouble();
  }

  @override
  Future<String?> getString(String key) async =>
      (await _readEnvelope(key))?['v'] as String?;

  @override
  Future<List<String>?> getStringList(String key) async {
    final v = (await _readEnvelope(key))?['v'];
    if (v == null) return null;
    return (v as List).cast<String>();
  }

  @override
  Future<dynamic> setBool(String key, bool value) =>
      _writeEnvelope(key, 'b', value);

  @override
  Future<dynamic> setInt(String key, int value) =>
      _writeEnvelope(key, 'i', value);

  @override
  Future<dynamic> setDouble(String key, double value) =>
      _writeEnvelope(key, 'd', value);

  @override
  Future<dynamic> setString(String key, String value) =>
      _writeEnvelope(key, 's', value);

  @override
  Future<dynamic> setStringList(String key, List<String> values) =>
      _writeEnvelope(key, 'l', values);

  @override
  Future<dynamic> remove(String key) => _storage.delete(key: key);

  @override
  Future<dynamic> clear() => _storage.deleteAll();
}
