import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mstore/helpers/validators_tile.dart';
import 'package:mstore/models/cart_model.dart';
import 'package:provider/provider.dart';

import '../../models/cart_model.dart';
import '../../models/user_model.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            child: const Text(
              'CRIAR CONTA',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<CartModel>(
              builder: (_, CartModel, __) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      enabled: !CartModel.loading,
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
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
                      enabled: !CartModel.loading,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      autocorrect: false,
                      obscureText: true,
                      validator: (pass) {
                        if (pass!.isEmpty || pass.length < 6) {
                          return 'Senha inválida';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Esqueci minha senha'),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                          onPressed: CartModel.loading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    CartModel.signIn(
                                        userModel: UserModel(
                                            email: emailController.text,
                                            password: passController.text),
                                        onFail: (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Falha ao entrar: $e'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        },
                                        onSuccess: () {
                                          // TODO: FECHAR TELA DE LOGIN
                                        });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withAlpha(100)),
                          child: CartModel.loading
                              ? CircularProgressIndicator()
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(fontSize: 18),
                                )),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
