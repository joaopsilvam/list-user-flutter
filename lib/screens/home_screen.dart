// Importações principais do Flutter, Provider e seus arquivos do projeto
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_api_app/services/api_service.dart';
import '../providers/user_provider.dart';
import '../widgets/user_tile.dart';
import '../screens/user_form_screen.dart';
import '../screens/login_screen.dart';

// Tela principal onde os usuários são listados
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controlador do campo de busca
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Recupera o provedor de usuários
    final userProvider = Provider.of<UserProvider>(context);

    // Filtra os usuários com base no texto digitado na busca
    final filteredUsers = userProvider.users.where((user) {
      final query = _searchController.text.toLowerCase();
      return user.firstName.toLowerCase().contains(query) ||
             user.lastName.toLowerCase().contains(query) ||
             user.email.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com título e botão de logout
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Usuários',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  // Botão de logout com ícone
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.black, size: 18),
                      onPressed: () {
                        // Volta para a tela de login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Campo de busca
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Pesquisar usuários...',
                  labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
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
                  prefixIcon: const Icon(Icons.search, color: Colors.black, size: 18),
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                onChanged: (_) => setState(() {}), // Atualiza a lista em tempo real
              ),
            ),

            const SizedBox(height: 10),

            // Lista de usuários ou loading
            Expanded(
              child: RefreshIndicator(
                onRefresh: userProvider.loadUsers, // Puxa os dados de novo ao "puxar pra baixo"
                child: userProvider.isLoading
                    ? const Center(child: CircularProgressIndicator()) // Mostra loading
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return UserTile(
                            user: user,
                            // Ao clicar em "Ver mais", navega para tela de edição
                            onEdit: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserFormScreen(user: user),
                                ),
                              );
                              // Se o usuário foi editado, recarrega a lista
                              if (result == true) {
                                await userProvider.loadUsers();
                              }
                            },
                            // Ação de deletar o usuário
                            onDelete: () async {
                              try {
                                await ApiService.deleteUser(user.id);

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Usuário excluído com sucesso')),
                                );

                                await userProvider.loadUsers();
                              } catch (_) {
                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Erro ao excluir usuário')),
                                );
                              }
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),

      // Botão flutuante para adicionar novo usuário
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserFormScreen()),
          );
          if (result == true) {
            await userProvider.loadUsers();
          }
        },
        backgroundColor: Colors.amber[700],
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
