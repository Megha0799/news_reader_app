import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import 'package:news_reader_app/common/utils/colors.dart';
import 'package:news_reader_app/common/utils/screen_utils.dart';
import 'package:news_reader_app/common/widgets/common_button.dart';
import 'package:news_reader_app/common/widgets/common_style.dart';
import 'package:news_reader_app/common/widgets/common_textfiled.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _obscurePassword = true;
  String? _loginError;
  String? _passwordError;
  String? _nameError;


  bool _validateLogin(String value) {
    if (value.isEmpty) {
      setState(() => _loginError = 'Email is required');
      return false;
    }

    // Check if input is email
    bool isEmail = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value);
  

    if (!isEmail) {
      setState(
        () =>
            _loginError =
                'Please enter a valid email',
      );
      return false;
    }

    setState(() => _loginError = null);
    return true;
  }

  bool _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      return false;
    }
    if (value.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      return false;
    }
    setState(() => _passwordError = null);
    return true;
  }

bool _validateName(String value) {
  if (value.isEmpty) {
    setState(() => _nameError = 'Name is required');
    return false;
  }
  setState(() => _nameError = null);
  return true;
}

  Future<void> _handleLogin() async {
    debugPrint('Login button pressed');
    final loginValid = _validateLogin(_loginController.text);
    final passwordValid = _validatePassword(_passwordController.text);
    final nameValid = _validateName(_nameController.text);
final prefs = await SharedPreferences.getInstance();

  
    await prefs.setString('user_email', _loginController.text);
    await prefs.setString('store_name', _nameController.text);

   
    if (!mounted) return;

    if (loginValid && passwordValid && nameValid) {

     GoRouter.of(context).go('/home');
      _loginController.clear();
    _passwordController.clear();
    _nameController.clear();
  }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AppColor.bodyColor,
      body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.getHorizontalSize(
                  context,
                  ScreenUtils.paddingSL,
                ),
              ),
              child: Card(
                color: AppColor.backgroundColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: AppColor.softAquaColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtils.getHorizontalSize(
                            context,
                            ScreenUtils.paddingL,
                          ),
                          vertical: ScreenUtils.getVerticalSize(
                            context,
                            ScreenUtils.paddingXS,
                          ),
                        ),
                        child: Text(
                          'Welcome to News Reader App',
                          textAlign: TextAlign.center,
                          style: CustomStyles.boldTextStyle(
                            color: AppColor.listtextColor,
                            fontSize: ScreenUtils.getFontSize(
                              context,
                              CustomStyles.size18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtils.getVerticalSize(
                          context,
                          ScreenUtils.heightXXL,
                        ),
                      ),


                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            hintText: 'Enter name',
                            keyboardType: TextInputType.text,
                          ),
                          if (_nameError != null)
                            Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtils.getHorizontalSize(
                                  context,
                                  ScreenUtils.paddingS,
                                ),
                                top: ScreenUtils.getVerticalSize(
                                  context,
                                  ScreenUtils.heightXS,
                                ),
                              ),
                              child: Text(
                                _nameError!,
                                style: TextStyle(
                                  fontFamily: CustomStyles.primaryFont,
                                  color: AppColor.redColor,
                                  fontSize: ScreenUtils.getFontSize(
                                    context,
                                    CustomStyles.size12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                       
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: _loginController,
                            hintText: 'Enter Email',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          if (_loginError != null)
                            Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtils.getHorizontalSize(
                                  context,
                                  ScreenUtils.paddingS,
                                ),
                                top: ScreenUtils.getVerticalSize(
                                  context,
                                  ScreenUtils.heightXS,
                                ),
                              ),
                              child: Text(
                                _loginError!,
                                style: TextStyle(
                                  fontFamily: CustomStyles.primaryFont,
                                  color: AppColor.redColor,
                                  fontSize: ScreenUtils.getFontSize(
                                    context,
                                    CustomStyles.size12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Enter Password',
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColor.unselectTextColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          
                          if (_passwordError != null)
                            Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtils.getHorizontalSize(
                                  context,
                                  ScreenUtils.paddingS,
                                ),
                                top: ScreenUtils.getVerticalSize(
                                  context,
                                  ScreenUtils.heightXS,
                                ),
                              ),
                              child: Text(
                                _passwordError!,
                                style: TextStyle(
                                  fontFamily: CustomStyles.primaryFont,
                                  color: AppColor.redColor,
                                  fontSize: ScreenUtils.getFontSize(
                                    context,
                                    CustomStyles.size12,
                                  ),
                                ),
                              ),
                            ),

                          
                        ],
                      ),
                     
                      SizedBox(
                        height: ScreenUtils.getVerticalSize(
                          context,
                          ScreenUtils.heightL,
                        ),
                      ),
                      CustomButton(
                         textColor: Colors.white,
                        fontSize: ScreenUtils.getFontSize(
                          context,
                          CustomStyles.size18,
                        ),
                        height: ScreenUtils.getVerticalSize(context, 50),
                        onPressed: _handleLogin,
                        text: 'Login',
                      ),
                     
                      SizedBox(
                        height: ScreenUtils.getVerticalSize(
                          context,
                          ScreenUtils.heightL,
                        ),
                      ),
                    SizedBox(
                        height: ScreenUtils.getVerticalSize(
                          context,
                          ScreenUtils.heightM,
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
  }


}
