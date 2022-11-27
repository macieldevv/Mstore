import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  UserModel(
      {required this.email,
      required this.password,
      this.name,
      this.confirmPassword});

  String? name;
  String email;
  String password;
  String? confirmPassword;
}
