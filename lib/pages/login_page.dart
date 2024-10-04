import 'package:flutter/material.dart';

import 'home_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final _formKey= GlobalKey<FormState>();
  final _userNameController= TextEditingController();
  final _passwordController= TextEditingController();
  //boleen pour mot de passe visible et invisible(sufixIcon)
  bool _isObscured = true;

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUserName( String? value){
    if(value == null || value.isEmpty){
      return "Le nom est obligatoire";
    }
    return null;
  }

  String? _validatePassword( String? value){
    if(value == null || value.isEmpty){
      return "Le mot de passe est obligatoire";
    }
    final passwordRegExp= RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'
    );
    if (!passwordRegExp.hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins 8 caractères,\n une majuscule, une minuscule, un chiffre et un caractère\n spécial';
    }
    return null;

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(
            child:  Text(widget.title,
              style: const TextStyle(
                fontSize: 37,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Veuillez remplir le formulaire de connexion",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration:  InputDecoration(
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      prefixIcon: Icon(Icons.person),
                      labelText: "Entrer votre nom",
                      hintText: "nom",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    validator: _validateUserName,
                    controller: _userNameController,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      labelText: "Entrer votre mot de passe",
                      hintText: "mot de passe",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                ),
                
               Container(
                 margin: const EdgeInsets.all(10),
                 height: 50,
                 width: double.infinity,
                 child:  ElevatedButton(
                   style: ButtonStyle(
                       backgroundColor: const WidgetStatePropertyAll(Colors.blue),
                       shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                   ),
                   onPressed: (){

                     if(_formKey.currentState!.validate()){
                       final username= _userNameController.text;
                       final password= _passwordController.text;

                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text("connexion en cours..."),),
                       );

                       Navigator.push(
                           context,
                           PageRouteBuilder(
                               pageBuilder: (_, __, ___,)=> const HomePage()
                           )
                       );
                     }

                   },
                   child:const Text("se connecter",
                     style: TextStyle(
                         color: Colors.white,
                         fontWeight: FontWeight.w600,
                         fontSize: 23,
                     ),
                   ),
                 ),
               )
              ],
            ),
          ),
        )
    );
  }
}












