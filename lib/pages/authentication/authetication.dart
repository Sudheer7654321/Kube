import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication biometric_auth = LocalAuthentication();
  Future<void> signup({
    required String email,
    required String password,
    required String phone,
    required String name,
  }) async {
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          password.isNotEmpty &&
          name.isNotEmpty) {
        if (password.length > 8) {
          if (phone.length == 10) {
            UserCredential cred = await _auth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
            if (cred.user != null) {
              await _firestore.collection('users').doc(cred.user!.uid).set({
                'username': name,
                'phone': phone,
                'email': email,
              });
            }
          } else {
            throw 'Enter valid number';
          }
        } else {
          throw 'Password is too short';
        }
      } else {
        throw 'Enter every field';
      }
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      throw e.message ?? 'An Unknown error occured';
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      if (password.isNotEmpty && email.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
      } else {
        throw 'Enter every field';
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      throw e.message ?? 'An Unknown error occured';
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> _authenticate() async {
    try {
      bool didAuthenticate = await biometric_auth.authenticate(
        localizedReason: 'Please authenticate to access this feature',
        options: AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );
    } catch (e) {
      rethrow;
    }
  }
}
