import 'package:supplysync/utils/encryption_mgmt.dart';
import 'package:supplysync/utils/pass_reader.dart';

class AppSecurity {
  static Future<String> passwordCheck(String password) async {
    final Map<String, dynamic> encryptedPvtKey = PrivateKeyReader.keyReader();
    final String key  = await AesGcmEncryption.decrypt(encryptedPvtKey, password);
    return key;
  }
}