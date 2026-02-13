import 'package:expedia/pages/home/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/social_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome To Our App",
          style: TextStyle(color: Colors.blueAccent),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock, size: 84, color: Colors.blue),
            SizedBox(height: 20.0),
            SocialButton(
              text: "Sign in with Google",
              asset: "assets/images/google.png",
              onPressed: () {},
            ),

            const SizedBox(height: 20),
            const Center(child: Text("or")),

            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 400.0,
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Enter your Email",
                          prefixIcon: Icon(Icons.email),
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter email";
                          } else if (!GetUtils.isEmail(value)) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: 400.0,
                      child: Obx(
                        () => TextFormField(
                          controller: passwordController,
                          obscureText: authController.obscureText.value,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            labelText: "Password",
                            hintText: "******",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                authController.obscureText.value
                                    ? Icons
                                          .visibility_off // hidden → show "off"
                                    : Icons.visibility, // visible → show "on"
                              ),
                              onPressed: authController.toggleVisibility,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter valid password";
                            } else if (value.length < 6) {
                              return "Minimum 6 characters";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authController.login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        }
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Center(child: Text("Other ways to sign in")),

                    const SizedBox(height: 16),

                    SocialButton(
                      text: "Sign in with Facebook",
                      asset: "assets/images/facebook.png",
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
