import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mstore/helpers/validators_tile.dart';
import 'package:mstore/models/cart_model.dart';
import 'package:mstore/models/user_model.dart';

class SignupScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final cartModel = CartModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
          child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Nome Completo'),
                  validator: (name) {
                    if (name!.isEmpty)
                      return 'Campo Obrigatório';
                    else if (name.trim().split(' ').length <= 1)
                      return 'Preencha seu nome completo';
                    return null;
                  },
                  onSaved: (name) => name = name),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (email) {
                  if (!emailValid(email!)) return 'E-mail inválido';
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: passController,
                decoration: const InputDecoration(hintText: 'Senha'),
                obscureText: true,
                validator: (pass) {
                  if (pass!.isEmpty || pass.length < 6) {
                    return 'Senha inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: confirmPassController,
                decoration: const InputDecoration(hintText: 'Repita sua Senha'),
                obscureText: true,
                validator: (confirmPass) {
                  if (confirmPass != passController.text) {
                    return 'Senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        disabledBackgroundColor:
                            Theme.of(context).primaryColor.withAlpha(100)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cartModel.signIn(
                            userModel: UserModel(
                                email: emailController.text,
                                password: passController.text,
                                name: nameController.text,
                                confirmPassword: confirmPassController.text),
                            onFail: (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Falha ao entrar: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            onSuccess: () {});
                        ;
                      }
                    },
                    child: const Text(
                      'Criar Conta',
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
