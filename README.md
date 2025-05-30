# 📱 User API App - Flutter

Este é um aplicativo Flutter que consome uma API REST mockada para realizar operações de **CRUD de usuários**, com interface moderna e responsiva. O projeto utiliza `Provider` para gerenciamento de estado e segue boas práticas de organização de código.

## 🚀 Funcionalidades

- Listagem de usuários
- Busca em tempo real
- Adição de novo usuário
- Edição de usuário existente
- Exclusão de usuário
- Login simulado (fake login)
- Layout estilizado com Material Design

## 🔗 API Utilizada

Os dados são consumidos da seguinte API pública de mock:

```
https://68365078664e72d28e406dd1.mockapi.io/api/v1/users
```

> ⚠️ A API não possui endpoint real de autenticação. O login é simulado no app.

## 🧱 Estrutura do Projeto

```bash
lib/
├── models/            # Modelo de dados do usuário
├── providers/         # Provider para gerenciamento de usuários
├── screens/           # Telas principais do app
│   ├── home_screen.dart
│   ├── login_screen.dart
│   └── user_form_screen.dart
├── services/          # Serviços de API
├── widgets/           # Componentes reutilizáveis (UserTile)
└── main.dart          # Entry point
```

## 🛠 Tecnologias

- Flutter
- Provider
- HTTP package
- Material Design

## ▶️ Como rodar o projeto

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/user-api-app.git
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Rode o app:
```bash
flutter run
```

## 📄 Licença

Este projeto está sob a licença MIT.
