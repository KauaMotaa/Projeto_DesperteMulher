/*
Nome: CreateMaterialApp()
Descrição: Cria o objeto MaterialApp com as rotas. Escuta o ThemeController
para alternar entre o tema normal e o de alto contraste em tempo real.
Autor: Silvano Malfatti (base) / ajustado
Data: 13/06/2026
 */

import 'package:flutter/material.dart';
import '../Screens/quiz/quiz_page.dart';
import '../Screens/login/login_page.dart';
import '../Screens/photo/photo_page.dart';
import '../Screens/profile/profile_page.dart';
import '../Screens/registration/register_page.dart';
import '../Screens/result/result_page.dart';
import 'app_routes.dart';
import 'app_theme.dart';

Widget createMaterialApp() {
  return ValueListenableBuilder<bool>(
    valueListenable: ThemeController.highContrast,
    builder: (context, isHighContrast, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Desperte Mulher',
        theme: isHighContrast ? AppTheme.highContrast : AppTheme.light,
        initialRoute: AppRoutes.quizPage,
        routes: {
          AppRoutes.loginPage: (_) => LoginPage(),
          AppRoutes.profilePage: (_) => ProfilePage(),
          AppRoutes.registerPage: (_) => RegisterPage(),
          AppRoutes.photoPage: (_) => SelectPhotoPage(),
          AppRoutes.quizPage: (_) => const QuizPage(),
          AppRoutes.resultPage: (_) => const ResultPage(),
        },
      );
    },
  );
}
