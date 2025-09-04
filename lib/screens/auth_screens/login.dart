import 'package:ammerha_management/config/responsive/ui_helper.dart';
import 'package:ammerha_management/config/routes/app_routes.dart';
import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/provider/auth_provider.dart';
import 'package:ammerha_management/widgets/auth/password_field.dart';
import 'package:ammerha_management/widgets/auth/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.homePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    // in column ---> we focus in screenHeight when we use mediaQuery
    // in row ---> we focus in screenWidth when we use mediaQuery
    final screenHeight = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);
    // This widget controls the system UI overlay style (e.g., status bar).
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 18,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/logos/logo1.png',
                      height: screenHeight * 0.27,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'تسجيل الدخول',
                        style: GoogleFonts.almarai(
                          fontSize: UIHelpers.getResponsiveFontSize(
                            context,
                            baseSize: 22,
                          ),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'البريد الإلكتروني',
                        style: GoogleFonts.almarai(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'أدخل البريد الإلكتروني',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            ////// هاممممم يجب التعديل من الباك
                            !value.contains('super')) {
                          return 'الرجاء إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'كلمة المرور',
                        style: GoogleFonts.almarai(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomPasswordField(
                      controller: _passwordController,
                      hintText: 'أدخل كلمة المرور',
                      obscureText: _obscureText,
                      onVisibilityToggle: () =>
                          setState(() => _obscureText = !_obscureText),
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return 'كلمة المرور يجب أن تكون ٦ محارف على الأقل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: GoogleFonts.almarai(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              side: const BorderSide(color: AppColors.greyText),
                              onChanged: (val) =>
                                  setState(() => _rememberMe = val!),
                            ),
                            Text(
                              'تذكرني',
                              style: GoogleFonts.almarai(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (authProvider.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          authProvider.errorMessage!,
                          style: GoogleFonts.almarai(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: authProvider.isLoading ? null : _submitLogin,
                        child: authProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'تسجيل الدخول',
                                style: GoogleFonts.almarai(
                                  fontSize: UIHelpers.getResponsiveFontSize(
                                    context,
                                    baseSize: 16,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
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
