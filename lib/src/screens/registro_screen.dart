import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/helpers/show_alert.dart';
import 'package:flutter_chat_app/src/services/auth_service.dart';
import 'package:flutter_chat_app/src/widgets/Labels.dart';
import 'package:flutter_chat_app/src/widgets/button_custom.dart';
import 'package:flutter_chat_app/src/widgets/input_custom.dart';
import 'package:flutter_chat_app/src/widgets/logo.dart';
import 'package:provider/provider.dart';

class RegistroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            //physics: NeverScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(label: 'Registro',),
                  _LoginForm(),
                  Labels( route: 'login', title: '¿Tienes cuenta?', label: 'Ya tengo una cuenta', ),
                  Text(
                    'Términos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _LoginForm extends StatefulWidget {
  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(children: [
        InputCustom(
          icon: Icons.perm_identity,
          placeholder: 'Nombre',
          textInputType: TextInputType.text,
          textController: _nombreController,
        ),
        InputCustom(
          icon: Icons.mail_outline,
          placeholder: 'Email',
          textInputType: TextInputType.emailAddress,
          textController: _emailController,
        ),
        InputCustom(
          icon: Icons.lock_outline,
          placeholder: 'Contraseña',
          textInputType: TextInputType.text,
          textController: _passwordController,
          isPassword: true,
        ),
        ButtonCustom(
          label: 'Regístrate',
          onPress: authProvider.autenticando ? null : () async {
            final registerResponse = await authProvider.register(_nombreController.text, _emailController.text, _passwordController.text);
            if(registerResponse is bool && registerResponse == true) {
              Navigator.pushReplacementNamed(context, 'usuarios');
            } else {
              showAlert(context, 'Error', registerResponse);
            }
          },
        ),
      ]),
    );
  }
}
