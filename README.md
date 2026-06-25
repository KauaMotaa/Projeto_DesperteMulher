# Quiz Flutter App

Um aplicativo de Quiz dinâmico e interativo desenvolvido em **Flutter**. O projeto foca em uma arquitetura limpa e escalável, oferecendo uma experiência fluida com autenticação, perfis de usuário e questionários gerados a partir de dados em formato JSON.

## 🚀 Funcionalidades

*   **Autenticação de Usuários:** Telas dedicadas para Login (`login_page.dart`) e Registro (`register_page.dart`).
*   **Gestão de Perfil:** Área exclusiva para o usuário (`profile_page.dart`) com suporte a visualização/gerenciamento de fotos (`photo_page.dart`).
*   **Sistema de Quiz Customizado:** 
    *   Consome dados estruturados (perguntas e respostas) a partir de mocks locais (`page1.json`, `page2.json`, `page3.json`).
    *   Widgets exclusivos durante o jogo, como o medidor de risco (`risk_meter.dart`) e opções de saída rápida (`quick_exit.dart`).
*   **Resultados:** Tela de consolidação para exibir o desempenho final do usuário após o término das perguntas (`result_page.dart`).
*   **Suporte Multiplataforma:** Configurado nativamente para rodar em Android, iOS, Web, Windows, macOS e Linux.

## 📂 Estrutura do Projeto

A base de código (`lib/`) está dividida de forma modular para facilitar a manutenção e escalabilidade:

*   `Models/`: Estruturação das entidades de dados da aplicação (`answer.dart`, `question.dart`, `quiz_page.dart`).
*   `Screens/`: Contém toda a interface do usuário (UI), dividida por módulos (Demo, Login, Registration, Profile, Photo, Quiz, Result).
*   `common/`: Arquivos de configuração global e utilitários compartilhados:
    *   `app_theme.dart`: Padronização visual e cores do aplicativo.
    *   `app_routes.dart` & `route_manager.dart`: Gerenciamento unificado da navegação entre telas.
    *   `storage_keys.dart`: Constantes e chaves para armazenamento local de dados.
*   `assets/Mock/`: Arquivos JSON que simulam o retorno de uma API para alimentar as páginas do quiz.

## 💻 Pré-requisitos

Antes de começar, certifique-se de ter o ambiente configurado:

*   [Flutter SDK](https://docs.flutter.dev/get-started/install)
*   Dart
*   Um emulador (Android/iOS) ou um dispositivo físico configurado para testes.

## 🛠️ Como Rodar o Projeto

* flutter run -d chrome
