import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

// Classe responsável por toda a comunicação com a API externa
class ApiService {
  // Base URL da API — é a raiz usada por todos os endpoints
  static const String baseUrl = 'https://68365078664e72d28e406dd1.mockapi.io/api/v1';

  // Método para buscar a lista de usuários (GET /users)
  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    // Se a requisição for bem-sucedida (HTTP 200), convertemos os dados em uma lista de objetos User
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar usuários'); // Em caso de erro, lançamos uma exceção
    }
  }

  // Método para criar um novo usuário (POST /users)
  static Future<void> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String avatar,
    required String job,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        // Se o avatar estiver vazio, usamos um avatar gerado automaticamente com base no timestamp
        'avatar': avatar.isNotEmpty
            ? avatar
            : 'https://i.pravatar.cc/150?u=${DateTime.now().millisecondsSinceEpoch}',
        'job': job,
      }),
    );

    // O status HTTP esperado para criação é 201 (Created)
    if (response.statusCode != 201) {
      throw Exception('Erro ao criar usuário');
    }
  }

  // Método para atualizar um usuário existente (PUT /users/:id)
  static Future<void> updateUser({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String avatar,
    required String job,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'avatar': avatar,
        'job': job,
      }),
    );

    // Esperamos um status 200 indicando sucesso na atualização
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar usuário');
    }
  }

  // Método para deletar um usuário pelo ID (DELETE /users/:id)
  static Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));

    // O sucesso é indicado por status 200
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar usuário');
    }
  }

  // Método de login simulado (GET /auth?email=...&password=...)
  // Esse método busca um "usuário" falso com base no email e senha
  static Future<String> login(String email, String password) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth?email=$email&password=$password'),
    );

    // Se a requisição for bem-sucedida e retornarmos uma lista com dados...
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        // Retornamos o token simulado
        return data[0]['token'];
      } else {
        throw Exception('Credenciais inválidas');
      }
    } else {
      throw Exception('Erro ao fazer login');
    }
  }
}
