import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _isLogin = true;

  void _submit() {
    final bloc = context.read<AuthBloc>();
    if (_isLogin) {
      bloc.add(AuthLoginRequested(_email.text.trim(), _pass.text.trim()));
    } else {
      bloc.add(AuthRegisterRequested(_email.text.trim(), _pass.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinkColor = Color(0xFFFF2D87);
    final bgColor = Color(0xFF15141B);

    return Scaffold(
      backgroundColor: bgColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isLogin ? 'Sign in to your\nAccount' : 'Register your\nAccount',
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _isLogin ? 'Sign in to Account' : 'Register a new Account',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 48),
                  // Email TextField
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF232230),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      key: const Key('emailField'),
                      controller: _email,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white60),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 18),
                  // Password TextField
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF232230),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      key: const Key('passField'),
                      controller: _pass,
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white60),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        suffixIcon: Icon(Icons.visibility_off, color: Colors.white60),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Forgot Password (only on login)
                  if (_isLogin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Add forgot password logic if needed
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(color: pinkColor, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 24),
                  // Login/Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pinkColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        elevation: 4,
                      ),
                      onPressed: _submit,
                      child: Text(
                        _isLogin ? 'Login' : 'Register',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Register/Sign in action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin ? "Don't have account? " : "Already have account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isLogin = !_isLogin),
                        child: Text(
                          _isLogin ? 'Register' : 'Login',
                          style: TextStyle(color: pinkColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


