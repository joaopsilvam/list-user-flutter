// Importações básicas necessárias
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user_api_app/services/api_service.dart';

// Tela de login principal. Stateless pois não precisa armazenar estado interno complexo.
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // Controladores para preencher automaticamente os campos com valores de teste
  final TextEditingController emailController =
      TextEditingController(text: 'Keanu_Rice@gmail.com');
  final TextEditingController senhaController =
      TextEditingController(text: 'GIlyy99LOFFgR7K');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[700],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          // Botão de "Cadastre-se" no canto superior direito
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {}, // Ainda não implementado
                  child: const Text("Cadastre-se", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),

          // Título e descrição de boas-vindas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Entrar", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                  "Acesse sua conta para continuar usando o aplicativo.",
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Container branco com cantos arredondados para o conteúdo do formulário
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Campo de e-mail
                    _InputField(label: 'E-mail', controller: emailController),

                    const SizedBox(height: 12),

                    // Campo de senha com opção de visualizar o conteúdo
                    _InputField(
                      label: 'Senha',
                      controller: senhaController,
                      obscureText: true,
                    ),

                    // Link de "esqueceu a senha"
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Esqueceu a senha?",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botão "Entrar"
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () async {
                          final email = emailController.text.trim();
                          final senha = senhaController.text.trim();

                          try {
                            // Tenta logar com a API fake
                            final token = await ApiService.login(email, senha);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login realizado com sucesso!')),
                            );
                            // Redireciona para a home após o login
                            Navigator.pushReplacementNamed(context, '/home');
                          } catch (e) {
                            // Mostra erro se login falhar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erro ao realizar login.')),
                            );
                          }
                        },
                        child: const Text("Entrar", style: TextStyle(color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Botão de login com Google
                    _SocialButton(
                      label: 'Continuar com Google',
                      imagePath: 'assets/images/google.png',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funcionalidade ainda não implementada.')),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Botão de login com Facebook
                    _SocialButton(
                      label: 'Continuar com Facebook',
                      imagePath: 'assets/images/facebook.png',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funcionalidade ainda não implementada.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget reutilizável para campos de entrada (e-mail e senha)
class _InputField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;

  const _InputField({
    required this.label,
    required this.controller,
    this.obscureText = false,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: isObscured,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(color: Colors.black),
        floatingLabelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black),
        ),
        // Ícone para mostrar/ocultar senha
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                  size: 15,
                ),
                onPressed: () => setState(() => isObscured = !isObscured),
              )
            : null,
      ),
    );
  }
}

// Botões sociais para login (Google e Facebook)
class _SocialButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Image.asset(imagePath, height: 24, width: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
