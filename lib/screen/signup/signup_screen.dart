import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel/provider/auth_provider.dart';

import '../login/login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final privateKeyController = TextEditingController();
  final walletAddressController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Sign Up"),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(21.0),
                    child: Icon(
                      Icons.person_add_alt_1,
                      size: 100,
                      color: Colors.blue.shade500,
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        Text(
                          "  First Name-",
                          style: TextStyle(
                              fontFamily: "Poppins", color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: firstNameController,
                        validator: validateString,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter First Name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        Text(
                          "  Last Name-",
                          style: TextStyle(
                              fontFamily: "Poppins", color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: lastNameController,
                        validator: validateString,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Last Name",
                          prefixIcon: Icon(
                            Icons.person_2_outlined,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        Text(
                          "  Phone no-",
                          style: TextStyle(
                              fontFamily: "Poppins", color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: emailController,
                        validator: validateString,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Phone No-",
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        Text(
                          "  Wallet Addrress-",
                          style: TextStyle(
                              fontFamily: "Poppins", color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: walletAddressController,
                        validator: validateString,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Wallet Address",
                          prefixIcon: Icon(
                            Icons.wallet,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        Text(
                          "  Private Key-",
                          style: TextStyle(
                              fontFamily: "Poppins", color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: privateKeyController,
                        validator: validateString,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Private Key",
                          prefixIcon: Icon(
                            Icons.key_outlined,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade500,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500,
                        elevation: 5,
                        shadowColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      onPressed: isLoading
                          ? null
                          : () => createAccount(context, authProvider),
                      child: Text(
                        isLoading ? "Please Wait..." : "Create Account",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            wordSpacing: 2,
                            color: Colors.black54,
                            fontFamily: "Poppins"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account ?",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontFamily: "Montserrat"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue.withOpacity(0.4),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validateString(String? value) {
    if (value!.isEmpty) {
      return 'This field should not be empty';
    } else {
      return null;
    }
  }

  Future<void> createAccount(
      BuildContext contest, AuthProvider authProvider) async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      String email = emailController.text.trim();
      String privateKey = privateKeyController.text.trim();
      String walletAddress = walletAddressController.text.trim();

      try {
        await authProvider.signUp(
          firstName: firstName,
          lastName: lastName,
          email: email,
          metamaskPrivateKey: privateKey,
          metamaskWalletAddress: walletAddress,
        );
        if (mounted) Navigator.pushReplacementNamed(context, '/');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Unable to create account!,check your details and try again.'),
        ));
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
