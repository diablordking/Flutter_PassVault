import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import '../../provider/authprovider.dart';
import '../../utils/utils.dart';
import '../../widgets/customelevatedbutton.dart';
import '../homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController(text: 'Abc123456@');
  final GlobalKey<FormState> _loginformKey = GlobalKey<FormState>();
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Passwords must have at least one special character'),
  ]);
  
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<AuthProvider>(
        builder: (BuildContext context, provider, Widget? child) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic) =>
            Utils(context).onWillPop(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                ),
                child: Form(
                  key: _loginformKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      SvgPicture.asset(
                        'assets/secure_login.svg',
                        height: size.height * 0.2,
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Text(
                        'Enter master password and login',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      TextFormField(
                        obscureText: provider.isObsecured,
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        validator: passwordValidator,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: InkWell(
                            child: Icon(
                              provider.isObsecured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onTap: () {
                              provider.isObsecured = !provider.isObsecured;
                            },
                          ),
                        ),
                      ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : CustomElevatedButton(
                              ontap: () {
                                FocusManager.instance.primaryFocus!.unfocus();
                                validate(passwordController.text.trim());
                              },
                              buttontext: 'Login',
                            ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Text(
                        'Once you save a password in NepPass. you\'ll '
                        'always have it when you need it. logging in is fast '
                        'and easy.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void validate(String password) async {
    final FormState form = _loginformKey.currentState!;
    if (form.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        // Check if this is the first login (no master password set yet)
        if (authProvider.masterpassword.isEmpty) {
          // Set the master password for the first time
          authProvider.savePassword(password: password);
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else {
          // Verify the password against the stored hash
          final isValid = await authProvider.verifyMasterPassword(password);
          if (isValid) {
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else {
            setState(() {
              _errorMessage = 'Incorrect master password';
            });
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Authentication error. Please try again.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
