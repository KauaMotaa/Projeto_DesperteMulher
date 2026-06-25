import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:troca_contexto/common/storage_keys.dart';
import '../../common/app_routes.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  late BuildContext pageContext;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    pageContext = context;

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Login'),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTitle(),
          const SizedBox(height: 32),
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 24),
          _buildLoginButton(),
          const SizedBox(height: 24),
          _buildRegisterLink(pageContext),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Acesse sua conta',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Senha',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _onLoginPressed,
        child: const Text('Entrar'),
      ),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => _openRegistrationPage(context),
        child: const Text(
          'Criar nova conta',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _openRegistrationPage(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.registerPage);
  }

  Future<void> _onLoginPressed() async {

    if (passwordController.text.isEmpty || emailController.text.isEmpty) {
      return;
    }
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final String email = preferences.getString(StorageKeys.email) ?? "";
    final String password = preferences.getString(StorageKeys.password) ?? "";

    if (passwordController.text == password && emailController.text == email) {
      Navigator.pushNamed(pageContext, AppRoutes.profilePage);
    }
  }
}