import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel/provider/auth_provider.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final walletAddressController = TextEditingController();
  final privateKeyController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Log In"),
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
                        Icons.account_circle_rounded,
                        size: 150,
                        color: Colors.blue.shade500,
                      ),
                    ),
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          Text(
                            "  Wallet Address-",
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: walletAddressController,
                          validator: validateString,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            // label: const Text(
                            //   "Wallet Address",
                            //   style: TextStyle(fontFamily: "Poppins"),
                            // ),
                            border: InputBorder.none,
                            hintText: "Enter your wallet address",
                            prefixIcon: Icon(
                              Icons.wallet_outlined,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          cursorColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: privateKeyController,
                          validator: validateString,
                          obscureText: true,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            // label: const Text(
                            //   "Private Key",
                            //   style: TextStyle(fontFamily: "Poppins"),
                            // ),
                            border: InputBorder.none,
                            hintText: "Enter your private key",
                            prefixIcon: Icon(
                              Icons.key_sharp,
                              color: Colors.black.withOpacity(0.6),
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
                            : () => loginUser(context, authProvider),
                        child: Text(
                          isLoading ? "Please Wait..." : "Log In",
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              wordSpacing: 2,
                              color: Color.fromARGB(255, 244, 241, 241),
                              fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account ?",
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
                                context, SignupScreen.routeName);
                          },
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                              color: Colors.blue.withOpacity(0.4),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ]),
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

  void loginUser(BuildContext context, AuthProvider authProvider) async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String walletAddress = walletAddressController.text.trim();
      String privateKey = privateKeyController.text.trim();

      try {
        await authProvider.loginIfUserExist(walletAddress, privateKey);
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Unable to login, Check your account details'),
        ));
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
