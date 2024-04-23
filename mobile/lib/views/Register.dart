import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/RegisterViewModel.dart';
import 'Menu.dart';
import 'Login.dart';
import 'styles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> with RouteAware {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  bool _showErrorMessage = false;
  bool _passwordsMismatch = false;
  bool _isLoading = false; // Dodaj zmienną do śledzenia stanu ładowania

  late double screenWidth;

  @override
  void initState() {
    super.initState();
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize;
    screenWidth = size.width;
  }

  @override
  void didChangeDependencies() {
    context.read<RegisterViewModel>().reset();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _loginController.clear();
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    context.read<RegisterViewModel>().reset();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _loginController.clear();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    MyStyles.appBarColor,
                    MyStyles.lightestPurple
                  ]
              )
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 40,),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Register",style: TextStyle(color: Colors.white, fontSize: 30),),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyStyles.backgroundColor,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 35,),
                              Container(
                                decoration: BoxDecoration(
                                    color: MyStyles.backgroundColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [BoxShadow(
                                        color: MyStyles.purpleLowOpacity,
                                        blurRadius: 20,
                                        offset: const Offset(0,10)
                                    )]
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: const BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.grey))
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: TextField(
                                        controller: _loginController,
                                        decoration: const InputDecoration(
                                          hintText: "Login",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.grey))
                                      ),
                                      child: TextField(
                                        controller: _emailController,
                                        decoration: const InputDecoration(
                                          hintText: "Email",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                            border: Border(bottom: BorderSide(color: Colors.grey))
                                        ),
                                        child: TextField(
                                          controller: _passwordController,
                                          obscureText: true,
                                          decoration: const InputDecoration(
                                            hintText: "Password",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        )
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(10),
                                        child: TextField(
                                          controller: _confirmPasswordController,
                                          obscureText: true,
                                          decoration: const InputDecoration(
                                            hintText: "Confirm password",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              if (_showErrorMessage || _passwordsMismatch)
                                const SizedBox(height: 35,),
                              if (_showErrorMessage || _passwordsMismatch)
                                Text(
                                  _passwordsMismatch
                                      ? 'Please make sure your password match.'
                                      : 'Add login, password and email',
                                  style: TextStyle(
                                    color: MyStyles.red,
                                    fontSize: 18.0,
                                  ),
                                ),
                              if (_showErrorMessage || _passwordsMismatch)
                                const SizedBox(height: 20,),
                              if (!_showErrorMessage && !_passwordsMismatch)
                                const SizedBox(height: 81,),
                              ElevatedButton(
                                style: MyStyles.buttonStyle,
                                onPressed: _isLoading ? null : () async { // Zablokuj przycisk podczas ładowania
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  String login = _loginController.text;
                                  String email = _emailController.text;
                                  String password = _passwordController.text;
                                  String confirmPassword = _confirmPasswordController.text;

                                  if (email.isEmpty || password.isEmpty || login.isEmpty || confirmPassword.isEmpty) {
                                    setState(() {
                                      _showErrorMessage = true;
                                      _passwordsMismatch = false; // Reset password mismatch error
                                      _isLoading = false;
                                    });
                                  } else if (password == confirmPassword) {
                                    bool isRegistered = await context.read<RegisterViewModel>().register(login, email, password);
                                    if(isRegistered) {
                                      Fluttertoast.showToast(
                                          msg: "Successful registration",
                                          toastLength: Toast.LENGTH_SHORT
                                      );
                                      if(!context.mounted) return;
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const MenuPage())
                                      );
                                    }
                                    setState(() {
                                      _showErrorMessage = false; // Reset error message
                                      _passwordsMismatch = false; // Reset password mismatch error
                                      _isLoading = false;
                                    });
                                  } else {
                                    setState(() {
                                      _passwordsMismatch = true;
                                      _showErrorMessage = false; // Reset error message
                                      _isLoading = false;
                                    });
                                    print('Password mismatch');
                                  }
                                },
                                child: _isLoading
                                    ? CircularProgressIndicator() // Pokaż kółko ładowania podczas ładowania
                                    : const Text(
                                    'Register',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              const Text("Already have an account?"),
                              const SizedBox(height: 8.0),
                              ElevatedButton(
                                  style:MyStyles.buttonStyle,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ))
                              ),
                            ],
                          ),
                        ),
                      )
                  )
                ],
              ),
            ],
          ),
        )

    );
  }
}
