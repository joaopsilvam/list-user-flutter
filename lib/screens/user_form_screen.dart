import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';

// Tela de formulário para criar ou editar um usuário.
// Se um usuário for passado como parâmetro, o formulário entra em modo de edição.
class UserFormScreen extends StatefulWidget {
  final User? user; // Usuário a ser editado (se houver)

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos de texto
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _avatarController = TextEditingController();

  bool _isLoading = false; // Controla o estado de carregamento

  @override
  void initState() {
    // Se for edição, preenche os campos com os dados do usuário
    if (widget.user != null) {
      _firstNameController.text = widget.user!.firstName;
      _lastNameController.text = widget.user!.lastName;
      _emailController.text = widget.user!.email;
      _avatarController.text = widget.user!.avatar;
    }
    super.initState();
  }

  // Função para submeter o formulário
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.user == null) {
        // Criação de novo usuário
        await ApiService.createUser(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          avatar: _avatarController.text,
          job: '',
        );
      } else {
        // Atualização de usuário existente
        await ApiService.updateUser(
          id: widget.user!.id,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          avatar: _avatarController.text,
          job: '',
        );
      }

      // Atualiza a lista de usuários e volta para a tela anterior
      if (context.mounted) {
        await Provider.of<UserProvider>(context, listen: false).loadUsers();
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Mostra erro caso ocorra alguma falha
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Estilo padrão para os campos de input
  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar do usuário
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _avatarController.text.isNotEmpty
                      ? NetworkImage(_avatarController.text)
                      : null,
                  backgroundColor: Colors.grey.shade300,
                  child: _avatarController.text.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 30),

              // Campo: Primeiro Nome
              TextFormField(
                controller: _firstNameController,
                decoration: _fieldDecoration('Primeiro nome'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),

              // Campo: Sobrenome
              TextFormField(
                controller: _lastNameController,
                decoration: _fieldDecoration('Sobrenome'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),

              // Campo: Email
              TextFormField(
                controller: _emailController,
                decoration: _fieldDecoration('Email'),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo obrigatório';
                  if (!value.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo: Avatar
              TextFormField(
                controller: _avatarController,
                decoration: _fieldDecoration('URL do avatar'),
              ),
              const SizedBox(height: 30),

              // Botão de salvar ou indicador de carregamento
              if (_isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Salvar'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
