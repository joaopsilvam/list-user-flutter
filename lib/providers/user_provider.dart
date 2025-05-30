import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

// Provider responsável por gerenciar o estado da lista de usuários na aplicação
class UserProvider extends ChangeNotifier {
  // Lista privada que armazena os usuários carregados da API
  List<User> _users = [];

  // Flag para indicar se os dados estão sendo carregados (usado para mostrar loaders/spinners)
  bool _isLoading = false;

  // Getters públicos para acessar os dados de fora da classe
  List<User> get users => _users;
  bool get isLoading => _isLoading;

  // Função assíncrona que busca os usuários da API
  Future<void> loadUsers() async {
    _isLoading = true;         // Indicamos que o carregamento começou
    notifyListeners();         // Avisamos os widgets que o estado mudou (para exibir um loader, por exemplo)

    try {
      _users = await ApiService.fetchUsers();  // Tentamos buscar os dados da API
    } catch (_) {
      _users = [];                             // Em caso de erro, limpamos a lista (poderia também tratar o erro de forma mais detalhada)
    }

    _isLoading = false;        // Finalizamos o carregamento
    notifyListeners();         // Avisamos novamente os widgets para que atualizem a UI com os novos dados
  }
}
