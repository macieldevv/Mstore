import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:mstore/helpers/firebase_errors.dart';
import 'package:mstore/models/user_model.dart';

class CartModel extends ChangeNotifier {
  CartModel() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  late User user;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> signIn({
    required UserModel userModel,
    required Function onFail,
    required Function onSuccess,
  }) async {
    loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: userModel.email, password: userModel.password);

      user = result.user!;
      onSuccess();
    } on FirebaseException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    final User? currentUser = auth.currentUser;
    if (currentUser != null) {
      user = currentUser;
      print(user.uid);
    }
    notifyListeners();
  }
}
