import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

class KeyManager {
  static ed.KeyPair generateKeyPair() {
    return ed.generateKey();
  }

  static Uint8List sign(List<int> privateKey, String message) {
    Uint8List bytes = Uint8List.fromList(utf8.encode(message));
    return ed.sign(ed.PrivateKey(privateKey), bytes);
  }

  static String sha256(List<int> input) {
    final digest = crypto.sha256.convert(input);
    return digest.toString();
  }
}
