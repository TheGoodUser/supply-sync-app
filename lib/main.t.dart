

import 'dart:convert';

import 'package:supplysync/utils/encryption_mgmt.dart';
import 'package:supplysync/utils/pass_reader.dart';

void main() async {
  const password = "123456";
  final encryptedPvtKey = await PrivateKeyReader.keyReader();

  final decrypted = await AesGcmEncryption.decrypt(encryptedPvtKey, password);
  print("Decrypted text: $decrypted");
}
