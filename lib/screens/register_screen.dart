// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _authService = AuthService();
  bool _loading = false;
  bool _obscure = true;

  static const _teal = Color(0xFF00C4A0);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMsg('Vui lòng điền đầy đủ thông tin', Colors.red);
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      _showMsg('Mật khẩu không khớp', Colors.red);
      return;
    }
    if (_passwordController.text.length < 6) {
      _showMsg('Mật khẩu tối thiểu 6 ký tự', Colors.red);
      return;
    }

    setState(() => _loading = true);
    try {
      await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        _showMsg('Đăng ký thành công! Vui lòng xác nhận email.', _teal);
        Navigator.pop(context);
      }
    } catch (e) {
      _showMsg('Đăng ký thất bại: ${e.toString()}', Colors.red);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Đăng ký',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildField(_emailController, 'you@example.com',
                  type: TextInputType.emailAddress),
              const SizedBox(height: 24),
              _buildLabel('Mật khẩu'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                decoration: _inputDecoration('Tối thiểu 6 ký tự').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildLabel('Xác nhận mật khẩu'),
              const SizedBox(height: 8),
              _buildField(_confirmController, '••••••••', obscure: true),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('ĐĂNG KÝ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14));

  Widget _buildField(TextEditingController ctrl, String hint,
      {TextInputType? type, bool obscure = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      obscureText: obscure,
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00C4A0), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
